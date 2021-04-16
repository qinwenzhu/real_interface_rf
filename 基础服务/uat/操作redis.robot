*** Settings ***
Library           HelloBikeLibrary

*** Variable ***
${accessRedisUrl}    http://10.111.30.70:8181/redisQuery/execute
${accessRedisUserAgent}    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
${accessRedisToken}    d9c8b0b968b8c60c6d43cce281ad79d5
${accessRedisRefer}    http://uat-auth-ops.hellobike.cn/

*** Keywords ***
redis command
    [Arguments]    ${redisName}    ${database}    ${command}
    ${url}    set variable    ${accessRedisUrl}
    ${headers}    create dictionary    User-Agent=${accessRedisUserAgent}    token=${accessRedisToken}    Referer=${accessRedisRefer}
    ${data}    set variable    {"database":${database},"redisName":"${redisName}","command":"${command}"}
    ${content}    request client    url=${url}    data=${data}    headers=${headers}
    [Return]    ${content}

redis command without database
    [Arguments]    ${redisName}    ${command}
    ${url}    set variable    ${accessRedisUrl}
    ${headers}    create dictionary    User-Agent=${accessRedisUserAgent}    token=${accessRedisToken}    Referer=${accessRedisRefer}
    ${data}    set variable    {“redisName”:”${redisName}”,”command”:”${command}”}
    ${content}    request client    url=${url}    data=${data}    headers=${headers}
    [Return]    ${content}
