*** Settings ***
Library           HelloBikeLibrary
Resource          ../配置数据/请求配置/测试工具相关.robot
Resource          ../配置数据/请求配置/测试环境相关.robot
Resource          ../配置数据/请求配置/地理位置相关.robot
Resource          ../配置数据/业务配置/车辆相关.robot

*** Keywords ***
获取普通运营中闲置的车辆
    [Arguments]    ${city}    ${whichBike}=0    ${bikesStartIndex}=1    ${bikes}=2    ${rndChoice}=${true}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no,bike_key from t_bike_info where bike_type = ${车辆类型_普通车} and bike_status= ${车辆状态_运营中} and bike_running_status = ${骑行状态_闲置} and city_code='${city}' and test_user_name='单车用户端自动化专用' order by update_date desc limit ${bikes}
    Should Not Be Empty    ${bikeNo}
    ${bikesEndIndex}    Evaluate    ${bikes}-1
    ${rnd}    Evaluate    random.randint(${bikesStartIndex},${bikesEndIndex})    random
    ${whichBike}    Run Keyword If    ${rndChoice}    Set Variable    ${rnd}    ELSE    Set Variable    ${whichBike}
    设置车辆网络ip    ${bikeNo}[${whichBike}][0]
    车辆设置失联车标签    ${bikeNo}[${whichBike}][0]    添加删除失联车标签=${删除失联车标签}
    # 连接车辆    ${bikeNo}[${whichBike}][0]      ${bikeNo}[${whichBike}][1]
    #车辆上报状态    ${bikeNo}[${whichBike}][0]
    车辆设置失联车标签    ${bikeNo}[${whichBike}][0]     ${删除失联车标签}
    Log    【获取普通运营中闲置的车辆】${bikeNo}[${whichBike}][0]执行成功
    [Return]    ${bikeNo}[${whichBike}][0]

普通可用车查询_连接
    [Arguments]    ${city}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeInfo}    查询    select bike_no,bike_key from t_bike_info where bike_type = ${车辆类型_普通车} and bike_status= ${车辆状态_运营中} and bike_running_status = ${骑行状态_闲置} and bike_chip_status=3 and city_code='${city}' and test_user_name='单车用户端自动化专用' order by update_date asc limit 5
    should not be Empty    ${bikeInfo}
    ${rnd}    Evaluate    random.randint(1,2)    random
    set suite variable    ${bikeNo}    ${bikeInfo}[${rnd}][0]
    set suite Variable    ${bikeKey}    ${bikeInfo}[${rnd}][1]
    ${connect_code}    连接车辆    ${bikeNo}    ${bikeKey}
    run keyword if     ${connect_code}==0    log    【连接模拟器成功】
    车辆设置失联车标签    ${bikeNo}     ${删除失联车标签}
    [Return]    ${connect_code}

获取普通运营中闲置的车辆-sh
    [Arguments]    ${city}=021
    ${connect_code}    普通可用车查询_连接    ${city}
    :FOR    ${i}    IN RANGE     4
    \    exit for loop if    ${connect_code}==0
    \    ${connect_code}    普通可用车查询_连接     ${city}
    \    log    第${i+2}次重试【普通可用车查询_连接】
    log    【获取普通运营中闲置的车辆-sh 成功】
    [Return]    ${bikeNo}

获取高校运营区中闲置的车辆
    [Arguments]    ${城市}    ${高校区}    ${whichBike}=0    ${bikesStartIndex}=1    ${bikes}=10    ${rndChoice}=${false}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_status = ${车辆状态_运营中} and bike_type = ${车辆类型_高校车} and bike_running_status = ${骑行状态_闲置} and city_code='${城市}' and service_area_name = '${高校区}' order by update_date DESC limit ${bikes}
    Should Not Be Empty    ${bikeNo}
    ${bikesEndIndex}    Evaluate    ${bikes}-1
    ${rnd}    Evaluate    random.randint(${bikesStartIndex},${bikesEndIndex})    random
    ${whichBike}    Run Keyword If    ${rndChoice}    Set Variable    ${rnd}    ELSE    Set Variable    ${whichBike}
    设置车辆网络ip    ${bikeNo}[${whichBike}][0]
    Log    【获取高校运营区中闲置的车辆】${bikeNo}[${whichBike}][0]执行成功
    车辆设置失联车标签    ${bikeNo}[${whichBike}][0]     ${删除失联车标签}
    [Return]    ${bikeNo}[${whichBike}][0]

