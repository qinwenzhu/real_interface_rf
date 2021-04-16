*** Settings ***
Resource          ../../资源配置/一键导入配置.resource

*** Test Cases ***
# 获取当前毫秒时间戳
#     获取now毫秒级时间戳

# 执行的redis集群命令
#     ${content}    fox执行不指定库的redis命令    bikeuser-cluster    get a

# 注册或者登录用户
#     #注意:此方法仅是注册用户,如果是老的用户则是登录返回用户的信息
#     app登陆    17717550328
#     获取用户信息

# 注销用户
#     #注意:此用户有待支付订单的话,不能注销成功
#     客服中心注销用户    10010001000

# 注销用户,实名认证-doing

# 注销用户,实名认证,0元免押-doing

# 注销所有卡
#     ${用户}    Set Variable    10010001001
#     app登陆    ${用户}
#     获取用户信息
#     客服中心注销某用户所有骑行卡

# 用户充值余额
#     用户充值    10010001004    6

用户跑一单并且余额支付
    ${用户}    Set Variable    10010001004
    ${充值金额}     Set Variable    999
    ${提前时间}    Set Variable     -3 minutes
    用户跑一单    ${用户}    ${充值金额}    ${提前时间}    关锁纬度=${纬度_上海市莘庄中心}    关锁经度=${经度_上海市莘庄中心}

# 用户跑一单不支付
#     ${用户}    Set Variable    10010001000
#     ${充值金额}     Set Variable    0
#     ${提前时间}    Set Variable     -3 minutes
#     用户跑一单    ${用户}    ${充值金额}    ${提前时间}    关锁纬度=${纬度_上海市莘庄中心}    关锁经度=${经度_上海市莘庄中心}

# 获取用户最近一笔订单的GUID
#     ${用户}    Set Variable    13482892312
#     app登陆    ${用户}
#     获取用户信息
#     ${最近骑行中订单}     获取用户最近的一笔订单
#     ${订单全局标识}    Set Variable    ${最近骑行中订单}[0][1]
#     Log    用户${用户}的最近一笔订单的GUID是:${订单全局标识}

# 用户骑行中订单修改订单开始时间
#     ${用户}    Set Variable    17717550328
#     # ${用户}    Set Variable    13482892312
#     # ${提前时间}    Set Variable     -10741 seconds    #10740是179分钟
#     ${提前时间}    Set Variable     -2 minutes
#     骑行中订单修改订单时间    ${用户}    ${提前时间}

# 车辆设置红包车
#     # ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
#     ${车辆编号}    Set Variable    2100802931
#     车辆设置红包车标签    ${车辆编号}

*** Keywords ***
# 实名认证-doing
#     [Arguments]     ${token}
#     ${data}    Create Dictionary    action=user.activationPage.getZeroDeposit    clientId=    systemCode=${systemCode_安卓}     token=${token}    version=${接口的最新版本}    adCode=${行政代码_东营区}    cityCode=${区号_东营}    platform=${平台类型_APP}
#     ${content}    通用调用    调用接口=实名认证    报文体=${data}
#     Should Be Equal As Numbers    ${content}[0]    200    【实名认证】接口返回应该是200

# 0元免押-doing
#     [Arguments]     ${token}
#     ${data}    Create Dictionary    action=user.activationPage.getZeroDeposit    clientId=    systemCode=${systemCode_安卓}     token=${token}    version=${接口的最新版本}    adCode=${行政代码_东营区}    cityCode=${区号_东营}    platform=${平台类型_APP}
#     ${content}    通用调用    调用接口=0元免押    报文体=${data}
#     Should Be Equal As Numbers    ${content}[0]    200    【0元免押】接口返回应该是200

修改订单开始时间
    [Arguments]     ${订单全局标识}     ${提前时间}
    ${订单信息}    Run Keyword If    ${订单全局标识} != None    获取当前订单的信息    ${订单全局标识}
    ${订单数量}    Get Length    ${订单信息}
    ${开始时间}    Run Keyword If    ${订单数量} != 0    Evaluate    '${订单信息}[0][6]'    modules=datetime
    ${更新开始时间}    Run Keyword If    ${订单数量} != 0    日期加时间    ${开始时间}    ${提前时间}
    Run Keyword If    ${订单数量} != 0    更新订单开始时间    ${订单全局标识}    ${更新开始时间}
    Log     【修改订单开始时间】执行完成

用户跑一单
    [Arguments]     ${用户}    ${充值金额}=999    ${提前时间}=-3 minutes    ${关锁纬度}=${纬度_上海市莘庄中心}    ${关锁经度}=${经度_上海市莘庄中心}    ${关锁}=${true}
    app登陆    ${用户}
    获取用户信息
    用户充值    ${用户}    ${充值金额}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    修改订单开始时间    ${订单全局标识}    ${提前时间}
    ${结束时间戳}    获取now毫秒级时间戳
    Run Keyword If     ${关锁}    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}     纬度=${关锁纬度}   经度=${关锁经度}
    Log    【用户跑一单】执行完成-用户:${用户}-车辆编号:${车辆编号}-订单GUID:${订单全局标识}

骑行中订单修改订单时间
    [Arguments]     ${用户}    ${提前时间}
    app登陆    ${用户}
    获取用户信息
    ${最近骑行中订单}     获取用户最近的一笔骑行中订单
    ${订单全局标识}    Set Variable    ${最近骑行中订单}[0][1]
    修改订单开始时间    ${订单全局标识}    ${提前时间}
    Log     【骑行中订单修改订单时间】执行完成
