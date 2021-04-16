*** Settings ***
Library           Collections
Resource          ../业务封装集合/通用.robot


*** Keywords ***
客服中心获取骑行卡列表
    [Arguments]    ${用户全局标识}=${用户全局标识}    ${卡片类型}=${cardType_客服中心月卡}    ${开始时间}=None    ${结束时间}=None
    ${当前时间}    Get Current Date    result_format=timestamp     exclude_millis=exclude_millis 
    ${一天之后}    Add Time To Date    ${当前时间}    1 days    result_format=timestamp     exclude_millis=exclude_millis 
    ${结束时间}    Set Variable If     ${结束时间}!=None    ${结束时间}    ${一天之后}
    ${一周之前}    Add Time To Date    ${当前时间}    -7 days    result_format=timestamp     exclude_millis=exclude_millis 
    ${开始时间}    Set Variable If     ${开始时间}!=None    ${开始时间}    ${一周之前}
    ${url}    Set Variable    ${客服中心获取骑行卡列表}
    ${headers}    Create Dictionary    token=${bmsToken}    User-Agent=${bmsUserAgent} 
    ${data}    Create Dictionary    userGuid=${用户全局标识}   cardType=${卡片类型}    endTime=${结束时间}    startTime=${开始时间}
    ${content}    request client    url=${url}    headers=${headers}     data=${data}
    # 期望返回：(200, {'data': [{'addDays': 5, 'buttonStatus': 2, 'buttonStatusName': '注销月卡', 'cardGuid': '73fbaa7369dd47e6b0f54625d3b2ce7a', 'cardType': 0, 'cardTypeName': '注销月卡', 'createDate': 1587380998000, 'creat...
    Should Be Equal As Integers    200    ${content}[0]
    [Return]    ${content}

客服中心注销月卡
    [Arguments]    ${mobilePhone}    ${paymentSum}    ${rideCardPurchaseGuid}    ${rideCardChangeGuid}    ${orderId}    ${refundMoney}    ${remainDays}    ${expireDate}    ${cardGuid}    ${channelCode}     ${typeCode}    ${refundStyle}    ${purchaseDate}    ${userGuid}=${用户全局标识}     ${refundType}=1    ${rideCardType}=0    ${refundCause}=1
    ${url}    Set Variable    ${客服中心退骑行卡}
    ${headers}    Create Dictionary    token=${bmsToken}    User-Agent=${bmsUserAgent} 
    ${paymentSum}    Convert To String    ${paymentSum}
    ${refundType}    Convert To Integer    ${refundType}
    ${rideCardPurchaseGuid}    Convert To String    ${rideCardPurchaseGuid}
    ${orderId}    Convert To String    ${orderId}
    ${remainDays}    Convert To Integer    ${remainDays}
    ${rideCardType}    Convert To Integer    ${rideCardType}
    ${refundCause}     Convert To Integer   ${refundCause}
    ${data}    Create Dictionary     mobilePhone=${mobilePhone}    paymentSum=${paymentSum}    userGuid=${userGuid}    refundType=${refundType}    rideCardPurchaseGuid=${rideCardPurchaseGuid}    rideCardChangeGuid=${rideCardChangeGuid}    orderId=${orderId}    refundMoney=${refundMoney}    remainDays=${remainDays}    expireDate=${expireDate}    cardGuid=${cardGuid}     rideCardType=${rideCardType}    refundCause=${refundCause}    channelCode=${channelCode}     typeCode=${typeCode}   refundStyle=${refundStyle}    purchaseDate=${purchaseDate}
    Log    客服中心注销月卡:${data}
    # 期望返回: (200, {'data': True, 'info': '操作成功！', 'status': 1})
    ${content}    request client    url=${url}    headers=${headers}     data=${data}
    Should Be Equal As Integers    200    ${content}[0]
    [Return]    ${content}

客服中心注销活动月卡
    [Arguments]    ${mobilePhone}   ${rideCardChangeGuid}    ${orderId}    ${remainDays}    ${expireDate}    ${cardType}    ${channelCode}    ${typeCode}    ${refundStyle}    ${userGuid}=${用户全局标识}     ${refundType}=1    ${rideCardType}=0    ${refundCause}=1
    ${url}    Set Variable    ${客服中心退骑行卡}
    ${headers}    Create Dictionary    token=${bmsToken}    User-Agent=${bmsUserAgent} 
    ${refundType}    Convert To Integer    ${refundType}
    ${orderId}    Convert To String    ${orderId}
    ${remainDays}    Convert To Integer    ${remainDays}
    ${rideCardType}    Convert To Integer    ${rideCardType}
    ${refundCause}     Convert To Integer   ${refundCause}
    ${data}    Create Dictionary     mobilePhone=${mobilePhone}    userGuid=${userGuid}    refundType=${refundType}    rideCardChangeGuid=${rideCardChangeGuid}    orderId=${orderId}    remainDays=${remainDays}    expireDate=${expireDate}     rideCardType=${rideCardType}    refundCause=${refundCause}    cardType=${cardType}    channelCode=${channelCode}    typeCode=${typeCode}    refundStyle=${refundStyle}
    Log    客服中心注销活动月卡:${data}
    # 期望返回: (200, {'data': True, 'info': '操作成功！', 'status': 1})
    ${content}    request client    url=${url}    headers=${headers}     data=${data}
    Should Be Equal As Integers    200    ${content}[0]
    [Return]    ${content}

