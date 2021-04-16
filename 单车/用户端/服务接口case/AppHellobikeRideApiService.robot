*** Settings ***
Documentation     todo
...               1、
Suite Setup       run keywords    app登陆    ${appMobile_shaohui_authed}
...               AND    获取userNewId
...               AND    获取用户信息
...               AND    用户充值    ${appMobile_shaohui_authed}    200
...               AND    客服中心注销某用户所有骑行卡
Default Tags      AppHellobikeRideApiService
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem
Resource          ../../../资源配置/一键导入配置.resource

*** Test Cases ***
startRide_orderGuid传参为Null验证
    # run keyword if Test
    #    :FOR    ${i}    IN RANGE    4
    #    run keyword if    1==1    run keyword if    1==1    exit for loop
    #    sleep    3
    #    log    run keyword if 嵌套是无效
    #    log    第${i+2}次轮询结束
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"9120069457","userGuid":"9b277e5cb1e14e119127e26b42c4338a","startLng":113.5294957,"startLat":22.2534844,"startTime":1584433074000,"posType":1}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    get from dictionary    ${repdata}[1]    response
    ${code}    get from dictionary    ${response}    code
    ${msg}    get from dictionary    ${response}    msg
    should be equal as numbers    ${code}    201
    should be equal as strings    ${msg}    订单不存在

startRide_orderGuid传参为""验证
    [Tags]    AppHellobikeRideApiService    邵惠
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"9120069457","orderGuid":"","userGuid":"9b277e5cb1e14e119127e26b42c4338a","startLng":113.5294957,"startLat":22.2534844,"startTime":1584433074000,"posType":1}}}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok

startRide_无orderGuid数据,创建行程失败
    Comment    ${content}    查询城市可用车辆-sh_创建订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":15845119285371233662277,"userGuid":"262adb70d6204ffb8de058dbeba3c6da","startLng":113.5294957,"startLat":22.2534844,"startTime":1584511929000,"posType":1}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    get from dictionary    ${repdata}[1]    response
    ${code}    get from dictionary    ${response}    code
    ${msg}    get from dictionary    ${response}    msg
    should be equal as numbers    ${code}    205
    should be equal as strings    ${msg}    创建行程失败

startRide_校验订单是否已经失效
    [Documentation]    测试环境没有配失效时间(apollo配置：orderLossTime),使用默认时间 10*60*1000，即10分钟
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":15845155367871200101051,"userGuid":"262adb70d6204ffb8de058dbeba3c6da","startLng":113.5294957,"startLat":22.2534844,"startTime":1584511929000,"posType":1}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    303
    should be equal as strings    ${response}[1]    订单已失效

startRide_校验userGuid不存在
    ${content}    查询城市可用车辆-sh_创建订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":15845234154051394354189,"userGuid":"c8f71e7c8bc049a8988cec062408a570","startLng":113.5294957,"startLat":22.2534844,"startTime":${createTime},"posType":1}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    205
    should be equal as strings    ${response}[1]    创建行程失败

startRide_校验该用户已存在订单
    ${content}    查询城市可用车辆-sh_创建订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":${rideId},"userGuid":"${guid}","startLng":113.5294957,"startLat":22.2534844,"startTime":${createTime},"posType":1}}}
    log    设置蓝牙开锁订单缓存
    redis command without database    bikeorder-cluster    set useBlueToothOrder:${guid} '15862696317291200100000'
    log    设置用户订单缓存
    redis command without database    bikeorder-cluster    set userOrder:${guid} '15862696317291200100000'
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    205
    should be equal as strings    ${response}[1]    创建行程失败
    redis command without database    bikeorder-cluster    del useBlueToothOrder:c8f71e7c8bc049a8988cec062408a570
    log    清除蓝牙开锁订单缓存
    log    清除用户订单缓存
    redis command without database    bikeorder-cluster    del userOrder:c8f71e7c8bc049a8988cec062408a570