获取运营中闲置的轮毂锁车辆
    [Arguments]    ${city}    ${whichBike}=0    ${bikesStartIndex}=1    ${bikes}=10    ${rndChoice}=${false}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_type = ${车辆类型_普通车} and bike_status= ${车辆状态_运营中} and bike_running_status = ${骑行状态_闲置} and city_code='${city}' and pro_code=32 order by update_date desc limit ${bikes}
    Should Not Be Empty    ${bikeNo}
    ${bikesEndIndex}    Evaluate    ${bikes}-1
    ${rnd}    Evaluate    random.randint(${bikesStartIndex},${bikesEndIndex})    random
    ${whichBike}    Run Keyword If    ${rndChoice}    Set Variable    ${rnd}    ELSE    Set Variable    ${whichBike}
    设置车辆网络ip    ${bikeNo}[${whichBike}][0]
    Log    【获取运营中闲置的轮毂锁车辆】${bikeNo}[${whichBike}][0]执行成功
    车辆设置失联车标签    ${bikeNo}[${whichBike}][0]     ${删除失联车标签}
    [Return]    ${bikeNo}[${whichBike}][0]

获取闲置的景区车辆
    [Arguments]    ${城市}    ${whichBike}=0
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_type = ${车辆类型_定向车} and bike_status = ${车辆状态_运营中} and bike_running_status = ${骑行状态_闲置} and city_code='${城市}' and bike_form in (2,3,4) order by update_date desc limit 3
    Should Not Be Empty    ${bikeNo}
    Log    【获取闲置的景区车辆】${bikeNo}[${whichBike}][0]执行成功
    车辆设置失联车标签    ${bikeNo}[${whichBike}][0]     ${删除失联车标签}
    [Return]    ${bikeNo}[${whichBike}][0]

获取非运营的普通车辆
    [Arguments]    ${城市}    ${whichBike}=0    ${bikesStartIndex}=1    ${bikes}=10    ${rndChoice}=${false}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_status in(-3,-2,-1,0,1,3,4,5) and bike_type = ${车辆类型_普通车} and city_code='${城市}' order by update_date desc limit ${bikes}
    Should Not Be Empty    ${bikeNo}
    ${bikesEndIndex}    Evaluate    ${bikes}-1
    ${rnd}    Evaluate    random.randint(${bikesStartIndex},${bikesEndIndex})    random
    ${whichBike}    Run Keyword If    ${rndChoice}    Set Variable    ${rnd}    ELSE    Set Variable    ${whichBike}
    Log    【获取非运营的普通车辆】${bikeNo}[${whichBike}][0]执行成功
    车辆设置失联车标签    ${bikeNo}[${whichBike}][0]     ${删除失联车标签}
    [Return]    ${bikeNo}[${whichBike}][0]

获取指定状态的普通车辆
    [Arguments]    ${城市}    ${bikeStatus}     ${whichBike}=0
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_status in(${bikeStatus}) and bike_type = ${车辆类型_普通车} and city_code='${城市}' order by update_date desc limit 3
    Should Not Be Empty    ${bikeNo}
    Log    【获取指定状态的普通车辆】${bikeNo}[${whichBike}][0]执行成功
    车辆设置失联车标签    ${bikeNo}[${whichBike}][0]     ${删除失联车标签}
    [Return]    ${bikeNo}[${whichBike}][0]

获取失联的普通车辆
    [Arguments]    ${城市}    ${whichBike}=0
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_status= ${车辆状态_运营中} and bike_type = ${车辆类型_普通车} and bike_running_status = ${骑行状态_闲置} and city_code='${城市}' order by create_date asc limit 3
    Should Not Be Empty    ${bikeNo}
    Log    【获取失联的普通车辆】${bikeNo}[${whichBike}][0]执行成功
    [Return]    ${bikeNo}[${whichBike}][0]

