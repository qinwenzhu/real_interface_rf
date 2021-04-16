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