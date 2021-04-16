*** Keywords ***
获取当前用户已支付orderGuid
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderGuid}    查询    select guid from t_ride_info_${table} where user_new_id='${usernewid}' and ride_status=1 order by update_time desc limit 1;
    [Return]    ${orderGuid}[0][0]

获取当前用户已结束orderGuid
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderGuid}    查询    select guid from t_ride_info_${table} where user_new_id='${usernewid}' and ride_status=2 order by update_time desc limit 1;
    [Return]    ${orderGuid}[0][0]

获取当前用户预置骑行orderGuid
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderGuid}    查询    select guid from t_ride_info_${table} where user_new_id='${usernewid}' and ride_status=-1 order by update_time desc limit 1;
    [Return]    ${orderGuid}[0][0]

获取当前用户锁环被卡orderGuid
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderGuid}    查询    select guid from t_ride_info_${table} where user_new_id='${usernewid}' and ride_status=-2 order by update_time desc limit 1;
    [Return]    ${orderGuid}[0][0]

获取当前用户失效订单orderGuid
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderGuid}    查询    select guid from t_ride_info_${table} where create_time < '2019-11-25 20:01:37.093000' order by update_time desc limit 1;
    log    失效订单查询结果：${orderGuid}
    [Return]    ${orderGuid}[0][0]

更新订单开始时间
    [Arguments]     ${订单全局标识}     ${开始时间}
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${sql}    Set Variable    update t_ride_info_${table} set start_time='${开始时间}' where guid='${订单全局标识}';
    ${content}    更新    ${sql}
    Run Keyword If    ${content} == None    Log    @@更新订单表@@成功
    ${开始时间戳}  北京时间转换为毫秒级时间戳    ${开始时间}
    ${rediscontent}    redis command without database    bikeorder-cluster    hset order:${订单全局标识} startTime '${开始时间戳}'
    Should Be Equal As Numbers    0    ${rediscontent}[1][code]
    log    【更新订单开始时间成功】
    [return]    ${开始时间戳}

提前订单时间
# start_time：提前时长，单位：分钟
    [Arguments]     ${rideId}     ${start_time}=-2
    ${订单信息}    Run Keyword If    ${rideId} != None    获取当前订单的信息    ${rideId}
    ${订单数量}    Get Length    ${订单信息}
    ${开始时间}    Run Keyword If    ${订单数量} != 0    Evaluate    '${订单信息}[0][6]'    modules=datetime
    ${更新开始时间}    Run Keyword If    ${订单数量} != 0    日期加时间    ${开始时间}    ${start_time} minutes
    Run Keyword If    ${订单数量} != 0    更新订单开始时间    ${rideId}    ${更新开始时间}

获取用户最近的一笔订单
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderInfo}    查询    select bike_no,guid,ride_cost from t_ride_info_${table} where update_time is not null and user_new_id='${usernewid}' and create_time > now() + interval '-7 days' order by update_time desc limit 1;
    [Return]    ${orderInfo}

获取用户最近的一笔骑行中订单
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderInfo}    查询    select bike_no,guid,ride_cost from t_ride_info_${table} where update_time is not null and user_new_id='${usernewid}' and ride_status=0 and create_time > now() + interval '-7 days' order by update_time desc limit 1;
    [Return]    ${orderInfo}

获取用户最近的一笔待支付订单
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderInfo}    查询    select bike_no,guid,ride_cost,create_time from t_ride_info_${table} where update_time is not null and user_new_id='${usernewid}' and pay_status in(-1,0,2) and ride_cost > 0 and create_time > now() + interval '-7 days' order by update_time desc limit 1;
    [Return]    ${orderInfo}

订单退骑行费用
    [Arguments]     ${rideGuid}    ${userGuid}    ${originCount}    ${withdrawCount}    ${createTime}
    ${url}      Set Variable    ${admin订单退费}
    ${headers}  Create Dictionary   token=${bmsToken}      User-Agent=${bmsUserAgent}
    ${originCount}  Evaluate    float(${originCount})
    ${withdrawCount}  Evaluate    float(${withdrawCount})
    ${orderType}    Evaluate    int(0)
    ${reason}    Evaluate    int(7)
    ${data}     Create Dictionary   rideGuid=${rideGuid}    userGuid=${userGuid}    originCount=${originCount}    createTime=${createTime}    orderType=${orderType}    withdrawCount=${withdrawCount}    reason=${reason}
    ${content}  request client    url=${url}    headers=${headers}    data=${data}
    #Should Be Equal As Numbers    ${content}[0]    200

