*** Settings ***
Resource          ../../../资源配置/一键导入配置.resource

*** Test Cases ***
addOrUpdateParkActivity_正常流程
    ${data}    set variable    {"addr":"${AppHellobikeActivityConfigService}","iface":"com.hellobike.ride.api.iface.RideIface","method":"startRide","request":{"arg0":{"needGray":True,"bikeNo":"9120069457","orderGuid":"","userGuid":"9b277e5cb1e14e119127e26b42c4338a","startLng":113.5294957,"startLat":22.2534844,"startTime":1584433074000,"posType":1}}}
    ${repdata}    request client    data=${data}
