*** Settings ***
Library           HelloBikeLibrary
Resource          ../配置数据/请求配置/地理位置相关.robot
Resource          ../配置数据/业务配置/车辆相关.robot

*** Keywords ***
# 自动结束订单
#     [Arguments]    ${bikeNo}    ${rideId}    ${endTime}
#     ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":-99,"endLng":0.0,"endLat":0.0,"endChannel":3,"endTime":"${endTime}","posType":0,"isRegulatedArea":"0"}}}
#     ${repdata}    request client    data=${data}
#     ${response}    rpc接口取返回节点    ${repdata}
#     should be equal as numbers    ${response}[0]    0
#     should be equal as strings    ${response}[1]    ok
#     log    【自动结束订单】执行成功

结束订单通用
    [Arguments]    ${bikeNo}    ${rideId}    ${endLng}=0.0    ${endLat}=0.0    ${reason}=-99    ${needReturnPay}=1    ${endChannel}=1    ${posType}=0    ${isRegulatedArea}=0
    ${endTime}    获取now毫秒级时间戳
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":"${rideId}","reason":${reason},"endLng":${endLng},"endLat":${endLat},"endChannel":${endChannel},"endTime":"${endTime}","posType":${posType},"isRegulatedArea":"${isRegulatedArea}"}}}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    修改车辆骑行状态Redis    ${bikeNo}
    修改车辆骑行状态DB    ${bikeNo}
    车辆断开连接    ${bikeNo}     ${bikeKey}
    run Keyword if    ${needReturnPay}==1    用户骑行中或者待支付的最近一笔订单退费
    log    【结束订单通用】执行成功

直接上报单车开锁成功
    [Arguments]    ${车辆编号}    ${订单全局标识}    ${开始时间戳}    ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}    ${关锁原因}=${正常关锁}    ${开锁位置类型}=${开关锁位置类型_单基站}    ${蓝牙道钉信号}=${蓝牙道钉信号_检测不到}
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":"true","bikeNo":"${车辆编号}","orderGuid":${订单全局标识},"userGuid":"${用户全局标识}","startLng":${经度},"startLat":${纬度},"startTime":${开始时间戳},"posType":${开锁位置类型}}}}
    Log    直接上报单车开锁报文:${data}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    Log    【直接上报单车${车辆编号}开锁成功】 执行成功

修正骑行中的车辆状态
    [Arguments]    ${车辆编号}
    修改车辆骑行状态Redis    ${车辆编号}    返回验证=${false}
    修改车辆骑行状态DB    ${车辆编号}    返回验证=${false}
    Log    【修正骑行中的车辆状态】执行成功

直接上报单车关锁成功
    [Arguments]    ${车辆编号}    ${订单全局标识}    ${结束时间戳}    ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}    ${关锁原因}=${正常关锁}    ${关锁位置类型}=${开关锁位置类型_gps}    ${蓝牙道钉信号}=${蓝牙道钉信号_检测不到}
    修改车辆骑行状态Redis    ${车辆编号}    返回验证=${false}
    修改车辆骑行状态DB    ${车辆编号}    返回验证=${false}
    #用户端结束订单
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"finishRide","request":{"arg0":{"needGray":"true","bikeNo":"${车辆编号}","orderGuid":"${订单全局标识}","reason":${关锁原因},"endLng":${经度},"endLat":${纬度},"endChannel":1,"endTime":"${结束时间戳}","posType":${关锁位置类型},"isRegulatedArea":"${蓝牙道钉信号}"}}}
    Log    直接上报单车关锁报文:${data}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    Should Be Equal As Numbers    ${response}[0]    0    期望返回0，实际返回：${repdata}
    #用户端结束订单end
    Log    【直接上报单车${车辆编号}关锁成功】执行成功

关锁_普通锁
    [Arguments]    ${bikeNo}    ${rideId}
    结束订单通用    ${bikeNo}    ${rideId}    0.0    0.0    -99    3    0    0
    log    【关锁_普通锁】执行成功

修改车辆骑行状态DB
    [Arguments]    ${车辆编号}    ${骑行状态}=${骑行状态_闲置}    ${返回验证}=${true}
    ${data}    set variable    {"addr":"${AppOssDal}","iface":"com.hellobike.oss.dal.iface.UpdateBikeInfoIface","method":"updateBikeRunningStatus4DB","request":{"arg1":"${骑行状态}","arg0":"${车辆编号}"}}
    ${repdata}    request client    data=${data}
    Run Keyword If    ${返回验证}    Run Keywords    Log    进入【修改车辆骑行状态DB】返回验证阶段
    ...    AND    Should Be Equal As Numbers    ${repdata}[0]    200    msg 更新车辆状态到DB接口返回错误，实际返回：${repdata}
    ...    AND    Should Be Equal As Numbers    0    ${repdata}[1][response][code]    msg 更新车辆状态到DB接口失败，实际返回：${repdata}[1]
    Log    【修改车辆骑行状态DB】执行成功

修改车辆骑行状态Redis
    [Arguments]    ${车辆编号}    ${骑行状态}=${骑行状态_闲置}    ${返回验证}=${true}
    ${content}    redis command    bikestatus    1    set bikeScStatus:${车辆编号} ${骑行状态}
    Run Keyword If    ${返回验证}    Run Keywords    Log    进入【修改车辆骑行状态Redis】返回验证阶段
    ...    AND    Should Be Equal As Numbers    ${content}[0]    200    msg 设置redis返回错误，实际返回：${content}
    ...    AND    Should Be Equal As Numbers    ${content}[1][code]    0    msg 修改车辆骑行状态redis失败，实际返回：${content}[1]
    Log    【修改车辆骑行状态Redis】成功

