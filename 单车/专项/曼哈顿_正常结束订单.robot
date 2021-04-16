*** Settings ***
Documentation     todo
...               1、
Suite Setup       run keywords    app登陆    ${激活用户_曼哈顿}
...               AND    获取userNewId
...               AND    获取用户信息
...               AND    用户充值    ${激活用户_曼哈顿}    20000
Test Setup
Default Tags      AppHellobikeRideApiService
Resource          ../../资源配置/一键导入配置.resource
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem

*** Test Cases ***
# 曼哈顿正常结束订单-后台配置：蓝牙道钉+电子围栏&调度费
1.1_车从区内到区外_无蓝牙信号_用户在非P点_还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.2_车从区内到区外_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.3_车从区内到区外_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.4_车从区内到区外_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.5_车从区外到区外_无蓝牙信号_用户在非P点_还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.6_车从区外到区外_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.7_车从区外到区外_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.8_车从区外到区外_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.9_车在禁停区_无蓝牙信号_用户在非P点_还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.10_车在禁停区_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.11_车在禁停区_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.12_车在可停车区_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.13_车在可停车区_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.14_车在可停车区_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.15_车在可停车区_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.16_车在非P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.17_车在非P点_无蓝牙信号_用户在禁停区_收禁停区调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    禁停区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.18_车在非P点_无蓝牙信号_用户在非P点_收规范停车区调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.19_车在非P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.20_车在非P点_无蓝牙信号_用户从区内到区外_收区内到区外调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    超区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.21_车在非P点_无蓝牙信号_用户从区外到区外_收区外到区外调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    causeType    1104
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    区外调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.22_车在非P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_1.23_车在非P点_有蓝牙信号_用户在禁停区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_1.24_车在非P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.25_车在非P点_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    #上报蓝牙信号    ${bikeNo}    ${有蓝牙信号}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_1.26_车在非P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_1.27_车在非P点_有蓝牙信号_用户从区外到区外_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.28_车在P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.29_车在P点_无蓝牙信号_用户在禁停区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.30_车在P点_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.31_车在P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.32_车在P点_无蓝牙信号_用户从区内到区外_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.33_车在P点_无蓝牙信号_用户从区外到区外_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.34_车在P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.35_车在P点_有蓝牙信号_用户在禁停区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.36_车在P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.37_车在P点_有蓝牙信号_用户P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.38_车在P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.39_车在P点_有蓝牙信号_用户从区外到区外_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.40_车在禁停区_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# 曼哈顿正常结束订单-后台配置：蓝牙道钉+电子围栏&调度费+车锁弹开
2.1_车从区内到区外_无蓝牙信号_用户在非P点_还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.2_车从区内到区外_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.3_车从区内到区外_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.4_车从区内到区外_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.5_车从区外到区外_无蓝牙信号_用户在非P点_还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.6_车从区外到区外_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.7_车从区外到区外_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.8_车从区外到区外_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.9_车在禁停区_无蓝牙信号_用户在非P点_还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.10_车在禁停区_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.11_车在禁停区_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.12_车在可停车区_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.13_车在可停车区_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.14_车在可停车区_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.15_车在可停车区_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.16_车在非P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.17_车在非P点_无蓝牙信号_用户在禁停区_收禁停区调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    禁停区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.18_车在非P点_无蓝牙信号_用户在非P点_收规范停车区调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.19_车在非P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.20_车在非P点_无蓝牙信号_用户从区内到区外_收区内到区外调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    超区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.21_车在非P点_无蓝牙信号_用户从区外到区外_收区外到区外调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    causeType    1104
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    区外调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.22_车在非P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_2.23_车在非P点_有蓝牙信号_用户在禁停区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_2.24_车在非P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.25_车在非P点_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    #上报蓝牙信号    ${bikeNo}    ${有蓝牙信号}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_2.26_车在非P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

