*** Settings ***
Default Tags      <AppHellobikeRideProcessService>
Library           HelloBikeLibrary
Library           DatabaseLibrary
Library           Collections
Resource          ../../../资源配置/一键导入配置.resource

*** Test Cases ***
isForbiddenCity_验证参数传入为空
    ${data}    set variable    {"addr":"${AppHellobikeRideProcessService}","iface":"com.easybike.rideprocess.ifaces.AppCustomerServiceIface","method":"isForbiddenCity","request":{"arg0":{"cityCode":""}}}
    ${repData}    request client    data=${data}
    should be equal as strings    ${repData}[0]    200
    ${rep_data}    set variable    ${repData}[1]
    ${rep_response}    get from dictionary    ${rep_data}    response
    ${rep_response_code}    get from dictionary    ${rep_response}    code
    ${rep_response_msg}    get from dictionary    ${rep_response}    msg
    should be equal as strings    ${rep_response_code}    104
    should be equal as strings    ${rep_response_msg}    参数错误