startRide_校验订单状态不正确
    ${content}    查询城市可用车辆-sh_创建订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":${rideId},"userGuid":"${guid}","startLng":113.5294957,"startLat":22.2534844,"startTime":${createTime},"posType":1}}}
    ${repdata}    request client    data=${data}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    302
    should be equal as strings    ${response}[1]    订单状态不正确
    ${endTime}    获取now毫秒级时间戳
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

startRide_普通订单正常流程开始订单
    ${content}    查询城市可用车辆-sh_创建订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":${rideId},"userGuid":"${guid}","startLng":113.5294957,"startLat":22.2534844,"startTime":${createTime},"posType":1}}}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    ${endTime}    获取now毫秒级时间戳
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

finishRide_orderGuid不存在
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":"15845234154051394354189","reason":-99,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"1584511929000","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    201
    should be equal as strings    ${response}[1]    订单不存在

finishRide_订单已支付，直接返回ok
    ${orderguid}    获取当前用户已支付orderGuid
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":"${orderguid}","reason":-99,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"1584511929000","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok

finishRide_订单已结束，直接返回ok
    ${orderguid}    获取当前用户已结束orderGuid
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":"${orderguid}","reason":-99,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"1584511929000","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok

finishRide_订单预置骑行，直接返回ok
    ${orderguid}    获取当前用户预置骑行orderGuid
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":"${orderguid}","reason":-99,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"1584511929000","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok

finishRide_订单锁环被卡，直接返回ok
    ${orderguid}    获取当前用户锁环被卡orderGuid
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":"${orderguid}","reason":-99,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"1584511929000","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok

finishRide_失效订单不做处理，直接返回ok
    [Documentation]    失效时间在apollo配置，默认是90 * 24 * 3600，即三个月
    ${orderguid}    获取当前用户失效订单orderGuid
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"5350259438","orderGuid":"${orderguid}","reason":-99,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"1584511929000","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    303
    should be equal as strings    ${response}[1]    订单已失效

finishRide_按订单时长计算结束时间
    查询城市可用车辆-sh_创建订单_开始订单
    ${nowstramp}    获取now毫秒级时间戳
    ${starttimeU}    更新订单开始时间-sh    00:05:00.000
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","orderTime":110000,"reason":0,"endLng":121.1221,"endLat":31.128,"endChannel":3,"endTime":"${nowstramp}","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    ${endtime}    add time to date    ${starttimeU}    00:01:50.000
    ${tableNo}    连接数据库_bike_order_fat
    ${order_endtime}    查询    select stop_time from t_ride_info_${tableNo} where guid='${rideId}' order by update_time desc limit 1;
    ${endtime_db}    convert date    ${order_endtime}[0][0]
    should be equal    ${endtime_db}    ${endtime}
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

finishRide_接口传参结束时间小于订单开始时间，按照当前时间结束订单
    查询城市可用车辆-sh_创建订单_开始订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":0,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"1585723548000","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

