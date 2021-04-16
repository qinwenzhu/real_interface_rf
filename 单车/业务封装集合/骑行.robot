*** Settings ***
Library           Collections
Resource          ../数据源获取/车辆.robot
Resource          ../业务封装集合/通用.robot

*** Keywords ***
# 确认开锁
#     [Arguments]    ${bikeNo}
#     ${data}    create dictionary    action=user.ride.create    version=${接口的最新版本}    systemCode=61    adCode=    token=${token}    areaEdgeDistance=6489.923941076401    bikeNo=${bikeNo}    cityCode=021    connectBluetooth=False    deviceHash=95b04a3725d102d9019b6ffcf45d86917486297a79fc4870f021592a596d583f    deviceId=860714040783362    deviceUserAgent=Mozilla/5.0 (Linux; Android 9; Redmi K20 Build/PKQ1.190302.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/72.0.3626.121 Mobile Safari/537.36    force=1    lat=31.1249201    lng=121.3602946
#     ...    mode=0    model=0    rideLicenseforce=1    signalType=5
#     log    ${data}
#     ${content}    request client    url=${fatBikeApi}    data=${data}
#     Should Be Equal As Numbers    ${content}[0]    200
#     Dictionary Should Contain Key    ${content}[1]    data
#     Should be True    ${content}[1][data][result]
#     Set Suite Variable    ${createTime}    ${content}[1][data][createTime]
#     Set Suite Variable    ${rideId}    ${content}[1][data][rideId]
#     [Return]    ${content}

单车确认开锁
    [Arguments]    ${车辆编号}    ${区号}=${区号_上海}    ${行政代码}=${行政代码_闵行区}    ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}    ${令牌}=${token}    ${版本}=${接口的最新版本}   ${超200M是否强制开锁}=${超200M是否强制开锁_强制/蓝牙开锁}    ${模式}=${开锁模式_普通模式}    ${客户端}=${安卓客户端}    ${开锁方式}=${开锁方式_扫码开锁}    ${返回验证}=${true}    ${位置信号类型}=${位置信号类型_初始化}    ${验证驾照分}=${验证驾照分_验证}      ${正常开锁}=${true}     ${connectBluetooth}=${false}
    # Run Keyword If    ${正常开锁}      redis command without database    bikeuser-cluster    del userBike:${guid}
    redis command without database    bikeuser-cluster    del userBike:${guid}
    #返回举例：{"code":0,"data":{"result":true,"rideId":"15847806197191200089936","createTime":1584780619808,"bikeType":0,"missBike":false}}
    ${data}    单车确认开锁报文    车辆编号=${车辆编号}    区号=${区号}    行政代码=${行政代码}    纬度=${纬度}    经度=${经度}    令牌=${令牌}    版本=${版本}     超200M是否强制开锁=${超200M是否强制开锁}    模式=${模式}    客户端=${客户端}    开锁方式=${开锁方式}    位置信号类型=${位置信号类型}    验证驾照分=${验证驾照分}    connectBluetooth=${connectBluetooth}
    ${content}    通用调用    调用接口=单车确认开锁调用    报文体=${data}
    Should Be Equal As Numbers    ${content}[0]    200    【单车${车辆编号}确认开锁】接口返回应该是200
    #验证部分
    Run Keyword If    ${返回验证}    Run Keywords    Log    进入【单车确认开锁】接口返回验证阶段
    ...    AND    Dictionary Should Contain Key    ${content}[1]    data    【单车${车辆编号}确认开锁】接口返回应该有key：data,实际返回：${content}[1]
    ...    AND    Should be True    ${content}[1][data][result]    【单车${车辆编号}确认开锁】接口返回应该返回成功,实际返回：${content}[1]
    ...    AND    Set Suite Variable    ${createTime}    ${content}[1][data][createTime]
    ...    AND    Set Suite Variable    ${rideId}    ${content}[1][data][rideId]
    #验证部分end
    Log    【单车${车辆编号}确认开锁】执行成功
    [Return]    ${content}

