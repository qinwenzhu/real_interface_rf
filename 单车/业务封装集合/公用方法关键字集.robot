*** Keywords ***
获取now毫秒级时间戳
    ${now}    get current date    result_format=timestamp
    ${now_stamp_temp}    Convert Date    ${now}    epoch
    ${now_stamp_second}    evaluate    int(round(${now_stamp_temp}))
    ${now_stamp}    evaluate    int(round(${now_stamp_temp} * 1000))
    [Return]    ${now_stamp}

当前日期加时间
    [Arguments]    ${待加时间}      #参数举例：7 days（7天后）      -3 minutes（3分钟前）  -1（1秒前）     01:02:03:004（1小时2分钟3秒4毫秒后）
    ${当前时间}    Get Current Date
    ${结果}     Add Time To Date    ${当前时间}    ${待加时间}
    Log     【当前日期加时间】执行成功
    [Return]    ${结果}     #返回举例：2020-03-30 13:49:09.641

日期加时间
    [Arguments]    ${基础时间}    ${待加时间}      #参数举例：7 days（7天后）      -3 minutes（3分钟前）  -1（1秒前）     01:02:03:004（1小时2分钟3秒4毫秒后）
    ${结果}     Add Time To Date    ${基础时间}     ${待加时间}
    Log     【日期加时间】执行成功
    [Return]    ${结果}     #返回举例：2020-03-30 13:49:09.641

时间戳相加
    [Arguments]    ${x}     ${y}
    ${相加结果}    Add Time To Time     ${x}     ${y}
    ${时间戳结果}     Evaluate    int(round(${相加结果}))
    Log     【时间戳相加】执行成功
    [Return]    ${时间戳结果}

获取userNewId
    ${data}    create dictionary    action=user.account.getInfo    riskControlData={"userAgent" : "Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148","deviceLon" : "121.363829","roam" : "460","systemCode" : "61","deviceLat" : "31.122807"}    token=${token}
    ${content}    request client    url=${fatApi}    data=${data}
    should be equal as numbers    ${content}[0]    200
    ${repdata}    get from dictionary    ${content}[1]    data
    ${usernewid}    get from dictionary    ${repdata}    userNewId
    set suite variable    ${usernewid}
    log    【获取userNewId】执行成功
    [Return]    ${usernewid}

获取用户信息
    #返回举例：{"code":0,"data":{"guid":"6be620cd84ba4f2aa62ac03a490eb509","nickName":"骑行侠1200117337","mobilePhone":"177****0328","headPortrait":"","cityCode":"021","realName":"郝亮","sex":0,"accountType":0,"sumCal":8952,"sumRideTime":1119,"sumCarbon":13188,"sumRideDistance":109020,"sumRideNumber":228,"certStatus":1,"sumCreditScore":0,"accountStatus":-1,"createDate":1578906569131,"studentCertStatus":-1,"vipStatus":0,"userNewId":1200117337,"userGuid":"6be620cd84ba4f2aa62ac03a490eb509","miniProCreditDisplay":true,"sexName":"男","enable":true,"accountStatusName":"初始化","createDateName":"2020-01-13 17:09:29","accountTypeName":"普通计费用户"}}
    ${data}    create dictionary    action=user.account.getInfo    riskControlData={"userAgent" : "Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148","deviceLon" : "121.363829","roam" : "460","systemCode" : "61","deviceLat" : "31.122807"}    token=${token}
    ${content}    request client    url=${fatApi}    data=${data}
    should be equal as numbers    ${content}[0]    200
    Dictionary Should Contain Key    ${content}[1]    data  msg 获取用户信息接口返回中应该有data字段
    set suite variable    ${用户新标识}  ${content}[1][data][userNewId]
    set suite variable    ${usernewid}  ${content}[1][data][userNewId]  #兼容：获取userNewId
    set suite variable    ${用户全局标识}  ${content}[1][data][userGuid]
    log    【获取用户信息】执行成功
    [Return]    ${content}[1][data]

连接数据库_bike_order_fat
    ${tableNo}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    [Return]    ${tableNo}
    log     【连接数据库_bike_order_fat】执行成功

北京时间转换为毫秒级时间戳
    [Arguments]    ${Time}
    ${time_temp}    Convert Date    ${Time}    epoch
    ${time_stamp}    evaluate    int(round(${time_temp} * 1000))
    [Return]    ${time_stamp}

rpc接口取返回节点
    [Arguments]    ${repdata}
    should be equal as numbers    ${repdata}[0]    200
    ${rep_data}    set variable    ${repData}[1]
    ${rep_response}    get from dictionary    ${rep_data}    response
    ${rep_code}    get from dictionary    ${rep_response}    code
    ${rep_msg}    get from dictionary    ${rep_response}    msg
    [Return]    ${rep_code}    ${rep_msg}