finishRide_接口传参结束时间为0，取开始时间+10分钟计费
    查询城市可用车辆-sh_创建订单_开始订单
    ${nowstramp}    获取now毫秒级时间戳
    ${starttimeU}    更新订单开始时间-sh    00:15:00.000
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":0,"endLng":121.1221,"endLat":31.128,"endTime":"0","endChannel":3,"posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    ${endtime}    add time to date    ${starttimeU}    00:10:00.000
    ${tableNo}    连接数据库_bike_order_fat
    ${order_endtime}    查询    select stop_time from t_ride_info_${tableNo} where guid='${rideId}' order by update_time desc limit 1;
    ${endtime_db}    convert date    ${order_endtime}[0][0]
    should be equal    ${endtime_db}    ${endtime}
    ${用户全局标识}    set Variable    ${guid}
    # finishRide_高校订单，接口返回没有规范停车，不需要关锁    #    [Documentation]    纯接口测试，用普通车开锁，更改db数据，来完成接口验证    #    查询城市可用车辆-sh_创建订单_开始订单    #    ${nowstramp}    获取now毫秒级时间戳    #    ${tableNo}    连接数据库_bike_order_fat    #    ${now}
    # get current date    #    ${sql}    set variable    update t_ride_info_${tableNo} set order_type=3 where guid='${rideId}'    #    ${content}    更新    ${sql}    #    run keyword if    ${content} == None    log    @@更新order_type=3@@成功    #    ${data}
    # set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":0,"endLng":121.1221,"endLat":31.128,"endChannel":3,"endTime":"${createTime}","posType":0,"isRegulatedArea":"0"}}}    #    ${repdata}    request client    data=${data}    #    should be equal as numbers    ${repdata}[0]    200    #    ${response}    rpc接口取返回节点    ${repdata}    #    should be equal as numbers
    # ${response}[0]    707    #    should be equal as strings    ${response}[1]    没有规范停车，不需要关锁    #    # finishRide_ordeType为null，更新字段为-99    #    #    查询城市可用车辆-sh_创建订单_开始订单    #    #    ${nowstramp}    获取now毫秒级时间戳    #
    #    ${tableNo}    连接数据库_bike_order_fat    #    #    ${now}    get current date    #    #    ${sql}    set variable    update t_ride_info_${tableNo} set order_type=null where guid='${rideId}'    #    #    ${content}    更新
    # ${sql}    #    #    run keyword if    ${content} == None    log    @@更新order_type=null@@成功    #    #    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":0,"endLng":121.1221,"endLat":31.128,"endChannel":3,"endTime":"${createTime}","posType":0,"isRegulatedArea":"0"}}}    #    #    ${repdata}    request client
    # data=${data}    #    #    should be equal as numbers    ${repdata}[0]    200    #    #    ${response}    rpc接口取返回节点    ${repdata}    #    #    should be equal as numbers    ${response}[0]    0
    #    #    should be equal as strings    ${response}[1]    ok    #    #    ${order_type}    查询    select order_type from t_ride_info_${tableNo} where guid='${rideId}' order by update_time desc limit 1;    #    #    should be equal    ${order_type}[0][0]    -99    #
    #    [Teardown]    run keywords    结束订单通用    ${bikeNo}    ${rideId}    #    #    ...    #    # AND    车辆断开连接    ${bikeNo}    ${bikeKey}    #    [Teardown]
    # run keywords    结束订单通用    ${bikeNo}    ${rideId}    #    ...    # AND    车辆断开连接    ${bikeNo}    ${bikeKey}
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

finishRide_正常流程结束订单
    查询城市可用车辆-sh_创建订单_开始订单
    ${nowstramp}    获取now毫秒级时间戳
    ${now}    get current date
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":0,"endLng":121.1221,"endLat":31.128,"endChannel":1,"endTime":"${createTime}","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as numbers    ${repdata}[1][response][code]    0
    should be equal as strings    ${repdata}[1][response][msg]    ok
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}    ${经度_上海市莘庄中心}    ${纬度_上海市莘庄中心}    0

finishRide_使用骑行优惠券
    发放骑行优惠券    ${appMobile_shaohui_authed}    ${usernewid}
    查询城市可用车辆-sh_创建订单_开始订单
    ${nowstramp}    获取now毫秒级时间戳
    ${starttimeU}    更新订单开始时间-sh    00:05:00.000
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":0,"endLng":121.1221,"endLat":31.128,"endChannel":3,"endTime":"${nowstramp}","posType":0,"isRegulatedArea":"0"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as numbers    ${repdata}[1][response][code]    0
    should be equal as strings    ${repdata}[1][response][msg]    ok
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

startRideError_errortype=1,锁环被卡，接口返回0
    查询城市可用车辆-sh_创建订单_开始订单
    ${nowstramp}    获取now毫秒级时间戳
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRideError","request":{"arg0":{"bikeNo":"${bikeNo}","orderGuid":"${rideId}","tryBleOpenLock":False,"errorType":1,"errorCode":5}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