获取5代锁普通车辆
    [Arguments]    ${城市}    ${whichBike}=0
    #    5代锁支持蓝牙精简指令开锁
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_status= ${车辆状态_运营中} and bike_type = ${车辆类型_普通车} and bike_running_status = ${骑行状态_闲置} and pro_code=${锁版本_5代锁} and city_code='${城市}' order by update_date desc limit 3
    Should Not Be Empty    ${bikeNo}
    Log    ${bikeNo}
    车辆设置失联车标签    ${bikeNo}     ${删除失联车标签}
    [Return]    ${bikeNo}[${whichBike}][0]

设置车辆标签==TODO
    [Arguments]    ${车辆编号}    ${标签类型}    ${增删类型}    ${打标签时间}    ${环境}=${当前测试环境}
    ${data}    set variable    env=${环境}&alertType=${标签类型}&bikeNo=${车辆编号}&addordeleteType=${增删类型}&setalerttime=${打标签时间}
    log    【设置车辆标签报文体】${data}
    ${请求首部}    create dictionary    Content-Type=application/x-www-form-urlencoded
    ${content}    request client    url=${设置车辆标签接口地址}    data=${data}    headers=${请求首部}
    Should Be Equal As Numbers    ${content}[0]    200
    log    【设置车辆标签返回】${content}
    log    【设置车辆标签】执行成功
    [Return]    ${content}

获取红包车信息
    [Arguments]    ${车辆编号}
    # 执行redis指令
    ${Redis指令}    Set Variable    hgetall rpbikeinfo:${车辆编号}
    ${content}    redis command     bikeoss    1    ${Redis指令}
    Should Be Equal As Numbers    200   ${content}[0]         msg 设置redis返回错误，实际返回：${content}
    Log     【获取红包车${车辆编号}信息】执行成功${content}[1]

车辆设置红包车标签
    [Arguments]    ${车辆编号}      ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}
    设置车辆位置    ${车辆编号}    纬度=${纬度}    经度=${经度}
    # 执行redis指令
    ${Redis指令}    Set Variable    hset rpbikeinfo:${车辆编号} ${红包车属性_闲置} 1584845112000
    ${content}    redis command     bikeoss    0    ${Redis指令}
    Should Be Equal As Numbers    200   ${content}[0]         msg 设置redis返回错误，实际返回：${content}
    Should Be Equal As Numbers    0    ${content}[1][code]    msg 设置车辆设置标签redis失败，实际返回：${content}[1]
    # 执行定时任务
    # 执行定时任务重新计算红包车
    Log     【车辆设置红包车${车辆编号}标签】执行成功

车辆删除红包车标签
    [Arguments]    ${车辆编号}
    # 执行redis指令
    ${Redis指令}    Set Variable    hdel rpbikeinfo:${车辆编号} ${红包车属性_闲置}
    ${content}    redis command     bikeoss    1    ${Redis指令}
    Should Be Equal As Numbers    200   ${content}[0]         msg 设置redis返回错误，实际返回：${content}
    Should Be Equal As Numbers    0    ${content}[1][code]    msg 设置车辆设置标签redis失败，实际返回：${content}[1]
    # 执行定时任务
    执行定时任务重新计算红包车
    Log     【车辆设置红包车${车辆编号}标签】执行成功

执行定时任务重新计算红包车
    ${接口地址}     Set Variable    http://10.111.10.77:23333/job/runJob
    ${红包车定时任务首部}      Create Dictionary    token=9e57fd769157e013ac83df3a75a798ac      User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36
    ${time_struct}    Evaluate    time.mktime(datetime.datetime.now().timetuple())      modules=datetime,time
    ${utc_st}    Evaluate    datetime.datetime.utcfromtimestamp(${time_struct})      modules=datetime,time
    ${run_time}    Convert Date    ${utc_st}    result_format=%Y-%m-%dT%H:%M:%S.042Z
    ${红包车定时任务报文}      Create Dictionary    guid=b482590712d044c29953926d9db5e10e      runTime=${run_time}
    ${content}    request client    url=${接口地址}    data=${红包车定时任务报文}   headers=${红包车定时任务首部}
    Should Be Equal As Numbers    ${content}[0]    200
    Log     【执行定时任务重新计算红包车】执行成功

