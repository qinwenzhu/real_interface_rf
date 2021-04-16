*** Settings ***
Library           HelloBikeLibrary
Resource          ../配置数据/请求配置/user相关.robot
Resource          ../配置数据/请求配置/服务相关.robot
Resource          ../配置数据/请求配置/测试工具相关.robot
Resource          ../配置数据/请求配置/测试环境相关.robot

*** Keywords ***
app登陆
    [Arguments]    ${mobilePhone}
    ${content}    login auth app    ${mobilePhone}
    Set Global Variable    ${用户}    ${mobilePhone}
    Set Global Variable    ${token}    ${content}[0]
    Set Global Variable    ${guid}    ${content}[1]
    log    【app登录】执行成功
    [Return]    ${token}

用户充值
    [Arguments]    ${用户手机}    ${余额}    ${测试环境}=${当前测试环境}
    ${data}    set Variable    {"env":"${测试环境}","mobilePhone":"${用户手机}","balance":"${余额}"}
    ${content}    request client    url=${用户充值接口地址}    data=${data}
    should be equal as numbers    200    ${content}[0]
    log    【用户充值】成功

客服中心注销用户
    [Arguments]    ${用户手机}
    ${用户手机}    Convert To String    ${用户手机}
    ${headers}    Create Dictionary    token=${bmsToken}    User-Agent=${bmsUserAgent}
    ${data}    Create Dictionary    mobilePhone=${用户手机}
    ${content}    request client    url=${客服中心注销用户}     data=${data}    headers=${headers}
    Should Be Equal As Integers   ${content}[0]    200
    # 如果用户存在期望返回：{"info":"操作成功！","status":1}
    # Should Be Equal    操作成功！    ${content}[1][info]
    # 如果用户不存在期望返回：{'info': '抱歉,网络开小差了,请稍后重试', 'status': 0}
    # Should Be Equal As Integers    0    ${content}[1][status]
    Log    【客服中心注销用户${用户手机}】成功    
    [Return]    ${content}

发放骑行优惠券
    [Arguments]    ${mobilePhone}    ${userNewId}    ${batCode}=0073-0101-202004174018    ${amount}=1
    ${data}    set Variable     {"addr":"${AppHelloMercuryApi}","iface":"com.hello.mercury.api.iface.UserPropertyService","method":"grantProperty","request":{"arg0":{"businessKey":"Hello0073","grantPropertyList":[{"batchCode":"${batCode}","amount":${amount},"outBizNo":"15"}],"userInfoList":[{"userNewId": ${userNewId},"mobile":"${mobilePhone}"}]}}}
    ${content}    request client    data=${data}
    Should Be Equal As Numbers    ${content}[0]    200
    Should Be Equal As strings    ${content}[1][response][msg]    操作成功！
    Should Be Equal As strings    ${content}[1][response][success]    True
    log     【发放骑行优惠券】成功

清除用户违规停车次数
    # del parkInForbiddenAreaTimesKey:6e3488fcc0c24db1bdbffefad93fc141
    [Arguments]    ${timesKey}
    ${content}    redis command without database    bikeuser-cluster        del ${timesKey}:${guid}
    should be Equal as Numbers    ${content}[0]    200
    ${res_code}    get from dictionary    ${content}[1]    code
    ${res_msg}    get from dictionary    ${content}[1]    msg
    run keyword if    ${res_code}==0 and '${res_msg}'=='OK'    Log    【清除用户违规停车次数】成功