startRideError_蓝牙开锁，接口返回0
    查询城市可用车辆-sh_创建订单_开始订单
    ${nowstramp}    获取now毫秒级时间戳
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRideError","request":{"arg0":{"bikeNo":"${bikeNo}","orderGuid":"${rideId}","tryBleOpenLock":True,"errorType":50,"errorCode":50}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    [Teardown]    结束订单通用    ${bikeNo}    ${rideId}

getRideDetail_orderGuid为空，根据orderid查找
    ${nowstramp}    获取now毫秒级时间戳
    ${tableNo}    连接数据库_bike_order_fat
    ${orderIdinfo}    查询    select order_id,create_time from t_ride_info_${tableNo} where user_new_id='${usernewid}' and ride_status=1 order by update_time desc limit 1;
    ${orderId}    set variable    ${orderIdinfo}[0][0]
    ${create_time}    北京时间转换为毫秒级时间戳    ${orderIdinfo}[0][1]
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"getRideDetail","request":{"arg0":{"orderGuid":"","orderId":"${orderId}","version":"${接口的最新版本}","createTime":${create_time},"userNewId":${usernewid},"systemCode":"61"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${rep_response}    get from dictionary    ${repdata}[1]    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_data}    get from dictionary    ${rep_response}    data
    ${rep_detail}    get from dictionary    ${rep_data}    detail
    should be equal as numbers    ${rep_code}    0
    should not be empty    ${rep_detail}

getRideDetail_orderGuid,createtime不为空，根据orderguid，createtime查找
    ${tableNo}    连接数据库_bike_order_fat
    ${orderIdinfo}    查询    select guid,create_time from t_ride_info_${tableNo} where user_new_id='${usernewid}' and ride_status=2 order by update_time desc limit 1;
    ${orderGuid}    set variable    ${orderIdinfo}[0][0]
    ${create_time}    北京时间转换为毫秒级时间戳    ${orderIdinfo}[0][1]
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"getRideDetail","request":{"arg0":{"orderGuid":"${orderGuid}","version":"${接口的最新版本}","createTime":${create_time},"userNewId":${usernewid},"systemCode":"61"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${rep_response}    get from dictionary    ${repdata}[1]    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_data}    get from dictionary    ${rep_response}    data
    ${rep_detail}    get from dictionary    ${rep_data}    detail
    should be equal as numbers    ${rep_code}    0
    should not be empty    ${rep_detail}

getRideDetail_orderGuid不为空，createtime为null,根据orderguid查找
    ${tableNo}    连接数据库_bike_order_fat
    ${orderIdinfo}    查询    select guid from t_ride_info_${tableNo} where user_new_id='${usernewid}' and ride_status=2 order by update_time desc limit 1;
    ${orderGuid}    set variable    ${orderIdinfo}[0][0]
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"getRideDetail","request":{"arg0":{"orderGuid":"${orderGuid}","orderId":"","version":"${接口的最新版本}","userNewId":${usernewid},"systemCode":"61"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${rep_response}    get from dictionary    ${repdata}[1]    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_data}    get from dictionary    ${rep_response}    data
    ${rep_detail}    get from dictionary    ${rep_data}    detail
    should be equal as numbers    ${rep_code}    0
    should not be empty    ${rep_detail}

getRideDetail_根据orderguid查找历史订单
    ${tableNo}    连接数据库_bike_order_fat
    ${orderIdinfo}    查询    select guid,user_guid,create_time from t_ride_info_${tableNo} where ride_status=2 order by update_time asc limit 1;
    ${orderGuid}    set variable    ${orderIdinfo}[0][0]
    ${userguid}    set variable    ${orderIdinfo}[0][1]
    ${create_time}    北京时间转换为毫秒级时间戳    ${orderIdinfo}[0][2]
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"getRideDetail","request":{"arg0":{"orderGuid":"${orderGuid}","createTime":"${create_time}","version":"${接口的最新版本}","userGuid":"${userguid}","systemCode":"61"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${rep_response}    get from dictionary    ${repdata}[1]    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_data}    get from dictionary    ${rep_response}    data
    ${rep_detail}    get from dictionary    ${rep_data}    detail
    should be equal as numbers    ${rep_code}    0
    should not be empty    ${rep_detail}

getRideDetail_根据orderguid查订单不存在
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"getRideDetail","request":{"arg0":{"orderGuid":"15849348566081258323935","version":"${接口的最新版本}","userNewId":${usernewid},"systemCode":"61"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${rep_response}    get from dictionary    ${repdata}[1]    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_msg}    get from dictionary    ${rep_response}    msg
    should be equal as numbers    ${rep_code}    201
    should be equal as strings    ${rep_msg}    订单不存在

getCurrentOrder_参数userGuid为空
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"getCurrentOrder","request":{"arg0":"null"}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    0

getCurrentOrder_参数userGuid当前没有订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"getCurrentOrder","request":{"arg0":"${guid}"}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200

isUserAlreadyRide_userGuid为空
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"isUserAlreadyRide","request":{"arg1":"100"}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    104
    should be equal as strings    ${repdata}[1][response][data]    False

isUserAlreadyRide_正常流程
    ${content}    redis command without database    bikeorder-cluster    get userLatestOrder:'${guid}'
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"isUserAlreadyRide","request":{"arg1":"100","arg0":'"${guid}"'}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    ${redis_data}    set variable    ${repdata}[1][response][data]
    should be equal as Numbers    ${repdata}[1][response][code]    0
    Run Keyword If    ${redis_data}==None    should be equal as strings    ${repdata}[1][response][data]    False

isManhattanLatestRide_用户上一笔订单不是曼哈顿订单，且订单结束类型为正常结束订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"isManhattanLatestRide","request":{"arg0":'"${guid}"'}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as numbers    ${repdata}[1][response][code]    0
    should be equal as strings    ${repdata}[1][response][data]    False

isManhattanLatestRide_userGuid为空
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"isManhattanLatestRide","request":{"arg0":"null"}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as numbers    ${repdata}[1][response][code]    0
    should be equal as strings    ${repdata}[1][response][data]    False

returnBike_请求参数cityCode为空，接口返回‘网络开小差’
    ${data}    set Variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"returnBike","request":{"arg0":{"bikeNo":"3130020009","orderGuid":"15851296325191200101051","_uuid":"c8f71e7c8bc049a8988cec062408a570","userNewId":1200101051,"lng":114.8795533,"lat":40.82033188,"systemCode":"61","cityCode":"","operateType":0,"version":"${接口的最新版本}"}}}
    ${content}    request client    data=${data}
    should be Equal as Numbers    ${content}[0]    200
    ${rep_data}    set variable    ${content}[1]
    ${rep_response}    get from dictionary    ${rep_data}    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_msg}    get from dictionary    ${rep_response}    msg
    should be Equal as Numbers    ${rep_code}    102
    should be Equal as strings    ${rep_msg}    抱歉,网络开小差了,请稍后重试

returnBike_请求参数orderGuid为空，接口返回‘网络开小差’
    ${data}    set Variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"returnBike","request":{"arg0":{"bikeNo":"3130020009","orderGuid":"","_uuid":"c8f71e7c8bc049a8988cec062408a570","userNewId":1200101051,"lng":114.8795533,"lat":40.82033188,"systemCode":"61","cityCode":"021","operateType":0,"version":"${接口的最新版本}"}}}
    ${content}    request client    data=${data}
    should be Equal as Numbers    ${content}[0]    200
    ${rep_data}    set variable    ${content}[1]
    ${rep_response}    get from dictionary    ${rep_data}    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_msg}    get from dictionary    ${rep_response}    msg
    should be Equal as Numbers    ${rep_code}    102
    should be Equal as strings    ${rep_msg}    抱歉,网络开小差了,请稍后重试

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_非P点还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_5.json    #修改城市配置为：电子围栏&调度费+车锁弹开
    创建曼哈顿骑行中订单    lat=${纬度_抚州_非P点}    lng=${经度_抚州_非P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_P点停车还车不收调度费
    admin后台配置    #修改城市配置为：电子围栏&调度费
    创建曼哈顿骑行中订单    lat=${纬度_抚州_P点}    lng=${经度_抚州_P点}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    log    【曼哈顿断言结束】
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_有蓝牙信号不收调度费
    admin后台配置    normParkingAreaSettings_1.json    #修改城市配置为：蓝牙道钉&调度费
    创建曼哈顿骑行中订单    lat=${纬度_抚州_P点}    lng=${经度_抚州_P点}
    上报蓝牙信号    ${bikeNo}    ${有蓝牙信号}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}
    log    【曼哈顿断言结束】
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_无蓝牙信号收调度费
    admin后台配置    normParkingAreaSettings_1.json    #修改城市配置为：蓝牙道钉&调度费
    创建曼哈顿骑行中订单    lat=${纬度_抚州_非P点}    lng=${经度_抚州_非P点}
    提前订单时间    ${rideId}
    上报蓝牙信号    ${bikeNo}    ${无蓝牙信号}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_可停车区还车不收调度费
    创建曼哈顿骑行中订单    lat=${纬度_抚州_可停车区}    lng=${经度_抚州_可停车区}
    提前订单时间    ${rideId}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_收禁停区调度费
    admin后台禁停区配置    #开启禁停区配置
    创建曼哈顿骑行中订单    lat=${纬度_抚州_禁停区}    lng=${经度_抚州_禁停区}
    提前订单时间    ${rideId}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1101
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_收区内到区外调度费
    创建曼哈顿骑行中订单
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_收区外到区外调度费
    创建曼哈顿骑行中订单    lat=${纬度_抚州_超区}    lng=${经度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_高校曼哈顿_正常开关锁流程_P点停车还车不收调度费
    admin后台高校配置_file    #修改高校配置为：电子围栏&调度费
    创建高校曼哈顿骑行中订单
    提前订单时间    ${rideId}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_高校曼哈顿_正常开关锁流程_有蓝牙信号还车不收调度费
    admin后台高校配置_file    subServiceAreaSettings_1.json    #修改高校配置为：蓝牙道钉&调度费
    创建高校曼哈顿骑行中订单
    提前订单时间    ${rideId}
    上报蓝牙信号    ${bikeNo}    ${有蓝牙信号}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_P点}    ${纬度_抚州_高校曼哈顿自动化测试_P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_高校曼哈顿_正常开关锁流程_无蓝牙信号还车收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_4.json    #修改高校配置为：蓝牙道钉&调度费+车锁弹开
    创建高校曼哈顿骑行中订单
    上报蓝牙信号    ${bikeNo}    ${无蓝牙信号}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_高校曼哈顿_正常开关锁流程_可停车区不收调度费
    创建高校曼哈顿骑行中订单
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_可停车区}    ${纬度_抚州_高校曼哈顿自动化测试_可停车区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_高校曼哈顿_正常开关锁流程_非P点停车还车收非规范停车调度费
    admin后台高校配置_file    subServiceAreaSettings_5.json    #修改高校配置为：电子围栏&调度费+车锁弹开
    创建高校曼哈顿骑行中订单
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    1    ${区号_曼哈顿}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_高校曼哈顿自动化测试_非P点}    ${纬度_抚州_高校曼哈顿自动化测试_非P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_高校曼哈顿_正常开关锁流程_超区收超区车调度费
    admin后台高校配置_file    subServiceAreaSettings_5.json    #修改高校配置为：电子围栏&调度费+车锁弹开
    创建高校曼哈顿骑行中订单
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1    ${区号_曼哈顿}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    清除用户高校超区记录
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_returnBike_finishRide_普通曼哈顿_正常开关锁流程_区内到区外_区外到区内_正常收取车费，退还调度费
    admin后台配置    outAreaSettings_1.json
    创建曼哈顿骑行中订单
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1103
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1    ${区号_曼哈顿}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0    0
    sleep    5s
    创建曼哈顿骑行中订单    ${区号_曼哈顿}    ${纬度_抚州_超区}    ${经度_抚州_超区}
    Wait Until Keyword Succeeds    7s    1s    曼哈顿我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州P点}    ${纬度_抚州P点}
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州P点}    ${纬度_抚州P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_P点停车还车不收调度费
    admin后台配置    #修改城市配置为：电子围栏&调度费
    创建轮毂锁骑行中订单    lat=${纬度_抚州_P点}    lng=${经度_抚州_P点}
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    causeType    1102
    曼哈顿我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_非P点还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_5.json    #修改城市配置为：电子围栏&调度费+车锁弹开
    创建轮毂锁骑行中订单    lat=${纬度_抚州_非P点}    lng=${经度_抚州_非P点}
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1105
    轮毂锁我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_有蓝牙信号不收调度费
    admin后台配置    normParkingAreaSettings_1.json    #修改城市配置为：蓝牙道钉&调度费
    创建轮毂锁骑行中订单    lat=${纬度_抚州_P点}    lng=${经度_抚州_P点}
    上报蓝牙信号    ${bikeNo}    ${有蓝牙信号}
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    causeType    1102
    轮毂锁我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_无蓝牙信号还车收非规范停车调度费
    admin后台配置    normParkingAreaSettings_1.json    #修改城市配置为：蓝牙道钉&调度费
    创建轮毂锁骑行中订单    lat=${纬度_抚州_非P点}    lng=${经度_抚州_非P点}
    上报蓝牙信号    ${bikeNo}    ${无蓝牙信号}
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    causeType    1105
    轮毂锁我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_P点}    ${纬度_抚州_P点}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_非P点}    ${纬度_抚州_非P点}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_可停车区还车不收调度费
    创建轮毂锁骑行中订单    lat=${纬度_抚州_可停车区}    lng=${经度_抚州_可停车区}
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    causeType    1103
    轮毂锁我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_收禁停区调度费
    admin后台禁停区配置    #开启禁停区配置
    创建轮毂锁骑行中订单    lat=${纬度_抚州_禁停区}    lng=${经度_抚州_禁停区}
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    causeType    1107
    轮毂锁我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_禁停区}    ${纬度_抚州_禁停区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_收区内到区外调度费
    创建轮毂锁骑行中订单
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1106
    轮毂锁我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    0
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

startRide_hubReturnBike_finishRide_轮毂锁_正常开关锁流程_收区外到区外调度费
    创建轮毂锁骑行中订单    lat=${纬度_抚州_超区}    lng=${经度_抚州_超区}
    Wait Until Keyword Succeeds    8s    1s    轮毂锁我要还车轮询断言验证    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    causeType    1104
    轮毂锁我要还车    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}    1
    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_超区}    ${纬度_抚州_超区}
    # 曼哈顿还车异常
    #    创建曼哈顿骑行中订单    lat=${纬度_抚州_可停车区}    lng=${经度_抚州_可停车区}
    #    还车异常-忘记关锁    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    #    sleep    5
    #    ${rep_response}    还车异常-忘记关锁    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}
    #    ${rep_data}    get from dictionary    ${rep_response}    data
    #    ${state}    get from dictionary    ${rep_data}    state
    #    should be Equal as Numbers    ${state}    1
    #    结束订单通用    ${bikeNo}    ${rideId}    ${经度_抚州_可停车区}    ${纬度_抚州_可停车区}    0
    #    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}
    [Teardown]    Run Keyword If Test Failed    结束订单通用    ${bikeNo}    ${rideId}

isManhattanLatestRide_用户上一笔订单是曼哈顿订单，且订单结束类型为正常结束订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideQueryIface","method":"isManhattanLatestRide","request":{"arg0":'"${guid}"'}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as numbers    ${repdata}[1][response][code]    0
    should be equal as strings    ${repdata}[1][response][data]    True
