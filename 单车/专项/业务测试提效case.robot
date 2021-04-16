*** Settings ***
Suite Setup       run keywords    app登陆    ${mobilePhone}
...               AND    获取userNewId
...               AND    获取用户信息
...               AND    用户充值    ${mobilePhone}    2000
Resource          ../../资源配置/一键导入配置.resource

*** Test Cases ***
1、骑行完成一笔3min的普通订单
    查询城市可用车辆-sh_创建订单_开始订单
    提前订单时间    ${rideId}    -3
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_上海市莘庄中心}    ${纬度_上海市莘庄中心}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

2、批量造数据_骑行完成一笔3min的普通订单
    Repeat keyword    50    骑行完成一笔3分钟的普通订单

3、普通车_提前开始订单
    查询城市可用车辆-sh_创建订单_开始订单
    提前订单时间    ${rideId}    -3
    车辆断开连接    ${bikeNo}    ${bikeKey}
    log    ${bikeNo}