获取当前订单的信息
    [Arguments]     ${orderGuid}
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${orderInfo}    查询    select ride_status,guid,user_guid,mobile_phone,bike_no,ride_cost,start_time from t_ride_info_${table} where guid='${orderGuid}';
    [Return]    ${orderInfo}

用户骑行中或者待支付的最近一笔订单退费
    ${用户最近一笔骑行中订单}    获取用户最近的一笔骑行中订单
    ${订单数量}    Get Length    ${用户最近一笔骑行中订单}
    ${车辆编号}    Run Keyword If    ${订单数量} != 0    Set Variable    ${用户最近一笔骑行中订单}[0][0]
    ${订单全局标识}    Run Keyword If    ${订单数量} != 0    Set Variable    ${用户最近一笔骑行中订单}[0][1]
    ${结束时间戳}    获取now毫秒级时间戳
    Run Keyword If    ${订单数量} != 0    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}   关锁位置类型=${开关锁位置类型_单基站}
    ${用户最近一笔待支付订单}    获取用户最近的一笔待支付订单
    ${订单数量}    Get Length    ${用户最近一笔待支付订单}
    ${订单全局标识}    Run Keyword If    ${订单数量} != 0    Set Variable    ${用户最近一笔待支付订单}[0][1]
    ${订单骑行费用}    Run Keyword If    ${订单数量} != 0    Evaluate    '${用户最近一笔待支付订单}[0][2]'
    ${订单创建时间}    Run Keyword If    ${订单数量} != 0    Set Variable    ${用户最近一笔待支付订单}[0][3]
    ${订单创建时间}    Run Keyword If    ${订单数量} != 0    DateTime.Convert Date    ${订单创建时间}    epoch
    ${订单创建时间}    Run Keyword If    ${订单数量} != 0    Evaluate    int(round(${订单创建时间} * 1000))
    Run Keyword If    ${订单数量} != 0    订单退骑行费用    rideGuid=${订单全局标识}    userGuid=${用户全局标识}    originCount=${订单骑行费用}    withdrawCount=${订单骑行费用}    createTime=${订单创建时间}

获取订单详情
    [Arguments]    ${rideId}    ${adCode}=${行政代码_曼哈顿}    ${cityCode}=${区号_曼哈顿}    ${lng}=${经度_抚州_高校曼哈顿自动化测试_P点}   ${lat}=${纬度_抚州_高校曼哈顿自动化测试_P点}
    ${data}    set variable    {"addr":"${AppHellobikeRideProcessService}","iface":"com.easybike.rideprocess.ifaces.RideIface","method":"detail","request":{"arg0":{\"systemCode\":\"62\",\"token\":\"${token}\",\"_xff\":\"58.246.57.146\",\"action\":\"user.ride.detail\",\"clientId\":\"\",\"orderGuid\":\"${rideId}\",\"orderId\":\"\",\"userNewId\":\"${usernewid}\",\"_fingerPrintHash\":\"\",\"_riskId\":\"2d88cbdba5c44366a067931b821b7253\",\"adCode\":\"361002\",\"startTime\":0,\"_uuid\":\"${guid}\",\"ticket\":\"MTU5NTQ4Nzg0Ng==.7b3TC+dag3QDu9kl5MIJjpjlgihesVu16rrSrpjEw0U=\",\"version\":\"${APPversion}\",\"cityCode\":\"${cityCode}\",\"riskControlData\":{\"userAgent\":\"Mozilla/5.0 (Linux; Android 9; Redmi K20 Build/PKQ1.190302.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/72.0.3626.121 Mobile Safari/537.36\",\"mobileNoInfo\":\"\",\"ssidName\":\"HelloBike\",\"capability\":\"NONE\",\"roam\":\"\",\"batteryLevel\":\"39\",\"deviceLat\":27.96560028643023,\"deviceLon\":116.3332115950345,\"systemCode\":\"62\",\"network\":\"Wifi\"},\"ip\":\"58.246.57.146\",\"_userAgent\":\"okhttp/3.12.2\"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${rep_data}    set variable    ${repData}[1]
    ${rep_response}    get from dictionary    ${rep_data}    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_data}    get from dictionary    ${rep_response}    data
    ${rep_detail}    get from dictionary    ${rep_data}    detail
    ${rep_payDetails}    get from dictionary    ${rep_detail}    payDetails
    log    【获取订单详情】 执行成功
    [Return]    ${rep_payDetails}

骑行完成一笔3分钟的普通订单
    查询城市可用车辆-sh_创建订单_开始订单
    ${rnd}    Evaluate    random.randint(-20,-2)    random
    提前订单时间    ${rideId}     ${rnd}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_上海市莘庄中心}    ${纬度_上海市莘庄中心}    0
    sleep    3s