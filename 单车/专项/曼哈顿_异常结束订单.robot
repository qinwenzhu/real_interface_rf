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
# 超时结束订单_后台配置：蓝牙道钉+电子围栏&调度费
1.1_普通曼哈顿_车在可停区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.2_普通曼哈顿_车在蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_蓝牙框内}    lat=${纬度_抚州_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.3_普通曼哈顿_车在非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.4_普通曼哈顿_车在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.5_普通曼哈顿_车在单基站_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    endChannel=4    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.6_普通曼哈顿_车在禁停区_收禁停区调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    禁停区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.7_普通曼哈顿_车在从区内到区外_收区内到区外区调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    超区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.8_普通曼哈顿_车在从区外到区外__收区外到区外区调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    区外调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.9_普通曼哈顿_车在高校区的可停区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${rep_payDetails_s}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.10_普通曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.11_普通曼哈顿_车在高校区的非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.12_普通曼哈顿_车在高校区的P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.13_高校曼哈顿_车在高校区的P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.14_高校曼哈顿_车在高校区的蓝牙框外非P点_收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.15_高校曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.16_高校曼哈顿_车在位置为单基站_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    endChannel=4    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain    ${payDetails}    车费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.17_高校曼哈顿_车在从区内到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain     ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

1.18_高校曼哈顿_车在从区到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    endChannel=4
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_超区}    lat=${纬度_抚州_高校曼哈顿自动化测试_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# 超时结束订单_后台配置：蓝牙道钉+电子围栏&调度费+车锁弹开
2.1_普通曼哈顿_车在可停区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.2_普通曼哈顿_车在蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_蓝牙框内}    lat=${纬度_抚州_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.3_普通曼哈顿_车在非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.4_普通曼哈顿_车在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.5_普通曼哈顿_车在单基站_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    endChannel=4    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.6_普通曼哈顿_车在禁停区_收禁停区调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    禁停区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.7_普通曼哈顿_车在从区内到区外_收区内到区外区调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    超区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.8_普通曼哈顿_车在从区外到区外__收区外到区外区调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    区外调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.9_普通曼哈顿_车在高校区的可停区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${rep_payDetails_s}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.10_普通曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.11_普通曼哈顿_车在高校区的非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.12_普通曼哈顿_车在高校区的P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.13_高校曼哈顿_车在高校区的P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.14_高校曼哈顿_车在高校区的蓝牙框外非P点_收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.15_高校曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.16_高校曼哈顿_车在位置为单基站_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    endChannel=4    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain    ${payDetails}    车费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.17_高校曼哈顿_车在从区内到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain     ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2.18_高校曼哈顿_车在从区到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    endChannel=4
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_超区}    lat=${纬度_抚州_高校曼哈顿自动化测试_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    endChannel=4
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# 强制关锁结束订单_后台配置：蓝牙道钉+电子围栏&调度费
3.1_普通曼哈顿_车在可停区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${rep_payDetails_s}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.2_普通曼哈顿_车在蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_蓝牙框内}    lat=${纬度_抚州_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.3_普通曼哈顿_车在非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.4_普通曼哈顿_车在P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.5_普通曼哈顿_车在单基站_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    reason=19    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.5_普通曼哈顿_车在禁停区_收禁停区调度费
    admin后台配置    normParkingAreaSettings_3.json
    admin后台禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    禁停区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.6_普通曼哈顿_车在从区内到区外_收区内到区外区调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    超区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.7_普通曼哈顿_车在从区外到区外__收区外到区外区调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    区外调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.8_普通曼哈顿_车在高校区的可停区_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${rep_payDetails_s}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.9_普通曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.10_普通曼哈顿_车在高校区的非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.11_普通曼哈顿_车在高校区的P点_不收调度费
    admin后台配置    normParkingAreaSettings_3.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.12_高校曼哈顿_车在高校区的P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.13_高校曼哈顿_车在高校区的蓝牙框外非P点_收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.14_高校曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}


3.15_高校曼哈顿_车在位置为单基站_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    reason=19    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain    ${payDetails}    车费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.16_高校曼哈顿_车在从区内到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain     ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

3.17_高校曼哈顿_车在从区到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_3.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    reason=19
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_超区}    lat=${纬度_抚州_高校曼哈顿自动化测试_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

# 强制关锁结束订单_后台配置：蓝牙道钉+电子围栏&调度费+车锁弹开
4.1_普通曼哈顿_车在可停区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_可停车区}    lat=${纬度_抚州_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${rep_payDetails_s}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.2_普通曼哈顿_车在蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_蓝牙框内}    lat=${纬度_抚州_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_蓝牙框内}    ${纬度_抚州_蓝牙框内}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.3_普通曼哈顿_车在非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.4_普通曼哈顿_车在P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_P点}    lat=${纬度_抚州_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.5_普通曼哈顿_车在单基站_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_非P点}    lat=${纬度_抚州_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    reason=19    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.5_普通曼哈顿_车在禁停区_收禁停区调度费
    admin后台配置    normParkingAreaSettings_6.json
    admin后台禁停区配置
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    禁停区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.6_普通曼哈顿_车在从区内到区外_收区内到区外区调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_禁停区}    lat=${纬度_抚州_禁停区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    超区调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.7_普通曼哈顿_车在从区外到区外__收区外到区外区调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_超区}    lat=${纬度_抚州_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区2}    ${纬度_抚州_超区2}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain   ${payDetails}    区外调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.8_普通曼哈顿_车在高校区的可停区_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_可停车区}    lat=${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${rep_payDetails_s}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.9_普通曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.10_普通曼哈顿_车在高校区的非P点/蓝牙框外_收费规范停车调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.11_普通曼哈顿_车在高校区的P点_不收调度费
    admin后台配置    normParkingAreaSettings_6.json
    创建曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.12_高校曼哈顿_车在高校区的P点_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.13_高校曼哈顿_车在高校区的蓝牙框外非P点_收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    违规停车调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.14_高校曼哈顿_车在高校区的蓝牙框内_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    lat=${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_蓝牙框内}    ${纬度_抚州_高校曼哈顿自动化测试_蓝牙框内}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain   ${payDetails}    调度费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}


4.15_高校曼哈顿_车在位置为单基站_不收调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    reason=19    posType=1
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should not contain    ${payDetails}    车费
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.16_高校曼哈顿_车在从区内到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain     ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

4.17_高校曼哈顿_车在从区到区外_收超区调度费
    admin后台高校配置_file    subServiceAreaSettings_6.json
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_非P点}    lat=${纬度_抚州_高校曼哈顿自动化测试_非P点}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区}    ${纬度_抚州_高校曼哈顿自动化测试_超区}    reason=19
    创建高校曼哈顿骑行中订单    lng=${经度_抚州_高校曼哈顿自动化测试_超区}    lat=${纬度_抚州_高校曼哈顿自动化测试_超区}
    提前订单时间    ${rideId}
    上报曼哈顿我要还车车辆位置    ${bikeNo}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    0
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_超区2}    ${纬度_抚州_高校曼哈顿自动化测试_超区2}    reason=19
    ${rep_payDetails}    获取订单详情    ${rideId}
    ${payDetails}    Convert To String      ${rep_payDetails}
    should contain    ${payDetails}    超区调度费
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}