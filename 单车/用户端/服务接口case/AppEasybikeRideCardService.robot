*** Settings ***
Suite Setup       run keywords    app登陆    ${appMobile_shaohui_authed}
...               AND    获取userNewId
...               AND    获取用户信息
...               AND    用户充值    ${appMobile_shaohui_authed}    200
...               AND    客服中心注销某用户所有骑行卡
Resource          ../../../资源配置/一键导入配置.resource

*** Test Cases ***
getTimesCardPackage_展示次卡套餐冒烟
    [Tags]    AppEasybikeRideCardService    邵惠
    ${data}    set variable    {"addr":"${AppEasybikeRideCardService}","iface":"com.easybike.ridecard.iface.TimesCardServiceIface","method":"getTimesCardPackage","request":{"arg0":{"cityCode":"021","action":"user.timescard.package","riskControlData":{"userAgent":"Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148","deviceLon":"121.364902","roam":"","systemCode":"61","deviceLat":"31.123067"},"sourceId":"a0029999","systemCode":"61","token":"980beaa2b34a4af285dad5610207df10","_userAgent":"HelloTrip/5.42.0 (iPhone; iOS 12.4.1; Scale/3.00)","adCode":"310112","ticket":"MTYwMjA0MTA1NQ==.LZLTS9qdqGxkS2MP44gI1yfhwEG98bJ7cbEvC0NxQm8=","_uuid":"c7d385b7e49544cf9ef36528af569e5e","userNewId":"1200150997","platform":0,"version":"5.42.0","ip":"58.247.66.114","_xff":"58.247.66.114"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as numbers    ${repdata}[1][response][code]    0
    should not be empty    ${repdata}[1][response][data]

getTimesCardPackage_未激活用户，cityCode为空
    [Tags]    AppEasybikeRideCardService    邵惠
    ${data}    set variable    {"addr":"${AppEasybikeRideCardService}","iface":"com.easybike.ridecard.iface.TimesCardServiceIface","method":"getTimesCardPackage","request":{"arg0":{"cityCode":"021","action":"user.timescard.package","riskControlData":{"userAgent":"Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148","deviceLon":"121.364902","roam":"","systemCode":"61","deviceLat":"31.123067"},"sourceId":"a0029999","systemCode":"61","token":"980beaa2b34a4af285dad5610207df10","_userAgent":"HelloTrip/5.42.0 (iPhone; iOS 12.4.1; Scale/3.00)","adCode":"310112","ticket":"MTYwMjA0MTA1NQ==.LZLTS9qdqGxkS2MP44gI1yfhwEG98bJ7cbEvC0NxQm8=","_uuid":"c7d385b7e49544cf9ef36528af569e5e","userNewId":"1200150997","platform":0,"version":"5.42.0","ip":"58.247.66.114","_xff":"58.247.66.114"}}}
    ${repdata}    request client    data=${data}
    should be equal as numbers    ${repdata}[0]    200
    should be equal as numbers    ${repdata}[1][response][code]    0
    should not be empty    ${repdata}[1][response][data]