单车确认开锁报文
    [Arguments]    ${车辆编号}    ${区号}    ${行政代码}    ${纬度}    ${经度}    ${令牌}    ${版本}    ${超200M是否强制开锁}    ${模式}    ${客户端}    ${开锁方式}    ${位置信号类型}    ${验证驾照分}    ${connectBluetooth}
    ${deviceFingerprinting_荣耀8X}     Evaluate    json.loads('''${deviceFingerprinting_荣耀8X}''')     modules=json
    ${单车确认开锁安卓报文}    create dictionary    action=user.ride.create    version=${版本}    systemCode=${systemCode_安卓}    token=${令牌}    adCode=${行政代码}    adSource=    areaEdgeDistance=5725.221663181397    bikeNo=${车辆编号}    cityCode=${区号}    connectBluetooth=${connectBluetooth}
    ...    force=${超200M是否强制开锁}    lat=${纬度}    lng=${经度}    mode=${模式}    model=${开锁方式}    rideLicenseforce=${验证驾照分}    signalType=${位置信号类型}    platform=${平台类型_APP}    deviceFingerprinting=${deviceFingerprinting_荣耀8X}    deviceHash=${deviceHash_荣耀8X}    deviceId=${deviceId_荣耀8X}    deviceModel=${deviceModel_荣耀8X}    deviceUserAgent=${deviceUserAgent_荣耀8X}
    ${deviceFingerprinting_iPhone}     Evaluate    json.loads('''${deviceFingerprinting_iPhone}''')     modules=json
    ${单车确认开锁ios报文}    create dictionary    action=user.ride.create    version=${版本}    systemCode=${systemCode_IOS}    token=${令牌}    adCode=${行政代码}    adSource=    areaEdgeDistance=5725.221663181397    bikeNo=${车辆编号}    cityCode=${区号}    connectBluetooth=${connectBluetooth}
    ...    force=${超200M是否强制开锁}    lat=${纬度}    lng=${经度}    mode=${模式}    model=${开锁方式}    rideLicenseforce=${验证驾照分}    signalType=${位置信号类型}    platform=${平台类型_APP}    deviceFingerprinting=${deviceFingerprinting_iPhone}    deviceHash=${deviceHash_iPhone}    deviceId=${deviceId_iPhone}    deviceModel=${deviceModel_iPhone}    deviceUserAgent=${deviceUserAgent_iPhone}
    ${单车确认开锁安卓支付宝小程序报文}    create dictionary    action=user.ride.create    version=${版本}
    ${报文}    Run Keyword If    '${客户端}' == '${安卓客户端}'    Set Variable    ${单车确认开锁安卓报文}
    ...    ELSE IF   '${客户端}' == '${ios客户端}'    Set Variable    ${单车确认开锁ios报文}   ELSE    Set Variable    ${单车确认开锁安卓支付宝小程序报文}
    log    【单车确认开锁报文】执行成功
    [Return]    ${报文}

预开锁
    [Arguments]    ${车辆编号}    ${区号}=${区号_上海}    ${行政代码}=${行政代码_闵行区}    ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}    ${令牌}=${token}    ${版本}=${接口的最新版本}    ${模式}=${开锁模式_普通模式}   ${开锁方式}=${开锁方式_扫码开锁}    ${客户端}=${安卓客户端}
    ${data}    预开锁报文    车辆编号=${车辆编号}    区号=${区号}    行政代码=${行政代码}    纬度=${纬度}    经度=${经度}    令牌=${令牌}    版本=${版本}    模式=${模式}    客户端=${客户端}   开锁方式=${开锁方式}
    ${content}    通用调用    调用接口=单车预开锁调用    报文体=${data}
    Log    【单车${车辆编号}预开锁】执行成功
    [Return]    ${content}