车辆设置失联车标签
    [Arguments]    ${车辆编号}    ${添加删除失联车标签}=${添加失联车标签}
    ${当前时间戳}   获取now毫秒级时间戳
    ${Redis指令}   Run Keyword If  '${添加删除失联车标签}' == '${添加失联车标签}'   Set Variable     hset ossbikeinfo:${车辆编号} ${失联车标签类型} ${当前时间戳}   ELSE    Set Variable     hdel ossbikeinfo:${车辆编号} ${失联车标签类型}
    # 执行redis指令
    ${content}    redis command without database    ossbikeinfo-cluster    ${Redis指令}
    Should Be Equal As Numbers    200    ${content}[0]    msg 设置redis返回错误，实际返回：${content}
    Should Be Equal As Numbers    0    ${content}[1][code]    msg 设置车辆设置失联车标签redis失败，实际返回：${content}[1]
    # 同步到缓存地址
    ${content}    request client    url=${失联车同步缓存}${车辆编号}    method=get
    Should Be Equal As Numbers    200    ${content}[0]    msg 调用同步到缓存接口返回错误，实际返回：${content}
    Log    【车辆设置失联车标签${添加删除失联车标签}】执行成功

获取普通运营中闲置的曼哈顿车
    [Arguments]    ${city}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no from t_bike_info where bike_status = 2 and bike_type = 0 and city_code='${city}' and pro_code=12 order by create_date DESC limit 10
    Should Not Be Empty    ${bikeNo}
    [Return]    ${bikeNo}[3][0]

车辆设置曼哈顿标签
    [Arguments]    ${bikeNo}    ${模式}=${曼哈顿模式}
    ${content}    redis command    bikestatus    1    set manhattanTag:${bikeNo} '${模式}'
    should be Equal as Numbers    ${content}[0]    200
    ${res_code}    get from dictionary    ${content}[1]    code
    ${res_msg}    get from dictionary    ${content}[1]    msg
    run keyword if    ${res_code}==0 and '${res_msg}'=='OK'    Log    【车辆设置曼哈顿标签】成功

获取车辆城市区号
    [Arguments]    ${车辆编号}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${单车信息}    查询    select city_code,city_name from t_bike_info where bike_no='${车辆编号}'
    Should Not Be Empty    ${单车信息}    msg 单车信息返回为空${单车信息}
    Should Not Be Empty    ${单车信息}[0][0]    msg 区号为空${单车信息}
    [Return]    ${单车信息}[0]

获取车辆信息
    [Arguments]    ${车辆编号}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${单车信息}    查询    select bike_no,bike_type,bike_status,bike_running_status,bike_key,test_user_name,bike_form,pro_code from t_bike_info where bike_no='${车辆编号}'
    Should Not Be Empty    ${单车信息}    msg 单车信息返回为空${单车信息}
    Log     【获取车辆信息】bike_no=${单车信息}[0][0],bike_type=${单车信息}[0][1],bike_status=${单车信息}[0][2],bike_running_status=${单车信息}[0][3],bike_key=${单车信息}[0][4],test_user_name=${单车信息}[0][5],bike_form=${单车信息}[0][6],pro_code=${单车信息}[0][7]执行成功
    Log     注：bike_type 车辆类型 车类型 （普通车＝0，定向车＝1）
    Log     注：bike_status 车辆状态 ( -3 弃用 -2 投放失败 －1 不合格 0 生产中 1 待投放 2 运营中 3 暂停 4 运输中 5 供应合格)
    Log     注：bike_running_status 骑行状态 （0 闲置，1 预约，2 骑行 3 冻结中）
    [Return]    ${单车信息}[0]

数据表中废弃某辆车
    [Arguments]    ${车辆编号}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${sql}    Set Variable    update t_bike_info set bike_status=${车辆状态_弃用} where bike_no='${车辆编号}';
    ${content}    更新    ${sql}
    Run Keyword If    ${content} == None    Log    @@更新车辆信息表@@成功

获取bikeKey
    [Arguments]    ${bikeNo}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bike_key}    查询    select bike_key from t_bike_info where bike_no ='${bikeNo}'
    Should Not Be Empty    ${bike_key}
    ${bikeKey}     Set Variable     ${bike_key}[0][0]
    Set Global Variable    ${bikeKey}
    Log    ${bike_key}
    [Return]    ${bikeKey}

