*** Keywords ***
通用调用
    [Arguments]    ${调用接口}    ${报文体}    ${接口地址}=${fatBikeApi}
    Log    【${调用接口}地址】${接口地址}
    Log    【${调用接口}报文体】${报文体}
    ${content}    request client    url=${接口地址}    data=${报文体}
    Log    【${调用接口}返回】${content}
    # 状态码验证
    Should Be Equal As Numbers    ${content}[0]    200
    [Return]    ${content}

支付订单报文
    [Arguments]     ${订单全局标识}     ${支付总金额}   ${系统代码}    ${令牌}     ${版本}      ${收银台}    ${行政代码}    ${业务线}      ${支付渠道}    ${区号}    ${支付发起时的IP地址}    ${授信模式}   ${订单类型}
    ${单笔订单}    Create Dictionary    amount=${支付总金额}   businessType=${业务线}    guid=   orderId=${订单全局标识}     type=${订单类型}
    @{订单块}   Create List     ${单笔订单}
    ${订单块json数据}   Evaluate    json.dumps(@{订单块})    json
    ${data}     Create Dictionary   action=com.alphapay.paymentOrder.pay    systemCode=${系统代码}      token=${令牌}   version=${版本}     actionOrigin=${收银台}   adCode=${行政代码}     amount=${支付总金额}    businessType=${业务线}      channel=${支付渠道}     cityCode=${区号}    clientIP=${支付发起时的IP地址}      creditModel=${授信模式}     marketingActivityId=    orders=${订单块json数据}      clientId=
    Log     【支付订单报文】${data}
    [Return]    ${data}