预开锁报文
    [Arguments]    ${车辆编号}    ${区号}    ${行政代码}    ${纬度}    ${经度}    ${令牌}    ${版本}    ${模式}    ${客户端}    ${开锁方式}
    ${当前时间戳}   获取now毫秒级时间戳
    ${deviceFingerprinting_荣耀8X}     Evaluate    json.loads('''${deviceFingerprinting_荣耀8X}''')     modules=json
    ${单车预开锁安卓报文}    create dictionary    action=user.ride.pre.ride    version=${版本}    systemCode=${systemCode_安卓}    token=${令牌}    bikeNo=${车辆编号}    cityCode=${区号}    adCode=${行政代码}    lat=${纬度}    lng=${经度}    clientId=    force=0
    ...    mode=${模式}    model=${开锁方式}    noNetwork=false    platform=${平台类型_APP}    signalType=1    deviceHash=${deviceHash_荣耀8X}    deviceId=${deviceId_荣耀8X}    deviceUserAgent=${deviceUserAgent_荣耀8X}    deviceFingerprinting=${deviceFingerprinting_荣耀8X}
    ${deviceFingerprinting_iPhone}     Evaluate    json.loads('''${deviceFingerprinting_iPhone}''')     modules=json
    ${单车预开锁ios报文}    create dictionary    action=user.ride.pre.ride    version=${版本}    systemCode=${systemCode_IOS}    token=${令牌}    bikeNo=${车辆编号}    cityCode=${区号}    adCode=${行政代码}    lat=${纬度}    lng=${经度}    clientId=    force=0
    ...    mode=${模式}    model=${开锁方式}    noNetwork=false    platform=${平台类型_APP}    signalType=1    deviceHash=${deviceHash_iPhone}    deviceId=${deviceId_iPhone}    deviceUserAgent=${deviceUserAgent_iPhone}    deviceFingerprinting=${deviceFingerprinting_iPhone}
    ${单车预开锁安卓支付宝小程序报文}   create dictionary    action=user.ride.pre.ride    version=${版本}   releaseVersion=20200316     from=alipay   systemCode=${systemCode_支付宝小程序}    platform=${平台类型_小程序}    mobileModel=vivo V1731CA      alipayVersion=10.1.88.7000      mobileSystem=8.1.0     SDKVersion=1.24.0   systemPlatform=Android  mobileBrand=vivo     model=${开锁方式}   force=0    bikeNo=${车辆编号}    lng=${经度}    lat=${纬度}      cityCode=${区号}   mode=${模式}    connectBluetooth=false    adCode=${行政代码}    isHitPositionCache=0     cacheLbsTime=30    userPostionRecordTime=${当前时间戳}    getLocationTime=${当前时间戳}    scanChannel=2    noNetwork=false    locationTime=${当前时间戳}  signalType=5   token=${令牌}
    ${报文}    Run Keyword If    '${客户端}' == '${安卓客户端}'    Set Variable    ${单车预开锁安卓报文}
    ...    ELSE IF    '${客户端}' == '${ios客户端}'    Set Variable    ${单车预开锁ios报文}    ELSE    Set Variable    ${单车预开锁安卓支付宝小程序报文}
    log    【预开锁报文】执行成功
    [Return]    ${报文}

预约车辆
    [Arguments]    ${车辆编号}    ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}
    ${data}    预约车辆报文    车辆编号=${车辆编号}    纬度=${纬度}    经度=${经度}
    ${content}    通用调用    调用接口=单车预约车辆    报文体=${data}
    #期望返回：{'code': 0, 'data': {'leftTime': 600000}}
    Should Be Equal As Numbers  200     ${content}[0]  msg 期望调用成功，实际返回：${content}
    Should Be Equal As Numbers  0     ${content}[1][code]
    Log    【预约车辆】${车辆编号}执行成功
    [Return]    ${content}

预约车辆报文
    [Arguments]    ${车辆编号}    ${纬度}    ${经度}    ${令牌}=${token}    ${版本}=${接口的最新版本}
    ${data}    create dictionary    action=user.ride.reserve    version=${版本}    systemCode=${systemCode_安卓}    token=${令牌}    bikeNo=${车辆编号}    lat=${纬度}    lng=${经度}
    Log    【预约车辆报文】执行成功
    [Return]    ${data}

取消预约车辆
    [Arguments]    ${车辆编号}     ${令牌}=${token}    ${版本}=${接口的最新版本}
    ${data}    create dictionary    action=user.ride.cancel    version=${版本}    token=${令牌}    bikeNo=${车辆编号}
    ${content}    通用调用    调用接口=取消单车预约车辆    报文体=${data}
    #期望返回：{'code': 0, 'msg': 'ok'}
    Should Be Equal As Numbers  200     ${content}[0]  msg 期望调用成功，实际返回：${content}
    should be Equal as Numbers    ${content}[1][code]    0
    Log    【取消预约车辆】${车辆编号}执行成功
    [Return]    ${content}