连接车辆
    [Arguments]    ${bikeNo}    ${bikeKey}    ${replyOpenLockSuccess}=0    ${projectVersion}=0    ${softwareVersion}=0
    ${data}     set Variable    {"env":"fat","bikeType":"bike","bikeId":"${bikeNo}","encryptKey":"${bikeKey}","isHeartBeat":1,"isACK":1,"replyOpenLockSuccess":${replyOpenLockSuccess},"appVersion":11,"projectVersion":"${projectVersion}","softwareVersion":"${softwareVersion}","lockWorkMode":0,"lock":0}
    ${headers}    create dictionary    content-type=application/json;charset=UTF-8    token="8de9464b193e965dd307c76fcff99a1e"
    ${response}    request client    url=${模拟器后台服务地址}/connectAndRegister    data=${data}    headers=${headers}
    should be Equal as Numbers    ${response}[0]    200
    should be Equal as Numbers    ${response}[1][code]    0
    #should be Equal as strings    ${response}[1][msg]    连接成功
    [Return]    ${response}[1][code]

车辆断开连接
    [Arguments]    ${bikeNo}    ${bikeKey}
    ${data}     set Variable    {"env":"fat","bikeType":"bike","bikeId":"${bikeNo}","encryptKey":"${bikeKey}"}
    ${headers}    create dictionary    content-type=application/json;charset=UTF-8    token="8de9464b193e965dd307c76fcff99a1e"
    ${response}    request client    url=${模拟器后台服务地址}/close    data=${data}    headers=${headers}
    should be Equal as Numbers    ${response}[0]    200
    should be Equal as Numbers    ${response}[1][code]    0
    should be Equal as strings    ${response}[1][msg]    关闭连接成功

获取车辆位置
    [Arguments]    ${车辆编号}
    ${城市区号}    获取车辆城市区号    ${车辆编号}
    ${content}    redis command    geo    1    GEOPOS bikePosGeoSet:${城市区号}[0] ${车辆编号}
    Should Be Equal As Numbers    ${content}[0]    200    msg 设置redis返回错误，实际返回：${content}
    Should Be Equal As Numbers    0    ${content}[1][code]    msg 设置获取车辆位置redis失败，实际返回：${content}[1]
    Log    【获取车辆位置】成功${车辆编号}所属${城市区号}[1]${城市区号}[0]经度${content}[1][data][0][0]纬度${content}[1][data][0][1]

设置车辆位置
    [Arguments]    ${车辆编号}    ${纬度}=${纬度_上海市莘庄中心}    ${经度}=${经度_上海市莘庄中心}
    ${城市区号}    获取车辆城市区号    ${车辆编号}
    ${content}    redis command    geo    1    GEOADD bikePosGeoSet:${城市区号}[0] ${经度} ${纬度} ${车辆编号}
    Should Be Equal As Numbers    ${content}[0]    200    msg 设置redis返回错误，实际返回：${content}
    Should Be Equal As Numbers    0    ${content}[1][code]    msg 设置设置车辆位置redis失败，实际返回：${content}[1]
    Log    【设置车辆位置】GEOADD bikePosGeoSet:${城市区号}[0] ${经度} ${纬度} ${车辆编号}成功

清除车辆上一次关锁后的30s缓存
    [Arguments]    ${userGuid}=${用户全局标识}
    ${content}    redis command    bikeuser-cluster    0    del userBike:${userGuid}
    should be Equal as Numbers    ${content}[0]    200
    ${res_code}    get from dictionary    ${content}[1]    code
    ${res_msg}    get from dictionary    ${content}[1]    msg
    run keyword if    ${res_code}==0 and '${res_msg}'=='OK'    Log    【清除车辆上一次关锁后的30s缓存】成功

清除用户高校超区记录
    [Arguments]    ${userGuid}=${用户全局标识}
    ${content}    redis command without database    bikeorder-cluster        del universityOrderLocked:${userGuid}
    should be Equal as Numbers    ${content}[0]    200
    ${res_code}    get from dictionary    ${content}[1]    code
    ${res_msg}    get from dictionary    ${content}[1]    msg
    run keyword if    ${res_code}==0 and '${res_msg}'=='OK'    Log    【清除用户高校超区记录】成功

