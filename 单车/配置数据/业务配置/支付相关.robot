*** Variables ***
# com.alphapay.paymentOrder.pay     文档   https://yapi.hellobike.cn/project/2039/interface/api/32841
${actionOrigin_收银台_标准}     StandardCashier
${businessType_业务线_单车}     1
${channel_支付渠道_支付宝}        001
${channel_支付渠道_微信app支付}    002
${channel_支付渠道_余额}         003
${creditModel_授信模式_普通}     normal
${actionOrigin_标准收银台}      StandardCashier
${type_订单类型_正常的待支付订单}      1
${type_订单类型_零元订单}          2
${clientIP_支付发起时的IP地址}      172.16.218.180