*** Variables ***
${fatApi}         https://fat-api.hellobike.com/api
${fatBikeApi}     https://fat-bike.hellobike.com/api
${AppHellobikeRideProcessService}    10.111.14.20:55001
${AppHellobikeRideApiService}    10.164.4.165:9997
${AppHellobikeOpenlockService}    10.111.14.20:51500
${AppHellobikeBikeStateService}    10.111.10.195:61686
${AppEasybikeBikeService}    10.111.10.61:28011
${AppHellobikeFaultService}    10.111.14.20:43025
${AppHellobikeActivityConfigService}    10.111.71.18:58091
${AppHelloBikeTradeService}    10.111.14.21:40066
${AppOssDAL}      10.111.10.64:59027
${客服中心注销用户}       http://10.111.10.78:40002/user/logoutUser
${客服中心获取骑行卡列表}    http://10.111.71.18:60070/bike-admin/rideCard/getUserRideCardChange    #http://47.110.68.235:60070/bike-admin/rideCard/getUserRideCardChange
${客服中心退骑行卡}       http://10.111.71.18:60070/bike-admin/rideCard/refundRideCard    #http://47.110.68.235:60070/bike-admin/rideCard/refundRideCard
${失联车同步缓存}        http://10.111.10.64:9298/setossbikeinfo1/?bikeNo=    #${失联车同步缓存_fat}    http://10.111.10.64:9298/setossbikeinfo1/?bikeNo=    #${失联车同步缓存_uat}    http://10.111.71.105:9298/setossbikeinfo1/?bikeNo=
${admin订单退费}      http://10.111.71.18:40002/order/changeOrderMoney    #外网 http://47.110.68.235:40002/order/changeOrderMoney
${bmsToken}       a7011e06eb0e0e943be36e73e8e0c833
${bmsUserAgent}    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36
${AppHelloMercuryApi}    10.111.10.207:40008
${AppEasybikeRideCardService}    10.111.14.21:40044