查询城市可用车辆_创建订单
    [Arguments]    ${cityCode}=021    ${adCode}=310112    ${lat}=31.1249201     ${lng}=121.3602946
    ${bikeNo}    获取普通运营中闲置的车辆    ${cityCode}    3
    ${content}    单车确认开锁    ${bikeNo}    ${cityCode}    ${adCode}    ${lat}     ${lng}
    set Suite variable    ${bikeNo}
    log    【查询城市可用车辆_创建订单】执行成功
    [Return]    ${content}

查询城市可用车辆-sh_创建订单
    [Arguments]    ${cityCode}=021    ${adCode}=310112    ${lat}=31.1249201     ${lng}=121.3602946
    ${bikeNo}    获取普通运营中闲置的车辆-sh    ${cityCode}
    ${content}    单车确认开锁    ${bikeNo}    ${cityCode}    ${adCode}    ${lat}     ${lng}
    set Suite variable    ${bikeNo}
    log    【查询城市可用车辆_创建订单】执行成功
    [Return]    ${content}

查询城市可用车辆_创建订单_开始订单
    [Arguments]    ${cityCode}=021    ${adCode}=310112    ${lat}=31.1249201     ${lng}=121.3602946
    查询城市可用车辆_创建订单    ${cityCode}    ${adCode}    ${lat}     ${lng}
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":${rideId},"userGuid":"${guid}","startLng":${lng},"startLat":${lat},"startTime":${createTime},"posType":1}}}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    Should be Equal as Numbers    ${response}[0]    0
    Should be Equal as strings    ${response}[1]    ok
    log    【查询城市可用车辆_创建订单_开始订单】 执行成功

查询城市可用车辆-sh_创建订单_开始订单
    [Arguments]    ${cityCode}=021    ${adCode}=310112    ${lat}=31.1249201     ${lng}=121.3602946
    查询城市可用车辆-sh_创建订单    ${cityCode}    ${adCode}    ${lat}     ${lng}
    ${data}    set variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"${bikeNo}","orderGuid":${rideId},"userGuid":"${guid}","startLng":${lng},"startLat":${lat},"startTime":${createTime},"posType":1}}}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    Should be Equal as Numbers    ${response}[0]    0
    Should be Equal as strings    ${response}[1]    ok
    log    【查询城市可用车辆-sh_创建订单_开始订单】 执行成功

曼哈顿我要还车
    [Arguments]     ${bikeNo}    ${orderGuid}    ${lng}=${经度_抚州_高校曼哈顿自动化测试_P点}     ${lat}=${纬度_抚州_高校曼哈顿自动化测试_P点}     ${operateType}=0    ${cityCode}=${区号_曼哈顿}
    ${data}     set Variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"returnBike","request":{"arg0":{"bikeNo":"${bikeNo}","orderGuid":"${rideId}","_uuid":"${guid}","userNewId":${usernewid},"lng":${lng},"lat":${lat},"systemCode":"61","cityCode":"${cityCode}","operateType":${operateType},"version":"${接口的最新版本}"}}}
    ${content}    request client    data=${data}
    should be Equal as Numbers    ${content}[0]     200
    ${rep_response}    Set Variable    ${content}[1][response]
    should be Equal as Numbers    ${content}[1][response][code]    0
    log     【曼哈顿我要还车】执行成功
    [Return]    ${rep_response}

曼哈顿我要还车轮询断言验证
    [Arguments]     ${bikeNo}    ${rideId}    ${经度}    ${纬度}    ${key}=state    ${value}=[1,2]
    ${rep_response}     曼哈顿我要还车     ${bikeNo}    ${rideId}    ${经度}    ${纬度}
    ${valueP}     set Variable     ${rep_response['data']}[${key}]
    run keyword if    '${key}'=='state'     variable should exist    ${valueP}    '1,2'
    ...     ELSE    should be Equal as Numbers    ${value}     ${valueP}