设置车辆网络ip
    [Arguments]    ${bikeNo}    ${bikeserviceip}=${bikeServiceIp}    ${返回验证}=${true}
    ${content}    redis command without database    bikeuser-cluster    set bikeServiceIp:${bikeNo} '${bikeserviceip}'
    Run Keyword If    ${返回验证}    Run Keywords    Log    进入【设置车辆网络ip】返回验证阶段
    ...    AND    Should Be Equal As Numbers    ${content}[0]    200    msg 设置车辆网络ip返回错误，实际返回：${content}
    ...    AND    Should Be Equal As Strings    ${content}[1][data]    OK    msg 设置车辆网络ip失败，实际返回：${content}[1]
    Log    【设置车辆网络ip】执行成功

车辆上报状态
    [Arguments]    ${bikeNo}
    ${data}    set variable     {"addr":"${AppHellobikeBikeStateService}","iface":"com.hellobike.bike.bikeState.iface.BikeStateServiceIface","method":"reportState","request":{"arg2":'"AAAANpckswABAAAYcQAAigMGBgP3EQAAAAAAJxAAAAAAAAAAAAAAAA=="',"arg1":"11","arg0":'"${bikeNo}"'}}
    ${repData}    request client    data=${data}
    log    【车辆上报状态】成功

曼哈顿确认开锁
    [Arguments]    ${bikeNo}     ${citys}    ${lat}   ${lng}
    ${data}    create dictionary    action=user.ride.create    version=${APPversion}    systemCode=62    adCode=    token=${token}    areaEdgeDistance=6.923941076401    bikeNo=${bikeNo}    cityCode=${citys}    connectBluetooth=False    deviceHash=95b04a3725d102d9019b6ffcf45d86917486297a79fc4870f021592a596d583f    deviceId=860714040783362    deviceUserAgent=Mozilla/5.0 (Linux; Android 9; Redmi K20 Build/PKQ1.190302.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/72.0.3626.121 Mobile Safari/537.36    force=1    lat=${lat}    lng=${lng}
    ...    mode=0    model=0    rideLicenseforce=1    signalType=2
    log    ${data}
    ${content}    request client    url=${fatBikeApi}    data=${data}
    Should Be Equal As Numbers    ${content}[0]    200
    Dictionary Should Contain Key    ${content}[1]    data
    Should be True    ${content}[1][data][result]
    Set Suite Variable    ${createTime}    ${content}[1][data][createTime]
    Set Suite Variable    ${rideId}    ${content}[1][data][rideId]
    log   ${content}

创建曼哈顿骑行中订单
    [Arguments]    ${citys}=${区号_曼哈顿}   ${lat}=${纬度_抚州P点}    ${lng}=${经度_抚州P点}
    ${bikeNo}  获取曼哈顿车辆编号  ${citys}
    Set Global Variable    ${bikeNo}
    获取用户信息
    车辆上报状态    ${bikeNo}
    ${bikeKey}   获取bikeKey      ${bikeNo}
    Set Global Variable    ${bikeKey}
    连接车辆    ${bikeNo}   bikeKey=${bikeKey}    projectVersion=22    softwareVersion=12
    清除车辆上一次关锁后的30s缓存   ${bikeNo}
    曼哈顿确认开锁   ${bikeNo}  ${citys}   ${lat}  ${lng}
    直接上报单车开锁成功   ${bikeNo}   ${rideId}    ${createTime}
    检查骑行中订单为曼哈顿订单

创建高校曼哈顿骑行中订单
    [Arguments]    ${citys}=${区号_曼哈顿}   ${service_area_name}=高校曼哈顿自动化测试    ${lat}=${纬度_抚州_高校曼哈顿自动化测试_P点}    ${lng}=${经度_抚州_高校曼哈顿自动化测试_P点}
    ${bikeNo}  获取曼哈顿高校车辆编号  ${citys}   ${service_area_name}
    Set Global Variable    ${bikeNo}
    获取用户信息
    车辆上报状态    ${bikeNo}
    ${bikeKey}   获取bikeKey      ${bikeNo}
    连接车辆    ${bikeNo}   bikeKey=${bikeKey}    projectVersion=12    softwareVersion=22
    设置车辆位置    ${bikeNo}    ${lat}    ${lng}
    admin后台配置    # 开启曼哈顿配置
    admin后台高校配置_file    # 开启学校配置
    清除车辆上一次关锁后的30s缓存   ${bikeNo}
    曼哈顿确认开锁   ${bikeNo}  ${citys}   ${lat}   ${lng}
    直接上报单车开锁成功   ${bikeNo}   ${rideId}    ${createTime}
    检查骑行中订单为曼哈顿订单

创建轮毂锁骑行中订单
    [Arguments]    ${citys}=${区号_曼哈顿}    ${lat}=${纬度_抚州P点}    ${lng}=${经度_抚州P点}
    ${bikeNo}  获取轮毂锁车辆编号  ${citys}
    Set Global Variable    ${bikeNo}
    获取用户信息
    车辆上报状态    ${bikeNo}
    ${bikeKey}   获取bikeKey      ${bikeNo}
    Set Global Variable    ${bikeKey}
    连接车辆    ${bikeNo}   bikeKey=${bikeKey}    projectVersion=32    softwareVersion=12
    清除车辆上一次关锁后的30s缓存   ${bikeNo}
    曼哈顿确认开锁   ${bikeNo}  ${citys}   ${lat}  ${lng}
    直接上报单车开锁成功   ${bikeNo}   ${rideId}    ${createTime}
    检查骑行中订单为轮毂锁订单