上报蓝牙信号
    [Arguments]    ${bikeNo}        ${manhattanReason}=${有蓝牙信号}
    ${endTime}    获取now毫秒级时间戳
    # AppEasybikeBikeService
    ${data}    set variable    {"addr":"${AppEasybikeBikeService}","iface":"com.easybike.bike.ifaces.BikeTcpDataHandleService","method":"blueParkingLocation","request":{"arg2":'"${manhattanReason}"',"arg1":"11","arg0":"${bikeNo}"}}
    ${repdata}    request client    data=${data}
    ${response}    get from dictionary    ${repdata}[1]    response
    should be equal    ${response}   AA==
    run keyword if    '${response}'=='AA=='    Log    【上报蓝牙信号】成功

获取曼哈顿车辆编号
    [Arguments]    ${city}=${区号_曼哈顿}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNos}    查询    select bike_no from t_bike_info where bike_status = 2 and bike_type = 0 and city_code='${city}' and test_user_name='单车用户端自动化专用' order by create_date DESC limit 10
    Should Not Be Empty    ${bikeNos}
    ${whichBike}    Evaluate    random.randint(0,9)     random
    ${bikeNo}     Set Variable      ${bikeNos}[${whichBike}][0]
    Set Global Variable    ${bikeNo}
    车辆设置曼哈顿标签    ${bikeNo}
    车辆设置失联车标签    ${bikeNo}    ${删除失联车标签}
    [Return]    ${bikeNo}

获取轮毂锁车辆编号
    [Arguments]    ${city}=${区号_曼哈顿}
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNos}    查询    select bike_no from t_bike_info where bike_status = 2 and bike_type = 0 and city_code='${city}' and pro_code=32 order by create_date DESC limit 5
    Should Not Be Empty    ${bikeNos}
    ${whichBike}    Evaluate    random.randint(0,4)     random
    ${bikeNo}     Set Variable      ${bikeNos}[${whichBike}][0]
    Set Global Variable    ${bikeNo}
    车辆设置失联车标签    ${bikeNo}     ${删除失联车标签}
    [Return]    ${bikeNo}

获取曼哈顿高校车辆编号
    [Arguments]    ${city}=${区号_曼哈顿}    ${service_area_name}=高校曼哈顿自动化测试
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNos}    查询    select bike_no from t_bike_info where bike_status=2 and bike_type=2 and service_area_name='${service_area_name}' and city_code='${city}' order by create_date DESC limit 5;
    Should Not Be Empty    ${bikeNos}
    ${whichBike}    Evaluate    random.randint(0,4)     random
    ${bikeNo}     Set Variable      ${bikeNos}[${whichBike}][0]
    车辆设置曼哈顿标签    ${bikeNo}
    车辆设置失联车标签    ${bikeNo}     ${删除失联车标签}
    [Return]    ${bikeNo}

上报曼哈顿我要还车车辆位置
    [Arguments]    ${bikeNo}    ${lng}=${经度_抚州_高校曼哈顿自动化测试_非P点}    ${lat}=${纬度_抚州_高校曼哈顿自动化测试_非P点}    ${inRegulatedArea}=1   ${posType}=0
    ${lockTime}    获取now毫秒级时间戳
    ${data}    set variable    {"addr":"${AppHellobikeRideProcessService}","iface":"com.easybike.rideprocess.ifaces.BikePositionIface","method":"uploadPosition","request":{"arg0":{\"advNames\":\"HBT00335\",\"lng\":${lng},\"bikeId\":\"${bikeNo}\",\"cmdChannel\":1,\"body\":\"AQAAGHEAAA+oXpbHygECSEJUMDAzMzVEAP///////////////////w==\",\"params\":{\"cellId\":4008,\"posType\":${posType},\"lac\":6257},\"inRegulatedArea\":${inRegulatedArea},\"posType\":${posType},\"lockTime\":${lockTime},\"bikeNo\":\"${bikeNo}\",\"posSource\":0,\"validRssiCount\":2,\"lat\":${lat},\"status\":0}}}
     ${repdata}    request client    data=${data}
    ${response}    rpc接口取返回节点    ${repdata}
    should be equal as numbers    ${response}[0]    0
    should be equal as strings    ${response}[1]    ok
    log    【上报曼哈顿我要还车车辆位置】${bikeNo} ${lng} ${lat} ${inRegulatedArea} ${posType}成功


