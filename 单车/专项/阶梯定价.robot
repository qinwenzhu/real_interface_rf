*** Settings ***
Documentation     todo
...               1、曼哈顿车辆
...               2、userguid不存在，需要改变userGUid值
...               3、user已存在订单，需要更新redis缓存值
Suite Setup       run keywords    app登陆    ${激活用户_曼哈顿}
...               AND    获取userNewId
...               AND    获取用户信息
...               AND    用户充值    ${激活用户_曼哈顿}    5000
Test Setup
Default Tags      AppHellobikeRideApiService
Resource          ../../资源配置/一键导入配置.resource
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem

*** Test Cases ***
# =======首次减免&阶梯定价=============
1.1_普通曼哈顿区外到区外_首次减免
    admin后台配置    forbidParkingAreaSettings_2-3yuan.json    #更新配置首次减免,调度费2元
    清除用户违规停车次数    parkInOutAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1104
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    2
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should contain    ${payDetails}    首次区外调度费减免
    should contain    ${payDetails}    'value': '2'
    should contain    ${payDetails}    'value': '-2'
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1104
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    2
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    首次区外调度费减免
    should contain    ${payDetails}    区外调度费
    should contain    ${payDetails}    'value': '2'
    should not contain    ${payDetails}    'value': '-2'
    # 调度费为0元
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.2_普通曼哈顿曼哈顿_区内到区外首次减免
    admin后台配置    forbidParkingAreaSettings_2-3yuan.json    #更新配置首次减免,调度费2元
    清除用户违规停车次数    parkInOutAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${纬度_抚州_P点}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1103
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    1
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should contain    ${payDetails}    'value': '-1'
    should contain    ${payDetails}    'value': '1'
    should contain    ${payDetails}    首次超区调度费减免
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1103
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    1
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    首次超区调度费减免
    should contain    ${payDetails}    超区调度费
    should not contain    ${payDetails}    'value': '-1'
    should contain    ${payDetails}    'value': '1'
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.3_普通曼哈顿规范停车区_收阶梯调度费
    admin后台配置    normParkingAreaSettings_6-7yuan.json    #更新配置：第1次 0元，第2次 6元 第3次 7元
    清除用户违规停车次数    parkInForbiddenAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1102
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    6
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    首次调度费减免
    should contain    ${payDetails}    'value': '-7'
    should contain    ${payDetails}    'value': '7'
    should contain    ${payDetails}    违规停车调度费
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1102
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    6
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费减免
    should not contain    ${payDetails}    'value': '-6'
    should contain    ${payDetails}    'value': '6'
    should contain    ${payDetails}    违规停车调度费
    # 第三次
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1102
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    7
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费减免
    should not contain    ${payDetails}    'value': '-7'
    should contain    ${payDetails}    'value': '7'
    should contain    ${payDetails}    违规停车调度费
    # 禁停区
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.4_普通曼哈顿禁停区_阶梯收调度费
    admin后台禁停区配置    forbidParkingAreaSettings_2-3yuan.json    #更新配置第1次 0元，第2次 2元，第3次 3元
    清除用户违规停车次数    parkInForbiddenAreaParkTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1101
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    2
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    首次禁停区调度费减免
    should contain    ${payDetails}    'value': '2'
    should contain    ${payDetails}    'value': '-2'
    should contain    ${payDetails}    禁停区调度费
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1101
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    2
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 第二次收费
    should not contain    ${payDetails}    首次禁停区调度费减免
    should contain    ${payDetails}    禁停区调度费
    should contain    ${payDetails}    'value': '2'
    should not contain    ${payDetails}    'value': '-2'
    # 第三次
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1101
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    3
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 第三次收费
    should not contain    ${payDetails}    首次禁停区调度费减免
    should contain    ${payDetails}    禁停区调度费
    should contain    ${payDetails}    'value': '3'
    should not contain    ${payDetails}    'value': '-3'
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# ======调度费为0元=======
2.1_普通曼哈顿区外到区外_调度费为0元
    admin后台配置    OutAreaSettings_0yuan.json    #更新配置调度费为0元
    清除用户违规停车次数    parkInOutAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1104
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should not contain    ${payDetails}    首次区外调度费减免
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1104
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    首次区外调度费减免
    should not contain    ${payDetails}    区外调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.2_普通曼哈顿曼哈顿_区内到区外_调度费为0元
    admin后台配置    OutAreaSettings_0yuan.json    #更新配置调度费为0元
    清除用户违规停车次数    parkInOutAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${纬度_抚州_P点}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1103
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should not contain    ${payDetails}    首次超区调度费减免
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1103
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 第二次收费
    should not contain    ${payDetails}    首次超区调度费减免
    should not contain    ${payDetails}    超区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.3_普通曼哈顿规范停车区_调度费为0元
    admin后台配置    OutAreaSettings_0yuan.json    #更新配置调度费为0元
    清除用户违规停车次数    parkInForbiddenAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1102
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should not contain    ${payDetails}    调度费减免
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1102
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费减免
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.4_普通曼哈顿禁停区_调度费为0元
    admin后台禁停区配置    forbidParkingAreaSettings_0yuan.json    #更新配置调度费为0元
    清除用户违规停车次数    parkInForbiddenAreaParkTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1101
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should not contain    ${payDetails}    首次禁停区调度费减免
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1101
    should be Equal as Numbers    ${data}[penaltyFree]    1
    should be Equal as Numbers    ${data}[penalty]    0
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 第二次收费
    should not contain    ${payDetails}    首次禁停区调度费减免
    should not contain    ${payDetails}    禁停区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# =====首次收费=====
