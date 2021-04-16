*** Settings ***
Library           HelloBikeLibrary

*** Variable ***
${accessRedisUrl}    http://10.111.71.18:8181/redisQuery/execute
<<<<<<< HEAD
${accessRedisUserAgent}    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
${accessRedisToken}    52505dfc38704b4b0c78499516d984f8
${accessRedisUserAgent}    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 OPR/68.0.3618.173
${accessRedisToken}    eeb77bb60915263c245ec1be49b6987d
${accessRedisRefer}    http://fat-auth-ops.hellobike.cn/
=======
${accessRedisUserAgent}    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
${accessRedisToken}    81948d104d42a754cc2f0cc41d250529

>>>>>>> master

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
    ${content}    redis command without database-备份    ${redisName}    ${command}
    [Return]    ${content}

redis command without database-备份
    [Arguments]    ${redisName}    ${command}
    ${url}    set variable    ${accessRedisUrl}
    ${headers}    create dictionary    User-Agent=${accessRedisUserAgent}    token=${accessRedisToken}    Referer=${accessRedisRefer}
    ${data}    set variable    {"redisName":"${redisName}","command":"${command}"}
    ${content}    request client    url=${url}    data=${data}    headers=${headers}
    [Return]    ${content}

fox执行redis集群命令
    [Arguments]    ${redisName}    ${command}    ${env}=fat
    ${url}    Set Variable    http://fox.hellobike.cn:8088/gct/redis/test
    ${authorization}    Set Variable    bear eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Imhhb2xpYW5nMDk1NTRAaGVsbG9iaWtlLmNvbSIsIm5hbWUiOiLpg53kuq4iLCJpZCI6NDczMywiZXhwIjoxNTk0ODg5NzMxLCJpc3MiOiJkZWZhdWx0In0.kCUQGwKOp9qHEEWI0Zta7-XBAWKWtUQsSth5MS8pxW8
    ${userAgent}    Set Variable    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 OPR/68.0.3618.125
    ${referer}    Set Variable    http://fox.hellobike.cn/fox/testcase/16056
    ${headers}    Create Dictionary    authorization=${authorization}    User-Agent=${userAgent}    Referer=${referer}
    ${data}      Create Dictionary    env=${env}    name=${redisName}    command=${command}    handle=Command
    ${content}    request client    url=${url}    data=${data}    headers=${headers}
    [Return]    ${content}