轮毂锁我要还车
    [Arguments]     ${bikeNo}    ${orderGuid}    ${lng}=${经度_抚州_高校曼哈顿自动化测试_P点}     ${lat}=${纬度_抚州_高校曼哈顿自动化测试_P点}     ${operateType}=0    ${cityCode}=${区号_曼哈顿}
    ${data}     set Variable    {"addr":"${AppHellobikeRideApiService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"hubReturnBike","request":{"arg0":{"bikeNo":"${bikeNo}","orderGuid":"${rideId}","_uuid":"${guid}","userNewId":${usernewid},"lng":${lng},"lat":${lat},"systemCode":"61","cityCode":"${cityCode}","operateType":${operateType},"version":"${接口的最新版本}"}}}
    ${content}    request client    data=${data}
    should be Equal as Numbers    ${content}[0]     200
    ${rep_response}    Set Variable    ${content}[1][response]
    should be Equal as Numbers    ${rep_response}[code]    0
    log     【轮毂锁我要还车】执行成功
    [Return]    ${rep_response}

轮毂锁我要还车轮询断言验证
    [Arguments]     ${bikeNo}    ${rideId}    ${经度}    ${纬度}    ${key}=state    ${value}=[1,2]
    ${rep_response}     轮毂锁我要还车     ${bikeNo}    ${rideId}    ${经度}    ${纬度}
    ${valueP}     set Variable     ${rep_response['data']}[${key}]
    run keyword if    '${key}'=='state'     variable should exist    ${valueP}    '1,2'
    ...     ELSE    should be Equal as Numbers    ${value}     ${valueP}

还车异常区域核
    [Arguments]     ${bikeNo}    ${rideId}    ${lng}=${经度_抚州_高校曼哈顿自动化测试_P点}     ${lat}=${纬度_抚州_高校曼哈顿自动化测试_P点}     ${cityCode}=${区号_曼哈顿}     ${systemCode}=65     ${adCode}=${行政代码_曼哈顿}    ${bikeFaultCode}=4
    ${data}     set Variable    {"addr":"${AppHellobikeFaultService}","iface":"com.easybike.fault.ifaces.UserBikeFaultIface","method":"areaVerify","request":{"arg0":{"appVersion":"${APPversion}","systemCode":"61","ip":"58.247.66.114","orderGuid":"${rideId}","bikeFaultCode":${bikeFaultCode},"bikeNo":"${bikeNo}","action":"user.fault.area.verify","token":"${token}","lng":${lng},"adCode":"310112","riskControlData":{"deviceLat":"31.123025","userAgent":"Mozilla/5.0 (iPhone; CPU iPhone OS 11_0_3 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Mobile/15A432","deviceLon":"121.364780","roam":"","systemCode":"61"},"_xff":"58.247.66.114","userNewId":"${usernewid}","sourceId":"a0029999","lat":${lat},"_uuid":"${guid}","_userAgent":"HelloTrip/5.41.0 (iPhone; iOS 11.0.3; Scale/3.00)","version":"${APPversion}","cityCode":"${cityCode}"}}}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    Should be Equal as Numbers    ${response}[0]    0
    Should be Equal as strings    ${response}[1]    ok
    Log    【还车异常区域核】执行成功
    log    
    [Return]    ${response}

还车异常区域核轮询断言

还车异常-忘记关锁
    [Arguments]     ${bikeNo}    ${rideId}    ${lng}=${经度_抚州_高校曼哈顿自动化测试_P点}     ${lat}=${纬度_抚州_高校曼哈顿自动化测试_P点}     ${cityCode}=${区号_曼哈顿}    ${releaseVersion}=20200316     ${systemCode}=65    ${mobileSystem}=13.3.1    ${from}=alipay    ${platform}=3    ${adCode}=${行政代码_曼哈顿}       ${bikePickType}=1       ${SDKVersion}=1.24.2    ${riskId}=61295a9901ae4f7da31ba5577c5a8acb      ${mobileModel}=iPhone11,8       ${userAgent}=Mozilla/5.0 (iPhone; CPU iPhone OS 13_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/17D50 Ariver/1.0.11 AliApp(AP/10.1.90.8000) Nebula WK RVKType(0) AlipayDefined(nt:WIFI,ws:414|832|2.0) AlipayClient/10.1.90.8000 Language/zh-Hans NebulaX/1.0.0
    ${data}     set Variable    {"addr":"${AppHellobikeFaultService}","iface":"com.easybike.fault.ifaces.BikeFaultIface","method":"reportBikeObjection","request":{"arg0":"{"_fingerPrintRawdata":"","releaseVersion":"${releaseVersion}","systemCode":${systemCode},"mobileSystem":"${mobileSystem}","bikeNo":"${bikeNo}","lat":"${lat}","_fingerPrintHash":"","from":"${from}","platform":${platform},"adCode":"${adCode}","bikePickType":${bikePickType},"SDKVersion":"${SDKVersion}","rideId":"${rideId}","_riskId":"${riskId}","version":"${接口的最新版本}","mobileModel":"${mobileModel}","token":"${token}","userNewId":"${usernewid}","_userAgent":"${userAgent}","lng":"${lng}","systemPlatform":"iOS","action":"user.fault.appeal","_uuid":"${guid}","alipayVersion":"10.1.90.8000","_xff":"47.97.253.14","riskControlData":{"systemCode":"65","network":"WIFI","deviceLon":"${lng}","deviceLat":"${lat}","batteryLevel":"41"},"mobileBrand":"iPhone","cityCode":"${cityCode}","faultDesc":"","appealType":2,"ip":"47.97.253.14"}"}}
    ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    Should be Equal as Numbers    ${response}[0]    0
    Should be Equal as strings    ${response}[1]    ok
    Log    【还车异常-忘记关锁】执行成功
    [Return]    ${response}

检查骑行中订单为曼哈顿订单
    ${data}    create dictionary    action=user.ride.bikeCheck    version=${APPversion}    systemCode=62    token=${token}
    log    ${data}
    ${content}    request client    url=${fatBikeApi}    data=${data}
    should be Equal as Numbers    ${content}[0]    200
    Set Suite Variable    ${processSwitch}    ${content}[1][data][ride][order][processSwitch]
    log    ${content}
    Should Be true   ${processSwitch}

检查骑行中订单为轮毂锁订单
    ${data}    create dictionary    action=user.ride.bikeCheck    version=${APPversion}    systemCode=62    token=${token}
    log    ${data}
    ${content}    request client    url=${fatBikeApi}    data=${data}
    should be Equal as Numbers    ${content}[0]    200
    Set Suite Variable    ${processType}    ${content}[1][data][ride][order][processType]
    log    ${content}
    should be Equal as Numbers   ${processType}    1

曼哈顿我要还车-http
    [Arguments]    ${bikeNo}    ${APPversion}   ${lng}    ${lat}    ${cityCode}     ${rideId}
    ${data}    create dictionary    action=user.ride.pre.close    version=${APPversion}    bikeNo=${bikeNo}   systemCode=62    token=${token}   lat=${lat}  lng=${lng}  cityCode=${citys}   operateType=0   orderGuid=${rideId}     platform=0
    log    ${data}
    ${content}    request client    url=${fatBikeApi}    data=${data}
    should be Equal as Numbers    ${content}[0]    200
    should be Equal as Numbers    ${content}[1][code]    0

曼哈顿接受调度费-http
    [Arguments]    ${bikeNo}    ${APPversion}   ${lng}    ${lat}    ${cityCode}     ${rideId}
    ${data}    create dictionary    action=user.ride.pre.close    version=${APPversion}    bikeNo=${bikeNo}   systemCode=62    token=${token}   lat=${lat}  lng=${lng}  cityCode=${citys}   operateType=1   orderGuid=${rideId}     platform=0
    log    ${data}
    ${content}    request client    url=${fatBikeApi}    data=${data}
    should be Equal as Numbers    ${content}[0]    200
    should be Equal as Numbers    ${content}[1][code]    0

更新订单开始时间-sh
    [Arguments]    ${time}
    ${tableNo}    连接数据库_bike_order_fat
    ${now}    get current date
    ${starttimeU}    subtract time from date    ${now}    ${time}
    ${starttimeUS}  北京时间转换为毫秒级时间戳    ${starttimeU}
    ${sql}    set variable    update t_ride_info_${tableNo} set start_time='${starttimeU}' where guid='${rideId}'
    ${dbcontent}    更新    ${sql}
    run keyword if    ${dbcontent} == None    log    @@更新start_time on DB @@成功
    ${rediscontent}    redis command without database    bikeorder-cluster    hset order:${rideId} startTime '${starttimeUS}'
    Should Be Equal As Numbers    0    ${rediscontent}[1][code]
    log    【更新订单开始时间成功】
    [return]    ${starttimeU}

行程详情
    [Arguments]     ${订单全局标识}     ${系统代码}=${systemCode_安卓}     ${令牌}=${token}     ${版本}=${接口的最新版本}     ${行政代码}=${行政代码_闵行区}      ${区号}=${区号_上海}   ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}
    ${订单全局标识}     Convert To String   ${订单全局标识}
    ${data}     行程详情报文    ${订单全局标识}     系统代码=${系统代码}     令牌=${令牌}     版本=${版本}     行政代码=${行政代码}      区号=${区号}   纬度=${纬度}    经度=${经度}
    ${content}    通用调用    调用接口=行程详情调用    报文体=${data}
    # 期望返回：{'code': 0, 'data': {'showMailboxIconType': 3, 'detail': {'orderType': 0, 'penalty': 1, 'parkAreaType': 3, 'carbonEmissionSaving': 0, 'endPointLat': 31.03969, 'returnPenaltyTimUnit': 1, 'returnPenaltyTime': 1, 'orderGuid': 15872001678801200127243, 'userNewId': 1200127243, 'endPointLng': 125.466903, 'insuranceText': '本订单为你免费投保骑行意外险', 'startTime': 1587189368000, 'discountType': -1, 'manhattanModel': False, 'payCost': 101, 'sendBack': 1, 'rideDistance': 21528, 'rideTime': 180, .....
    Should Be Equal As Numbers    0    ${content}[1][code]      接口返回的code不应该为0
    Should Not Be Empty      ${content}[1][data]       接口返回的data不应该为空
    Log    【行程详情】执行成功
    [Return]    ${content}

行程详情报文
    [Arguments]     ${订单全局标识}     ${系统代码}     ${令牌}     ${版本}     ${行政代码}      ${区号}    ${纬度}    ${经度}
    ${riskControlData}     Create Dictionary   deviceLat=${纬度}    deviceLon=${经度}   systemCode=${系统代码}      userAgent=${deviceUserAgent_荣耀8X}     network=Wifi    mobileNoInfo=中国联通   ssidName=HelloBike      capability=NONE     roam=86    batteryLevel=100
    ${data}     Create Dictionary   action=user.ride.detail     clientId=       systemCode=${系统代码}    token=${令牌}     version=${版本}     adCode=${行政代码}      cityCode=${区号}    orderGuid=${订单全局标识}   riskControlData=${riskControlData}
    Log     【行程详情报文】${data}
    [Return]    ${data}

支付订单
    [Arguments]     ${订单全局标识}     ${支付总金额}    ${系统代码}=${systemCode_安卓}    ${令牌}=${token}     ${版本}=${接口的最新版本}      ${收银台}=${actionOrigin_标准收银台}    ${行政代码}=${行政代码_闵行区}    ${业务线}=${businessType_业务线_单车}      ${支付渠道}=${channel_支付渠道_余额}    ${区号}=${区号_上海}    ${支付发起时的IP地址}=${clientIP_支付发起时的IP地址}    ${授信模式}=${creditModel_授信模式_普通}    ${订单类型}=${type_订单类型_正常的待支付订单}
    ${data}     支付订单报文    ${订单全局标识}    ${支付总金额}    系统代码=${系统代码}    令牌=${token}     版本=${接口的最新版本}      收银台=${收银台}    行政代码=${行政代码}    业务线=${业务线}      支付渠道=${支付渠道}    区号=${区号}    支付发起时的IP地址=${支付发起时的IP地址}    授信模式=${授信模式}    订单类型=${订单类型}
    ${content}    通用调用    调用接口=支付订单调用    报文体=${data}   接口地址=${fatApi}
    # 期望返回：{'code': 0, 'msg': 'ok', 'data': {'orders': [{'guid': 568721494814883840, 'amount': 101, 'orderId': 15872001678801200127243, 'businessType': 1}], 'status': 'success', 'channel': '003'}}
    Should Be Equal As Numbers    0    ${content}[1][code]      接口返回的code不应该为0
    Should Not Be Empty      ${content}[1][data]       接口返回的data不应该为空
    Should Be Equal      success    ${content}[1][data][status]       接口返回的status应该为success
    Log    【支付订单】执行成功
    [Return]    ${content}