3.1_普通曼哈顿区外到区外_首次收费
    admin后台配置    OutAreaSettings.json    #更新配置首次收费 2元
    清除用户违规停车次数    parkInOutAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1104
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    2
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should not contain    ${payDetails}    首次区外调度费减免
    should contain    ${payDetails}    区外调度费
    should contain    ${payDetails}    'value': '2'
    should not contain    ${payDetails}    'value': '-2'
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1104
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    2
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    首次区外调度费减免
    should contain    ${payDetails}    区外调度费
    should contain    ${payDetails}    'value': '2'
    should not contain    ${payDetails}    'value': '-2'
    # 区内到区外
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.2_普通曼哈顿曼哈顿_区内到区外首次收费
    admin后台配置    OutAreaSettings.json    #更新配置首次收费，调度费1元
    清除用户违规停车次数    parkInOutAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${纬度_抚州_P点}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1103
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    1
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 首次减免
    should not contain    ${payDetails}    'value': '-1'
    should contain    ${payDetails}    'value': '1'
    should not contain    ${payDetails}    首次超区调度费减免
    should contain    ${payDetails}    超区调度费
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${经度_抚州_超区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1103
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    1
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    首次超区调度费减免
    should contain    ${payDetails}    超区调度费
    should contain    ${payDetails}    'value': '1'
    # 规范停车区
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.3_普通曼哈顿规范停车区_首次收费
    admin后台配置    normParkingAreaSettings_2.json    #更新配置首次收费 7元
    清除用户违规停车次数    parkInForbiddenAreaTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1102
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    7
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费减免
    should not contain    ${payDetails}    'value': '-7'
    should contain    ${payDetails}    'value': '7'
    should contain    ${payDetails}    违规停车调度费
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1102
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    7
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费减免
    should not contain    ${payDetails}    'value': '-7'
    should contain    ${payDetails}    'value': '7'
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.4_普通曼哈顿禁停区_首次收调度费
    admin后台禁停区配置    forbidParkingAreaSettings.json    #更新配置第1次 6元
    清除用户违规停车次数    parkInForbiddenAreaParkTimesKey
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1101
    # 首次返回第二次收调度费的金额    penaltyFree    1：免费，0：收费
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    6
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    首次禁停区调度费减免
    should contain    ${payDetails}    禁停区调度费
    should not contain    ${payDetails}    'value': '-6'
    should contain    ${payDetails}    'value': '6'
    # 第二次
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_data}    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    ${data}    get from dictionary    ${rep_data}    data
    should be Equal as Numbers    ${data}[causeType]    1101
    should be Equal as Numbers    ${data}[penaltyFree]    0
    should be Equal as Numbers    ${data}[penalty]    6
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    # 第二次收费
    should not contain    ${payDetails}    首次禁停区调度费减免
    should contain    ${payDetails}    禁停区调度费
    should not contain    ${payDetails}    'value': '-6'
    should contain    ${payDetails}    'value': '6'
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}