fail_2.27_车在非P点_有蓝牙信号_用户从区外到区外_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.28_车在P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.29_车在P点_无蓝牙信号_用户在禁停区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.30_车在P点_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.31_车在P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.32_车在P点_无蓝牙信号_用户从区内到区外_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.33_车在P点_无蓝牙信号_用户从区外到区外_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.34_车在P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.35_车在P点_有蓝牙信号_用户在禁停区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.36_车在P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.37_车在P点_有蓝牙信号_用户P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.38_车在P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.39_车在P点_有蓝牙信号_用户从区外到区外_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.40_车在禁停区_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# 普通曼哈顿骑到高校_正常结束订单-后台配置：蓝牙道钉+电子围栏&调度费
3.1_车在可停车区_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.2_车在可停车区_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.3_车在可停车区_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.4_车在可停车区_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.5_车在非P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.6_车在非P点_无蓝牙信号_用户在非P点_收规范停车区调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0    
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.7_车在非P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.8_车在非P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.9_车在非P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.10_车在非P点_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.11_车在P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.12_车在P点_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.13_车在P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.14_车在P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.15_车在P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.16_车在P点_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# 普通曼哈顿骑到高校_正常结束订单-后台配置：蓝牙道钉+电子围栏&调度费+车锁弹开
4.1_车在可停车区_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.2_车在可停车区_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.3_车在可停车区_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.4_车在可停车区_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.5_车在非P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.6_车在非P点_无蓝牙信号_用户在非P点_收规范停车区调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0    
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.7_车在非P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.8_车在非P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.9_车在非P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.10_车在非P点_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.11_车在P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.12_车在P点_无蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.13_车在P点_无蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.14_车在P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.15_车在P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.16_车在P点_有蓝牙信号_用户在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# 高校曼哈顿_正常结束订单-后台配置：蓝牙道钉+电子围栏&调度费
5.1_车在可停车区_无蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.2_车在可停车区_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.3_车在可停车区_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.4_车在可停车区_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.5_车在非P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.7_车在非P点_无蓝牙信号_用户在非P点_收规范停车区调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    auseType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.8_车在非P点_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.9_车在非P点_无蓝牙信号_用户从区内到区外_收超区调度费  
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    auseType    1103
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.10_车在非P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.11_车在非P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.12_车在非P点_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.13_车在非P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}     ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.14_车在P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}     ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.15_车在P点_无蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.16_车在P点_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.17_车在P点_无蓝牙信号_用户从区内到区外_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}     0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.18_车在P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.19_车在P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.20_车在P点_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.21_车在P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.22_车从区内到区外_无蓝牙信号_用户在非P点_收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.23_车从区内到区外_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.24_车从区内到区外_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

5.25_车从区内到区外_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}


# 高校曼哈顿_正常结束订单-后台配置：蓝牙道钉+电子围栏&调度费+车锁弹开
6.1_车在可停车区_无蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.2_车在可停车区_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.3_车在可停车区_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.4_车在可停车区_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.5_车在非P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.7_车在非P点_无蓝牙信号_用户在非P点_收规范停车区调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    auseType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.8_车在非P点_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.9_车在非P点_无蓝牙信号_用户从区内到区外_收超区调度费  
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    auseType    1103
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.10_车在非P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.11_车在非P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.12_车在非P点_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.13_车在非P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}     ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.14_车在P点_无蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}     ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.15_车在P点_无蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.16_车在P点_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.17_车在P点_无蓝牙信号_用户从区内到区外_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置     ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}     0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.18_车在P点_有蓝牙信号_用户在可停车区_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.19_车在P点_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.20_车在P点_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.21_车在P点_有蓝牙信号_用户从区内到区外_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.22_车从区内到区外_无蓝牙信号_用户在非P点_收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.23_车从区内到区外_无蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.24_车从区内到区外_有蓝牙信号_用户在非P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

6.25_车从区内到区外_有蓝牙信号_用户在P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String    ${rep_payDetails}
    should not contain    ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}