客服中心注销某用户所有月卡
    # 此关键字需要用户登录并获取用户信息
    ${content}    客服中心获取骑行卡列表    用户全局标识=${用户全局标识}   卡片类型=${cardType_客服中心月卡}     
    ${卡列表}   Set Variable    ${content}[1][data]
    ${获取的骑行卡数量}    Get Length    ${卡列表}
    FOR     ${i}  IN  @{卡列表}
            Run Keyword If    '${i}[buttonStatusName]'=='注销月卡' and '活动发卡' in '${i}[eventTypeName]'    客服中心注销活动月卡    mobilePhone=${用户}    userGuid=${用户全局标识}     rideCardChangeGuid=${i}[guid]    orderId=1    remainDays=${i}[remainDays]    expireDate=${i}[expireDateName]    cardType=${i}[cardType]    channelCode=${i}[channelCode]    typeCode=${i}[typeCode]    refundStyle=${i}[refundStyle]
            ...    ELSE IF    '${i}[buttonStatusName]'=='注销月卡'      客服中心注销月卡        mobilePhone=${用户}    paymentSum=${i}[defaultRefundMoney]    userGuid=${用户全局标识}     rideCardPurchaseGuid=${i}[rideCardPurchaseGuid]    rideCardChangeGuid=${i}[guid]    orderId=${i}[orderId]    refundMoney=${i}[defaultRefundMoney]    remainDays=${i}[remainDays]    expireDate=${i}[expireDateName]    cardGuid=${i}[cardGuid]        channelCode=${i}[channelCode]     typeCode=${i}[typeCode]   refundStyle=${i}[refundStyle]    purchaseDate=${i}[purchaseDate]
            # Run Keyword If    '${i}[buttonStatusName]'=='注销月卡'    客服中心注销月卡        mobilePhone=${用户}    paymentSum=${i}[defaultRefundMoney]    userGuid=${用户全局标识}     rideCardPurchaseGuid=${i}[rideCardPurchaseGuid]    rideCardChangeGuid=${i}[guid]    orderId=${i}[orderId]    refundMoney=${i}[defaultRefundMoney]    remainDays=${i}[remainDays]    expireDate=${i}[expireDateName]    cardGuid=${i}[cardGuid]        channelCode=${i}[channelCode]     typeCode=${i}[typeCode]   refundStyle=${i}[refundStyle]    purchaseDate=${i}[purchaseDate]
    END

客服中心注销次卡
    [Arguments]    ${mobilePhone}    ${paymentSum}    ${eventType}     ${rideCardPurchaseGuid}    ${rideCardChangeGuid}    ${orderId}    ${refundMoney}    ${expireDate}     ${cardGuid}    ${refundStyle}    ${purchaseDate}    ${userGuid}=${用户全局标识}    ${refundType}=1    ${rideCardType}=1   ${refundCause}=1
    ${url}    Set Variable    ${客服中心退骑行卡}
    ${headers}    Create Dictionary    token=${bmsToken}    User-Agent=${bmsUserAgent} 
    ${paymentSum}    Convert To String    ${paymentSum}
    ${refundType}    Convert To Integer    ${refundType}
    ${rideCardPurchaseGuid}    Convert To String    ${rideCardPurchaseGuid}
    ${orderId}    Convert To String    ${orderId}
    ${rideCardType}    Convert To Integer    ${rideCardType}
    ${refundCause}     Convert To Integer   ${refundCause}
    ${data}    Create Dictionary     mobilePhone=${mobilePhone}    paymentSum=${paymentSum}    eventType=${eventType}    userGuid=${userGuid}    refundType=${refundType}    rideCardPurchaseGuid=${rideCardPurchaseGuid}    rideCardChangeGuid=${rideCardChangeGuid}    orderId=${orderId}    refundMoney=${refundMoney}    expireDate=${expireDate}    cardGuid=${cardGuid}     rideCardType=${rideCardType}    refundCause=${refundCause}    refundStyle=${refundStyle}    purchaseDate=${purchaseDate}
    # 期望返回: (200, {'data': True, 'info': '操作成功！', 'status': 1})
    ${content}    request client    url=${url}    headers=${headers}     data=${data}
    Should Be Equal As Integers    200    ${content}[0]
    [Return]    ${content}

