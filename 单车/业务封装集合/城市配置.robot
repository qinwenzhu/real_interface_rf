*** Keywords ***
城市配置_张家口市
    [Arguments]    ${data}
    ${url}    set variable    http://10.111.10.59:40001/cityManager/addOrUpdateCityRule
    ${headers}    create dictionary      User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36    token=f29c13a98f09ebf1f655394b208572d2    Content-Type=application/json
    ${content}    request client    url=${url}    headers=${headers}    data=${data}
    should be equal as numbers    ${content}[0]     200
    ${response}     get from dictionary     ${content}[1]    response
    ${data}     get from dictionary     ${response}    data
    ${status}     get from dictionary     ${response}    status
    should be equal as strings    ${data}    true
    should be equal as numbers    ${status}    1
    log    【城市配置通用】执行成功

admin后台高校配置
# $(areaPropertyCost}：调度费
# ${normParkingAreaRuleJsonb}:规范停车区域配置
    [Arguments]    ${guid}=3f9ab15cbcc14152b96ff5e2be2f9c1d     ${cityGuid}=EE60F2029F3D4EF69DC2238DA6A81D3F     ${cityName}=抚州市     ${cityCode}=0794    ${serviceAreaName}=校曼哈顿自动化测试   ${areaPropertyCost}=6       ${normParkingAreaRuleJsonb}={"showOnCustomer":"1","implementStyle":"2","interfereStyle":"1","stepExceedParkinSpotFee":[{"price":"1","times":"1"},{"price":"2","times":"2"}]}
    ${headers}    Create Dictionary    content-type=application/json    token=a7011e06eb0e0e943be36e73e8e0c833    User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36
    Create Session    alias=AccountJson     url=${admin后台高校配置地址}        headers=${headers}
    # ${stepExceedParkinSpotFee}    Evaluate    [{"price":"1","times":"1"},{"price":"2","times":"2"}]
    ${controlPersons}    Evaluate    [{"guid":"21b65d6113d84686b7248e87ac6e6157","name":"龚金龙(13155331159)"}]
    # ${controlPersonsJsonb}    Evaluate    [{"guid": "21b65d6113d84686b7248e87ac6e6157", "name": "龚金龙(13155331159)"}]
    ${params}    Create Dictionary     guid=${guid}    areaPropertyStatus=1       areaPropertyCost=${areaPropertyCost}       appletPlatformLimit=false    createUserGuid=6c1d07787dda4bbbbbabf9e5fd5f0755      createDate=2020-03-30 11:19:32      updateDate=2020-04-09 00:04:08      updateUserGuid=6c1d07787dda4bbbbbabf9e5fd5f0755    isDelete=0      serviceType=1      serviceAreaPolygon=POLYGON((116.404528 27.92623,116.400751 27.871918,116.466326 27.880567,116.437315 27.934572,116.404528 27.92623))     guid=${guid}      cityGuid=${cityGuid}     cityName=${cityName}       cityCode=${cityCode}      serviceAreaName=${serviceAreaName}       controlPersons=${controlPersons}      controlPersonsJsonb=[{"guid": "21b65d6113d84686b7248e87ac6e6157", "name": "龚金龙(13155331159)"}]    centerOfCoverageRange=POINT(116.428295001464 27.9004902878539)      bufferAreaPolygon=POLYGON((116.404518 27.926237,116.40074 27.871907,116.466342 27.88056,116.437321 27.934583,116.404518 27.926237))     normParkingAreaRuleJsonb=${normParkingAreaRuleJsonb}      distance=0      serviceArea=116.404528,27.92623;116.400751,27.871918;116.466326,27.880567;116.437315,27.934572      bufferArea=116.404518,27.926237;116.40074,27.871907;116.466342,27.88056;116.437321,27.934583        updateDateName=2020-04-09 00:04:08      createDateName=2020-03-30 11:19:32
    ${response}    Post Request    AccountJson      /citySubArea/addOrUpdateSubServiceArea    data=${params}    headers=${headers}
    log    ${response.json()}
    Should Be Equal      ${response.json()['info']}     操作成功！
    log    更新【admin后台高校配置】成功

admin后台配置
# 一、规范停车区配置，文件名对应配置枚举如下：
# 1、蓝牙道钉&调度费
# 2、电子围栏&调度费
# 3、蓝牙道钉+电子围栏&调度费
# 4、蓝牙道钉&调度费+车锁弹开
# 5、电子围栏&调度费+车锁弹开
# 6、蓝牙道钉+电子围栏&调度费+车锁弹开
#.6、超区退还调度费首次收费+电子围栏+车辆调度费
# 二、uri枚举
# 单车城市配置：/cityManager/addOrUpdateCityRule
# 禁停区配置：/bikeCityManager/addOrUpdateCityRule
    [Arguments]    ${FileName}=normParkingAreaSettings_2.json    ${url}=${admin后台城市配置地址}    ${uri}=/cityManager/addOrUpdateCityRule
    ${headers}    Create Dictionary    content-type=application/json    token=a7011e06eb0e0e943be36e73e8e0c833    User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36
    Create Session    alias=AccountJson     url=${url}        headers=${headers}
    ${params}    Get File    ${EXECDIR}${/}附件资源${/}${FileName}
    ${response}    Post Request    AccountJson    ${uri}    data=${params}    headers=${headers}
    log    ${response.json()}
    Should Be Equal      ${response.json()['info']}     操作成功！
    log    更新【admin后台配置】成功

admin后台高校配置_file
# 一、规范停车区配置，文件名对应配置枚举如下：
# 1、蓝牙道钉&调度费
# 2、电子围栏&调度费
# 3、蓝牙道钉+电子围栏&调度费
# 4、蓝牙道钉&调度费+车锁弹开
# 5、电子围栏&调度费+车锁弹开
# 6、蓝牙道钉+电子围栏&调度费+车锁弹开
    [Arguments]    ${FileName}=subServiceAreaSettings_2.json
    admin后台配置    FileName=${FileName}      url=${admin后台高校配置地址}      uri=/citySubArea/addOrUpdateSubServiceArea
    log    更新【admin后台高校配置_file】成功

admin后台禁停区配置
    [Arguments]    ${FileName}=forbidParkingAreaSettings.json
    admin后台配置    FileName=${FileName}      url=${admin后台禁停区配置地址}      uri=/bikeCityManager/addOrUpdateCityRule
    log    更新【admin后台禁停区配置】成功