客服中心注销某用户所有次卡
    # 此关键字需要用户登录并获取用户信息
    ${content}    客服中心获取骑行卡列表   卡片类型=${cardType_客服中心次卡}     
    ${卡列表}   Set Variable    ${content}[1][data]
    ${获取的骑行卡数量}    Get Length    ${卡列表}
    FOR     ${i}  IN  @{卡列表}
            Run Keyword If    '${i}[buttonStatusName]'=='注销次卡'    客服中心注销次卡        mobilePhone=${用户}    paymentSum=${i}[defaultRefundMoney]    eventType=${i}[eventType]     userGuid=${用户全局标识}     rideCardPurchaseGuid=${i}[rideCardPurchaseGuid]    rideCardChangeGuid=${i}[guid]    orderId=${i}[orderId]    refundMoney=${i}[defaultRefundMoney]    expireDate=${i}[expireDateName]    cardGuid=${i}[cardGuid]    refundStyle=${i}[refundStyle]    purchaseDate=${i}[purchaseDate]
    END

客服中心注销某用户所有app专属卡
    # 此关键字需要用户登录并获取用户信息
    ${content}    客服中心获取骑行卡列表   卡片类型=${cardType_客服中心APP专属卡} 
    ${卡列表}   Set Variable    ${content}[1][data]
    ${获取的骑行卡数量}    Get Length    ${卡列表}
    FOR     ${i}  IN  @{卡列表}
            Run Keyword If    '${i}[buttonStatusName]'=='注销月卡'    客服中心注销月卡        mobilePhone=${用户}    paymentSum=${i}[defaultRefundMoney]     userGuid=${用户全局标识}     rideCardPurchaseGuid=${i}[rideCardPurchaseGuid]    rideCardChangeGuid=${i}[guid]    orderId=${i}[orderId]    refundMoney=${i}[defaultRefundMoney]    remainDays=${i}[remainDays]    expireDate=${i}[expireDateName]    cardGuid=${i}[cardGuid]    rideCardType=2        channelCode=${i}[channelCode]     typeCode=${i}[typeCode]   refundStyle=${i}[refundStyle]    purchaseDate=${i}[purchaseDate]
    END

客服中心注销某用户所有骑行卡
    # 此关键字需要用户登录并获取用户信息
    客服中心注销某用户所有月卡
    客服中心注销某用户所有次卡
    客服中心注销某用户所有app专属卡
    
获取购卡页单车骑行卡套餐-todo
    [Arguments]    ${systemCode}=${systemCode_安卓}     ${token}=${token}    ${platform}=${平台类型_APP}    ${version}=${接口的最新版本}    ${adCode}=${行政代码_闵行区}    ${cityCode}=${区号_上海}    ${packageStep}=
    #单车骑行卡套餐报文
    ${data}    Create Dictionary    action=user.bike.ridecard.package    clientId=    systemCode=${systemCode}    token=${token}    platform=${platform}    version=${version}    adCode=${adCode}    cityCode=${cityCode}    packageStep=${packageStep}
    ${content}    通用调用    调用接口=获取购卡页单车骑行卡套餐    报文体=${data}
    [Return]    ${content}

获取购卡页单车骑行卡套餐V2-todo
    [Arguments]    ${systemCode}=${systemCode_安卓}     ${token}=${token}    ${platform}=${平台类型_APP}    ${version}=${接口的最新版本}    ${adCode}=${行政代码_闵行区}    ${cityCode}=${区号_上海}    ${packageStep}=     ${filterAttributes}=    ${channelCodes}=
    #单车骑行卡套餐报文
    ${data}    Create Dictionary    action=user.bike.ridecard.package.v2    clientId=    systemCode=${systemCode}    token=${token}    platform=${platform}    version=${version}    adCode=${adCode}    cityCode=${cityCode}    packageStep=${packageStep}    filterAttributes=${filterAttributes}    channelCodes=${channelCodes}
    ${content}    通用调用    调用接口=获取购卡页单车骑行卡套餐V2    报文体=${data}
    [Return]    ${content}

获取用户全部优惠券列表-todo
    [Arguments]    ${systemCode}=${systemCode_安卓}     ${token}=${token}    ${version}=${接口的最新版本}    ${limit}=${10}    ${start}=${1}
    ${data}    Create Dictionary    action=user.coupon.all    token=${token}    version=${version}    limit=${limit}    start=${start}
    ${content}    通用调用    调用接口=获取用户全部优惠券列表    报文体=${data}    接口地址=${fatApi}
    [Return]    ${content}


单车新版本购卡预下单V2-todo
    [Arguments]   ${token}=${token}    ${cityCode}=${区号_上海}    ${adCode}=${行政代码_闵行区}    ${version}=${接口的最新版本}    ${systemCode}=${systemCode_安卓}    ${cardInfoGuid}=    ${channelScene}=    ${packageGuid}=    ${cardAmount}=     ${rideOrderAmount}=    ${rideOrderDiscountAmount}=    ${rideCardDiscountId}=
    ${data}    Create Dictionary    action=bike.trade.preOrderV2    token=${token}    version=${version}    limit=${limit}    start=${start}
    ${content}    通用调用    调用接口=单车新版本购卡预下单V2    报文体=${data}    接口地址=${fatBikeApi}
    [Return]    ${content}

支付购卡订单-todo
    [Arguments]
