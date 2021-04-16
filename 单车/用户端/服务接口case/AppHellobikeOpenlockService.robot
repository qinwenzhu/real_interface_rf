*** Settings ***
Force Tags        AppHellobikeOpenlockService
Resource          ../../../资源配置/一键导入配置.resource

*** Test Cases ***
user.ride.pre.ride_预开锁_正常通过流程
    app登陆    ${激活用户_东营}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}
    ${content}    预开锁_东营    ${车辆编号}
    # 期望返回：{"code":0,"msg":"PRE_OPEN_VERIFY_SUCCESS","data":{"notices":[],"result":true,"processSwitch":false,"missBike":false,"bikeType":0,"causeType":1100,"bikeLng":121.36490195989609,"cause":"验证成功","bikeLat":31.12299578601634}}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    should be empty    ${content}[1][data][notices]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_驾照分为0
    app登陆    ${激活用户_驾照分为0}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_RIDE_LICENSE_ZERO    ${content}[1][msg]
    Should Be Equal    驾照分零，不可用车    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_驾照分为2
    #此场景在预开锁之前被检测
    app登陆    ${激活用户_驾照分为2}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    # user.ride.pre.ride_预开锁_低版本使用驾照分==TODO
    #    app登陆    ${激活用户_驾照分为4}
    #    获取用户信息
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    #    ${content}    预开锁_东营    ${车辆编号}    客户端=${ios客户端}    版本=${不支持驾照分的接口版本}
    #    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    #    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_人车距离>1000
    app登陆    ${激活用户_人车距离>1000}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁    车辆编号=${车辆编号}    区号=${区号_东莞}    行政代码=${行政代码_虎门镇}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    人车距离> 1000m    ${content}[1][data][notices][0][warnTitle]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_高校车可以在高校区开锁
    app登陆    ${激活用户_东莞}
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    设置车辆位置    ${车辆编号}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    ${content}    预开锁_东莞    ${车辆编号}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    log    【预开锁_高校车可以在高校区开锁】成功
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_用户有高校车超区订单，高校车可以在高校区外预开锁
    app登陆    ${激活用户_用户有高校车超区订单区外开锁}
    用户充值    ${激活用户_用户有高校车超区订单区外开锁}    1000
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    #第一次骑行，区内开锁区外关锁
    生成东莞亮高校车超区订单    ${车辆编号}
    #第二次骑行，区外预开锁
    ${content}    预开锁_东莞    ${车辆编号}    纬度=${纬度_东莞虎门镇麒麟公园}    经度=${经度_东莞虎门镇麒麟公园}
    # 期望返回：{'code': 0, 'msg': 'PRE_OPEN_VERIFY_SUCCESS', 'data': {'notices': [], 'result': True, 'processSwitch': False, 'missBike': False, 'bikeType': 2, 'causeType': 1100, 'bikeLng': 113.71608942747116, 'cause': '验证成功', 'bikeLat': 22.814838853204684}}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keywords    Sleep    5s
    ...    AND    生成东莞亮高校车超区订单后从区外骑回区内    ${车辆编号}

user.ride.pre.ride_预开锁_高校车不能在高校区外开锁
    app登陆    ${激活用户_高校车不能在高校区外开锁}
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    BIKE_COLLEGE_NOT_IN_SRERVICE    ${content}[1][msg]
    Should Be Equal    该车只能在校园区内开锁    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_用户有高校车超区订单，高校车不可以在高校区内预开锁
    app登陆    ${激活用户_用户有高校车超区订单区内开锁}
    用户充值    ${激活用户_用户有高校车超区订单区内开锁}    1000
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    #第一次骑行，区内开锁区外关锁
    生成东莞亮高校车超区订单    ${车辆编号}
    #第二次骑行，区内预开锁
    ${content}    预开锁_东莞    ${车辆编号}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    # 期望返回：{'code': 0, 'msg': 'BIKE_COLLEGE_USER_LOCKECD', 'data': {'result': False, 'causeType': 1209, 'cause': '你有一笔超校园区订单，2小时内无法继续使用校园车'}}
    Should Be Equal    BIKE_COLLEGE_USER_LOCKECD    ${content}[1][msg]
    Should Be Equal    你有一笔超校园区订单，2小时内无法继续使用校园车    ${content}[1][data][cause]
    [Teardown]    Run Keywords    Sleep    5s
    ...    AND    生成东莞亮高校车超区订单后从区外骑回区内    ${车辆编号}

user.ride.pre.ride_预开锁_低版本扫码高校车
    app登陆    ${激活用户_低版本扫码高校车}
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    设置车辆位置    ${车辆编号}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    ${content}    预开锁_东莞    ${车辆编号}    客户端=${ios客户端}    版本=${不支持高校车的接口版本}    #最低支持的版本是5.10.0
    #期望返回：{'code': 0, 'msg': 'BIKE_COLLEGE_LOW_VERSON', 'data': {'result': False, 'causeType': 1207, 'cause': '请将APP版本更新至5.10.0\n 或前往支付宝"哈啰出行" 小程序用车'}}
    Should Be Equal    BIKE_COLLEGE_LOW_VERSON    ${content}[1][msg]
    Should Be Equal    请将APP版本更新至5.10.0\n\ 或前往支付宝"哈啰出行" 小程序用车    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_高校车信息为空_SKIP
    Log    需要接口注入异常

user.ride.pre.ride_预开锁_高校车的子运营区信息为空_SKIP
    Log    需要接口注入异常

user.ride.pre.ride_预开锁_多端登录
    #校验多端同时开锁 多端登陆场景，同时开锁控制：多端包括：app(android、ios)、小程序(alipay)可以开锁，wechat和h5不能开锁；
    #校验多端开锁，app和小程序有一端正在开锁过程中，另一端开锁时提示"开锁中，请稍候"
    #此场景需要时间差自动化难以获取，更多的是返回ACCOUNT_EXISTS_BIKE_ORDER
    #app登录后开始骑车
    app登陆    ${激活用户_多端登录}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    #等待开锁成功
    Sleep    3s
    ${结束时间戳}    获取now毫秒级时间戳
    #用小程序登录
    app登陆    ${激活用户_多端登录}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${content}    预开锁    ${车辆编号}    客户端=${支付宝小程序客户端}
    Should Be Equal    ACCOUNT_EXISTS_BIKE_ORDER    ${content}[1][msg]
    Should Be Equal    您当前有一笔进行中的单车订单    ${content}[1][data][cause]
    #结束订单
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_多端登录无效systemcode参数
    app登陆    ${激活用户_多端登录无效systemcode参数}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${报文}    预开锁报文    车辆编号=${车辆编号}    区号=${区号_上海}    行政代码=${行政代码_闵行区}    纬度=${纬度_上海市莘庄中心}    经度=${经度_上海市莘庄中心}    令牌=${token}    版本=${接口的最新版本}    模式=${开锁模式_普通模式}    客户端=${支付宝小程序客户端}    开锁方式=${开锁方式_扫码开锁}
    #设置无效systemcode参数
    Set To Dictionary    ${报文}    systemCode    000
    Log    ${报文}
    ${content}    通用调用    调用接口=单车预开锁调用    报文体=${报文}
    Should Be Equal    ACCOUNT_APP_MULTI_REQUEST    ${content}[1][msg]
    Should Be Equal    开锁中，请稍候    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_重复请求
    app登陆    ${激活用户_重复请求用}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_MULTI_REQ    ${content}[1][msg]
    Should Be Equal    重复请求    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_冻结用户
    app登陆    ${激活用户_冻结用户}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_FROZEN    ${content}[1][msg]
    Should Be Equal    账户被冻结    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_全能车黑名单用户
    app登陆    ${激活用户_全能车黑名单用户}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_ALL_ROUND    ${content}[1][msg]
    Should Be Equal    全能车账号    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_不存在的用户
    ${token}    Set Variable    908fd6392e9f476db786e296haoliang
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁    ${车辆编号}    区号=${区号_东营}    行政代码=${行政代码_东营区}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}    令牌=${token}
    Should Be Equal    登录信息已失效, 请重新登录    ${content}[1][msg]

user.ride.pre.ride_预开锁_无效车辆编码
    app登陆    ${激活用户_无效车辆编码}
    ${车辆编号}    Set Variable    999111199900
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    BIKE_QR_CODE_EXCEPTIONAL    ${content}[1][msg]
    Should Be Equal    这不是哈啰单车哦，换一辆试试    ${content}[1][data][cause]

user.ride.pre.ride_预开锁_用户有单车骑行中订单
    app登陆    ${激活用户_用户有单车骑行中订单}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #开始用户的订单
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    #预开锁别的车
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    ACCOUNT_EXISTS_BIKE_ORDER    ${content}[1][msg]
    Should Be Equal    您当前有一笔进行中的单车订单    ${content}[1][data][cause]
    #结束用户的订单
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_用户有待支付单车订单
    #    此场景在预开锁之前被检测
    app登陆    ${激活用户_用户有待支付单车订单}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}    1
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]

user.ride.pre.ride_预开锁_用户有助力车待支付订单
    #    此场景在预开锁之前被检测
    app登陆    ${激活用户_用户有助力车待支付订单}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}
    # 期望返回：{'code': 0, 'msg': 'PRE_OPEN_VERIFY_SUCCESS', 'data': {'notices': [], 'result': True, 'processSwitch': False, 'missBike': False, 'bikeType': 0, 'causeType': 1100, 'bikeLng': 0.0, 'cause': '验证成功', 'bikeLat': 0.0}}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]

user.ride.pre.ride_预开锁_开锁别人预约的车辆
    app登陆    ${激活用户_别人已预约车辆}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    取消预约车辆    ${车辆编号}
    预约车辆    ${车辆编号}
    app登陆    ${激活用户_开锁被预约的车辆}
    ${content}    预开锁    ${车辆编号}
    # 期望返回：{'code': 0, 'msg': 'BIKE_RESERVED', 'data': {'result': False, 'causeType': 1202, 'cause': '车辆被预约了，换一辆试试'}}
    Should Be Equal    BIKE_RESERVED    ${content}[1][msg]
    Should Be Equal    车辆被预约了，换一辆试试    ${content}[1][data][cause]
    [Teardown]    取消预约车辆    ${车辆编号}

user.ride.pre.ride_预开锁_开锁自己预约的车辆
    app登陆    ${激活用户_开锁自己预约的车辆}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    取消预约车辆    ${车辆编号}
    预约车辆    ${车辆编号}
    app登陆    ${激活用户_开锁自己预约的车辆}
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keywords    取消预约车辆    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_开锁非预约的车
    app登陆    ${激活用户_开锁非预约的车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    取消预约车辆    ${车辆编号}
    预约车辆    ${车辆编号}
    app登陆    ${激活用户_开锁非预约的车}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}
    # 期望返回：{'code': 0, 'msg': 'PRE_OPEN_VERIFY_SUCCESS', 'data': {'notices': [], 'result': True, 'processSwitch': False, 'missBike': False, 'bikeType': 0, 'causeType': 1100, 'bikeLng': 121.36993914842606, 'cause': '验证成功', 'bikeLat': 31.125418979444667}}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keywords    取消预约车辆    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_骑行中的车辆==bug
    #A用户开始骑车
    app登陆    ${激活用户_A用户开始骑行}
    获取用户信息
    用户骑行中或者待支付的最近一笔订单退费
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    #B用户预开锁A用户的车
    app登陆    ${激活用户_扫骑行中的车辆}
    ${content}    预开锁    ${车辆编号}
    # 期望返回:{"code":0,"msg":"BIKE_BOS_RIDING","data":{"result":false,"causeType":1204,"cause":"车辆被占用，重新换一辆试试"}}
    Should Be Equal    BIKE_BOS_RIDING    ${content}[1][msg]
    Should Be Equal    车辆被占用，重新换一辆试试    ${content}[1][data][cause]
    #结束A用户的订单
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_非运营中的车辆
    app登陆    ${激活用户_扫非运营中的车辆}
    获取用户信息
    ${车辆编号}    获取非运营的普通车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    BIKE_STATUS_INVALID    ${content}[1][msg]
    Should Be Equal    车辆故障，换一辆试试    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_车辆类型为空_SKIP
    [Documentation]    update t_bike_info set bike_type = NULL where bike_no='2100872071';其中bike_type有非空约束。
    log    需要接口注入异常

user.ride.pre.ride_预开锁_红包模式扫普通车辆
    app登陆    ${激活用户_红包模式扫普通车辆}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁    车辆编号=${车辆编号}    区号=${区号_东营}    行政代码=${行政代码_东营区}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}    模式=${开锁模式_红包模式}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    这不是一辆红包车    ${content}[1][data][notices][0][warnTitle]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_红包车模式扫红包车
    app登陆    ${激活用户_红包车模式扫红包车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    获取红包车信息    ${车辆编号}
    车辆设置红包车标签    ${车辆编号}
    获取红包车信息    ${车辆编号}
    ${content}    预开锁    ${车辆编号}    模式=${开锁模式_红包模式}
    获取红包车信息    ${车辆编号}
    # 期望返回：{'code': 0, 'msg': 'PRE_OPEN_VERIFY_SUCCESS', 'data': {'notices': [], 'result': True, 'processSwitch': False, 'missBike': False, 'bikeType': 4, 'causeType': 1100, 'bikeLng': 121.36476784944534, 'cause': '验证成功', 'bikeLat': 31.123081966535757}}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]    开锁的车辆：${车辆编号}
    Should Be Equal As Numbers    ${车辆类型_红包车}    ${content}[1][data][bikeType]    开锁的车辆：${车辆编号}
    Should Be Equal    验证成功    ${content}[1][data][cause]    开锁的车辆：${车辆编号}
    [Teardown]    Run Keywords    车辆删除红包车标签    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_普通车模式扫红包车
    app登陆    ${激活用户_普通车模式扫红包车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    车辆设置红包车标签    ${车辆编号}
    ${content}    预开锁    ${车辆编号}
    # 期望返回：{"code":0,"msg":"PRE_OPEN_VERIFY_SUCCESS","data":{"notices":[],"result":true,"processSwitch":false,"missBike":false,"bikeType":0,"causeType":1100,"bikeLng":121.36476784944534,"cause":"验证成功","bikeLat":31.123081966535757}}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]    开锁的车辆：${车辆编号}
    Should Be Equal As Numbers    ${车辆类型_普通车}    ${content}[1][data][bikeType]    开锁的车辆：${车辆编号}
    Should Be Equal    验证成功    ${content}[1][data][cause]    开锁的车辆：${车辆编号}
    [Teardown]    Run Keywords    车辆删除红包车标签    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_景区车
    app登陆    ${激活用户_景区车}
    获取用户信息
    ${车辆编号}    获取闲置的景区车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    BIKE_SCENIC_QR_CODE_EXCEPTIONAL    ${content}[1][msg]
    Should Be Equal    景区车：请使用微信或者支付宝扫码    ${content}[1][data][cause]
    # user.ride.pre.ride_预开锁_失联车
    #    app登陆    ${激活用户_失联车}
    #    ${车辆编号}    获取失联的普通车辆    ${区号_上海}
    #    ${content}    预开锁    2100871698
    #    Should Be Equal    BIKE_LOSE_CONNECT    ${content}[1][msg]
    #    Should Be Equal    该车仅支持蓝牙开锁    ${content}[1][data][cause]
    # user.ride.pre.ride_预开锁_不支持蓝牙精简指令开锁==阻塞TODO
    #    app登陆    ${激活用户_不支持蓝牙精简指令开锁}
    #    ${车辆编号}    获取5代锁普通车辆    ${区号_上海}    whichBike=0
    #    ${content}    预开锁    ${车辆编号}    客户端=${ios客户端}    版本=${不支持蓝牙精简指令开锁的接口版本}    #最低支持蓝牙精简指令开锁的接口版本是5.21.1
    #    Should Be Equal    BIKE_LOSE_CONNECT    ${content}[1][msg]
    #    Should Be Equal    该车仅支持蓝牙开锁    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_扫码曼哈顿车
    app登陆    ${激活用户_扫码曼哈顿车}
    获取用户信息
    用户骑行中或者待支付的最近一笔订单退费
    ${content}    预开锁    车辆编号=${车辆_上海曼哈顿}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_低版本扫码曼哈顿车
    app登陆    ${激活用户_低版本扫码曼哈顿车}
    ${content}    预开锁    车辆编号=${车辆_上海曼哈顿}    版本=${不支持曼哈顿的接口版本}    #此版本号取决于阿波罗配置manhattan.control.version
    Should Be Equal    BIKE_MANHATTAN_LOW_VERSION    ${content}[1][msg]
    Should Be Equal    您需要升级客户端到最新的版本才能使用该车辆    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_学生认证用户
    app登陆    ${激活用户_学生认证}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    should be empty    ${content}[1][data][notices]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_生产测试人员
    app登陆    ${激活用户_生产测试人员}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    # user.ride.pre.ride_预开锁_健康码红码_成都
    #    #此接口返回取决于政府的健康码接口
    #    #需要阿波罗healthy.code.verify.cities配置
    #    app登陆    ${激活用户_健康码红码_成都}
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #    ${content}    预开锁    ${车辆编号}    区号=${区号_成都}    行政代码=${行政代码_武侯区}    纬度=${纬度_成都武侯区人民政府}    经度=${经度_成都武侯区人民政府}
    #    Should Be Equal    据成都市防疫要求，您健康码为红码，暂无法用车    ${content}[1][msg]
    #    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_健康码黄码_成都
    #此接口返回取决于政府的健康码接口
    #需要阿波罗healthy.code.verify.cities配置
    app登陆    ${激活用户_健康码黄码_成都}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}    区号=${区号_成都}    行政代码=${行政代码_武侯区}    纬度=${纬度_成都武侯区人民政府}    经度=${经度_成都武侯区人民政府}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_健康码绿码_成都
    #此接口返回取决于政府的健康码接口
    #需要阿波罗healthy.code.verify.cities配置
    app登陆    ${激活用户_健康码绿码_成都}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}    区号=${区号_成都}    行政代码=${行政代码_武侯区}    纬度=${纬度_成都武侯区人民政府}    经度=${经度_成都武侯区人民政府}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    # user.ride.pre.ride_预开锁_健康码无码_成都
    #    #此接口返回取决于政府的健康码接口
    #    #需要阿波罗healthy.code.verify.cities配置
    #    app登陆    ${激活用户_健康码无码_成都}
    #    获取用户信息
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #    ${content}    预开锁    ${车辆编号}    区号=${区号_成都}    行政代码=${行政代码_武侯区}    纬度=${纬度_成都武侯区人民政府}    经度=${经度_成都武侯区人民政府}
    #    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    #    Should Be Equal    您尚未获取健康码，请及时在「微信-天府健康通小程序」申领    ${content}[1][data][notices][0][warnContent]
    #    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费
    # user.ride.pre.ride_预开锁_健康码红码_台州
    #    #此接口返回取决于政府的健康码接口,台州公安局提供的手机号
    #    #需要阿波罗healthy.code.verify.cities配置
    #    app登陆    ${激活用户_健康码红码_台州}
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #    ${content}    预开锁    ${车辆编号}    区号=${区号_台州}    行政代码=${行政代码_椒江区}    纬度=${纬度_台州市人民政府}    经度=${经度_台州市人民政府}
    #    Should Be Equal    据台州市防疫要求，您健康码为红码，暂无法用车    ${content}[1][msg]
    # user.ride.pre.ride_预开锁_健康码黄码_台州
    #    #此接口返回取决于政府的健康码接口,台州公安局提供的手机号
    #    #需要阿波罗healthy.code.verify.cities配置
    #    app登陆    ${激活用户_健康码黄码_台州}
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #    ${content}    预开锁    ${车辆编号}    区号=${区号_台州}    行政代码=${行政代码_椒江区}    纬度=${纬度_台州市人民政府}    经度=${经度_台州市人民政府}
    #    Should Be Equal    据台州市防疫要求，您健康码为黄码，暂无法用车    ${content}[1][msg]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_健康码绿码_台州
    #此接口返回取决于政府的健康码接口,台州公安局提供的手机号
    #需要阿波罗healthy.code.verify.cities配置
    app登陆    ${激活用户_健康码绿码_台州}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}    区号=${区号_台州}    行政代码=${行政代码_椒江区}    纬度=${纬度_台州市人民政府}    经度=${经度_台州市人民政府}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_健康码无码_台州
    #此接口返回取决于政府的健康码接口
    #需要阿波罗healthy.code.verify.cities配置
    app登陆    ${激活用户_健康码无码_台州}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}    区号=${区号_台州}    行政代码=${行政代码_椒江区}    纬度=${纬度_台州市人民政府}    经度=${经度_台州市人民政府}
    Should Be Equal    据台州市防疫要求，您暂未领取健康码，请在支付宝内申领后用车    ${content}[1][msg]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_安卓小程序
    app登陆    ${激活用户_安卓小程序}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}
    ${content}    预开锁_东营    ${车辆编号}    客户端=${支付宝小程序客户端}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    should be empty    ${content}[1][data][notices]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_小于12岁
    app登陆    ${激活用户_小于12岁}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    UNDER_AGE_12_NO_RIDE    ${content}[1][msg]
    Should Be Equal    您未满12周岁，无法用车    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_小于12岁验证时没有获取到身份证
    app登陆    ${激活用户_没有获取到身份证}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    REQUEST_FAILED    ${content}[1][msg]
    Should Be Equal    请求异常，请重新操作    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_输入编码预开锁打开
    #此用例使用阿波罗write.bikeNo.off配置为false
    app登陆    ${激活用户}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}    开锁方式=${开锁方式_编号开锁}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    # user.ride.pre.ride_预开锁_输入编码预开锁关闭
    #    #此用例使用阿波罗write.bikeNo.off配置为ture
    #    app登陆    ${激活用户}
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #    ${content}    预开锁    ${车辆编号}    开锁方式=${开锁方式_编号开锁}
    #    Should Be Equal    ACCOUNT_MANUAL_INPUT    ${content}[1][msg]
    #    Should Be Equal    请尝试扫单车二维码    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_注册用户
    app登陆    ${注册用户}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_DEPOSIT_STATUS_EXCEPTIONAL    ${content}[1][msg]
    Should Be Equal    免押状态异常    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_注册用户有免押卡
    app登陆    ${注册用户_有卡}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_NO_CERTIFICATION    ${content}[1][msg]
    Should Be Equal    账号未实名认证    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_注册用户有免押卡且已实名后
    app登陆    ${注册用户_有卡已实名}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    should be empty    ${content}[1][data][notices]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_实名认证审核中
    app登陆    ${激活用户_实名认证审核中}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_CERTIFICATION_AUDITING    ${content}[1][msg]
    Should Be Equal    实名认证审核中    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_实名认证失败
    #实名认证失败之后，不会记录。所以用户还是为认证之前的状态。代码不可达return Protos.createPreOpenLockResponse(EnumPreOpenLockResult.ACCOUNT_CERTIFICATION_FAILED);
    app登陆    ${激活用户_实名认证失败}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    ${content}    预开锁_东营    ${车辆编号}
    Should Be Equal    ACCOUNT_NO_CERTIFICATION    ${content}[1][msg]
    Should Be Equal    账号未实名认证    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_轮毂锁
    app登陆    ${激活用户_轮毂锁}
    获取用户信息
    ${车辆编号}    获取运营中闲置的轮毂锁车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}
    Should Be Equal    PRE_OPEN_VERIFY_SUCCESS    ${content}[1][msg]
    Should Be Equal    验证成功    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.pre.ride_预开锁_低版本扫轮毂锁==bug
    #受阿波罗控制hub.process.control.version，需要大于这个值的版本支持，如果获取不到这个阿波罗值代码中写死<=5.35.0的都不支持
    app登陆    ${激活用户_低版本扫轮毂锁}
    获取用户信息
    ${车辆编号}    获取运营中闲置的轮毂锁车辆    ${区号_上海}
    ${content}    预开锁    ${车辆编号}    版本=${不支持轮毂锁的接口版本}
    Should Be Equal    BIKE_HUB_VERSION_CONTROL    ${content}[1][msg]
    Should Be Equal    扫码单车需要更高版本的APP才可以继续用车    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_正常通过流程_普通车
    app登陆    ${激活用户_正常通过流程_普通车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_开锁骑行支付全流程
    app登陆    ${激活用户_开锁骑行支付全流程}
    用户充值    ${激活用户_开锁骑行支付全流程}    0
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${订单信息}    获取当前订单的信息    ${订单全局标识}
    ${开始时间}    Evaluate    '${订单信息}[0][6]'    modules=datetime
    ${更新开始时间}    日期加时间    ${开始时间}    -3 hours
    更新订单开始时间    ${订单全局标识}    ${更新开始时间}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    ${行程详情}    行程详情    ${订单全局标识}
    ${支付总金额}    Set Variable    ${行程详情}[1][data][detail][payCost]
    用户充值    ${激活用户_开锁骑行支付全流程}    1000
    支付订单    ${订单全局标识}    ${支付总金额}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_输入普通车编码
    app登陆    ${激活用户_输入普通车编码}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    开锁方式=${开锁方式_编号开锁}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_曼哈顿车
    app登陆    ${激活用户_扫码曼哈顿车}
    获取用户信息
    用户骑行中或者待支付的最近一笔订单退费
    修正骑行中的车辆状态    ${车辆_上海曼哈顿}
    ${bikeKey}    获取bikeKey    ${车辆_上海曼哈顿}
    连接车辆    ${车辆_上海曼哈顿}    bikeKey=${bikeKey}
    ${content}    单车确认开锁    车辆编号=${车辆_上海曼哈顿}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆_上海曼哈顿}    ${订单全局标识}    ${结束时间戳}
    # user.ride.create_正常开锁_红包模式扫普通车辆==todo
    #    app登陆    ${激活用户_红包模式扫普通车辆}
    #    获取用户信息
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #    ${content}    单车确认开锁    ${车辆编号}    模式=${开锁模式_红包模式}
    #    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    #    ${当前时间戳}    获取now毫秒级时间戳
    #    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    #    ${结束时间戳}    获取now毫秒级时间戳
    #    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}    关锁位置类型=${开关锁位置类型_单基站}
    #    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_红包车模式扫红包车
    app登陆    ${激活用户_红包车模式扫红包车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    车辆设置红包车标签    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    模式=${开锁模式_红包模式}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}    关锁位置类型=${开关锁位置类型_单基站}
    [Teardown]    Run Keywords    车辆删除红包车标签    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_普通车模式扫红包车
    app登陆    ${激活用户_普通车模式扫红包车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    车辆设置红包车标签    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keywords    车辆删除红包车标签    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_有卡用户开普通车
    app登陆    ${激活用户_有卡}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_注册用户有卡开普通车
    app登陆    ${注册用户_有卡已实名}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁__学生认证用户开普通车
    app登陆    ${激活用户_学生认证}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_开锁自己预约的车辆
    app登陆    ${激活用户_开锁自己预约的车辆}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    取消预约车辆    ${车辆编号}
    预约车辆    ${车辆编号}
    ${bikeKey}    获取bikeKey    ${车辆编号}
    连接车辆    ${车辆编号}    bikeKey=${bikeKey}
    设置车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keywords    取消预约车辆    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_开锁非预约的车
    app登陆    ${激活用户_开锁非预约的车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    取消预约车辆    ${车辆编号}
    预约车辆    ${车辆编号}
    app登陆    ${激活用户_开锁非预约的车}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keywords    取消预约车辆    ${车辆编号}
    ...    AND    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_驾照分为0的用户不验证驾照分
    app登陆    ${激活用户_驾照分为0}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    验证驾照分=${验证驾照分_不验证}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_5s内重复请求
    app登陆    ${激活用户_重复请求用}
    获取用户信息
    用户骑行中或者待支付的最近一笔订单退费
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    开锁方式=${开锁方式_编号开锁}
    ${二次调用返回}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：(200, {'code': 0, 'msg': 'ok'})
    Should Be Equal    ok    ${二次调用返回}[1][msg]
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_轮毂锁
    app登陆    ${激活用户_轮毂锁}
    获取用户信息
    ${车辆编号}    获取运营中闲置的轮毂锁车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_高校车可以在高校区开锁
    app登陆    ${激活用户_东莞}
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    ${content}    单车确认开锁    ${车辆编号}    行政代码=${行政代码_虎门镇}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_正常开锁_用户有高校车超区订单，高校车可以在高校区外开锁
    app登陆    ${激活用户_用户有高校车超区订单区外开锁}
    用户充值    ${激活用户_用户有高校车超区订单区外开锁}    1000
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    #第一次骑行，区内开锁区外关锁
    生成东莞亮高校车超区订单    ${车辆编号}
    #第二次骑行，区外开锁区内关锁
    生成东莞亮高校车超区订单后从区外骑回区内    ${车辆编号}

user.ride.create_确认开锁_高校车不能在高校区外开锁
    app登陆    ${激活用户_东莞}
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 201, 'msg': '该车只能在校园区内开锁'}
    Should Be Equal    该车只能在校园区内开锁    ${content}[1][msg]

user.ride.create_确认开锁_用户有高校车超区订单，高校车不能在区内开锁
    app登陆    ${激活用户_用户有高校车超区订单区内开锁}
    用户充值    ${激活用户_用户有高校车超区订单区内开锁}    1000
    获取用户信息
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    #第一次骑行，区内开锁区外关锁
    生成东莞亮高校车超区订单    ${车辆编号}
    #第二次骑行，区内开锁
    ${content}    单车确认开锁    ${车辆编号}    行政代码=${行政代码_虎门镇}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}    返回验证=${false}
    #期望返回：{'code': 202, 'msg': '你有一笔超校园区订单，2小时内无法继续使用校园车'}
    Should Be Equal    你有一笔超校园区订单，2小时内无法继续使用校园车    ${content}[1][msg]
    [Teardown]    Run Keywords    Sleep    5s
    ...    AND    生成东莞亮高校车超区订单后从区外骑回区内    ${车辆编号}

user.ride.create_确认开锁_红包模式开普通车
    app登陆    ${激活用户_红包模式开普通车}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    模式=${开锁模式_红包模式}    返回验证=${false}
    #期望返回：(200, {'code': 210, 'msg': '不享受红包车福利，确认要继续开锁吗？'})
    Should Be Equal    不享受红包车福利，确认要继续开锁吗？    ${content}[1][msg]

user.ride.create_确认开锁_多端登录==TODO
    log    x

user.ride.create_确认开锁_多端登录无效systemcode参数==TODO
    log    x

user.ride.create_确认开锁_用户是退款中状态==SKIP
    Log    产生此用户状态需要注入异常

user.ride.create_确认开锁_景区车
    app登陆    ${激活用户_景区车}
    ${车辆编号}    获取闲置的景区车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 802, 'msg': '请使用微信或支付宝扫码'}
    Should Be Equal    请使用微信或支付宝扫码    ${content}[1][msg]

user.ride.create_确认开锁_暂停状态的车
    app登陆    ${激活用户_上海}
    ${车辆编号}    获取指定状态的普通车辆    ${区号_上海}    ${车辆状态_暂停}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 115, 'msg': '车辆故障, 请换一辆试试'}
    Should Be Equal    车辆故障, 请换一辆试试    ${content}[1][msg]

user.ride.create_确认开锁_运输中状态的车
    app登陆    ${激活用户_上海}
    ${车辆编号}    获取指定状态的普通车辆    ${区号_上海}    ${车辆状态_运输中}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 115, 'msg': '车辆故障, 请换一辆试试'}
    Should Be Equal    车辆故障, 请换一辆试试    ${content}[1][msg]

user.ride.create_确认开锁_远程开锁风控非中国经纬度==bug
    app登陆    ${激活用户_远程开锁风控非中国经纬度}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}    纬度=${纬度_上海市莘庄中心}    经度=${经度_上海市莘庄中心}
    获取车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    纬度=${纬度_大阪市大阪城}    经度=${经度_大阪市大阪城}    返回验证=${false}
    #期望返回：{'code': 0, 'msg': 'BIKE_REMOTE_OPEN_DISTANCE', 'data': {'result': False, 'causeType': 1219, 'cause': '请确保人在单车旁再开锁'}}
    #此处代码中有一行判断并记录日志boolean isValidPos = Utils.isInMainlandChina(lat, lng);
    Should Be Equal    BIKE_REMOTE_OPEN_DISTANCE    ${content}[1][msg]
    Should Be Equal    请确保人在单车旁再开锁    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_确认开锁_远程开锁风控==bug
    app登陆    ${激活用户_远程开锁风控}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}
    获取车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    纬度=${纬度_上海市莘庄中心}    经度=${经度_上海市莘庄中心}
    #期望返回：{'code': 0, 'msg': 'BIKE_REMOTE_OPEN_DISTANCE', 'data': {'result': False, 'causeType': 1219, 'cause': '请确保人在单车旁再开锁'}}
    Should Be Equal    BIKE_REMOTE_OPEN_DISTANCE    ${content}[1][msg]
    Should Be Equal    请确保人在单车旁再开锁    ${content}[1][data][cause]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_确认开锁_无效开锁方式
    app登陆    ${激活用户_无效开锁方式}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    开锁方式=${开锁方式_无效开锁方式}
    #期望返回： {'code': 115, 'msg': '车辆故障, 请换一辆试试'}
    Should Be Equal    车辆故障, 请换一辆试试    ${content}[1][msg]

user.ride.create_确认开锁_输入编码超距开锁
    app登陆    ${激活用户_输入编码超距开锁}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    开锁方式=${开锁方式_编号开锁}
    #期望返回：{'code': 0, 'data': {'cause': '单车有点故障, 换一辆试试看', 'causeType': 206, 'result': False, 'missBike': False}}
    Should Be Equal    单车有点故障, 换一辆试试看    ${content}[1][data][cause]

user.ride.create_确认开锁_超距非强制开锁
    app登陆    ${激活用户_输入编码超距开锁}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    超200M是否强制开锁=${超200M是否强制开锁_不强制}
    #期望返回：{'code': 0, 'data': {'cause': '你确认在单车旁边?', 'causeType': 204, 'result': False, 'additionalCause': '如果不在请勿开锁, 否则将承担丢车赔偿', 'missBike': False}}
    Should Be Equal    你确认在单车旁边?    ${content}[1][data][cause]

user.ride.create_确认开锁_冻结用户
    app登陆    ${激活用户_冻结用户}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}
    #期望返回：{'code': 0, 'data': {'cause': '账户已冻结', 'causeType': 303, 'result': False, 'missBike': False}}
    Should Be Equal    账户已冻结    ${content}[1][data][cause]

user.ride.create_确认开锁_小于12岁
    app登陆    ${激活用户_小于12岁}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 1014, 'msg': '您未满12周岁，无法用车'}
    Should Be Equal    您未满12周岁，无法用车    ${content}[1][msg]

user.ride.create_确认开锁_小于12岁验证时没有获取到身份证
    app登陆    ${激活用户_没有获取到身份证}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 1015, 'msg': '请求异常，请重新操作'}
    Should Be Equal    请求异常，请重新操作    ${content}[1][msg]

user.ride.create_确认开锁_实名认证审核中
    app登陆    ${激活用户_实名认证审核中}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_东营}
    设置车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 0, 'data': {'cause': '未实名认证', 'causeType': 305, 'result': False, 'missBike': False}}
    Should Be Equal    未实名认证    ${content}[1][data][cause]

user.ride.create_确认开锁_低版本扫码高校车
    app登陆    ${激活用户_低版本扫码高校车}
    ${车辆编号}    获取高校运营区中闲置的车辆    ${区号_东莞}    亮高校区
    设置车辆位置    ${车辆编号}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    版本=${不支持高校车的接口版本}    客户端=${ios客户端}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    #期望返回：{'code': 104, 'msg': '请将APP版本更新至5.10.0    \n 或前往支付宝“哈啰出行”小程序用车'}
    Should Be Equal    请将APP版本更新至5.10.0\ \ \n\ 或前往支付宝“哈啰出行”小程序用车    ${content}[1][msg]

user.ride.create_确认开锁_驾照分4的用户
    app登陆    ${激活用户_驾照分为4}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    客户端=${ios客户端}
    #期望返回：{'code': 0, 'data': {'notice': {'warnType': 221, 'subWarnType': 301, 'warnTitle': '驾照分低分附加费5元', 'warnContent': '当前驾照分4分，可至我的-骑行驾照查看详细规则'}}}
    Should Be Equal    驾照分低分附加费5元    ${content}[1][data][notice][warnTitle]

user.ride.create_确认开锁_低驾照分的用户
    [Template]    确认开锁_低驾照分
    #期望返回：{'code': 0, 'data': {'notice': {'warnType': 221, 'subWarnType': 302, 'warnTitle': '驾照分为0，无法骑行单车', 'warnContent': '可到我的-骑行驾照查看明细'}}}
    ${激活用户_驾照分为0}    驾照分为0，无法骑行单车
    #期望返回：{'code': 0, 'data': {'notice': {'warnType': 221, 'subWarnType': 301, 'warnTitle': '驾照分低分附加费20元', 'warnContent': '当前驾照分2分，可至我的-骑行驾照查看详细规则'}}}
    ${激活用户_驾照分为2}    驾照分低分附加费20元
    #期望返回：{'code': 0, 'data': {'notice': {'warnType': 221, 'subWarnType': 301, 'warnTitle': '驾照分低分附加费2元', 'warnContent': '当前驾照分6分，可至我的-骑行驾照查看详细规则'}}}
    ${激活用户_驾照分为6}    驾照分低分附加费2元
    # user.ride.create_确认开锁_低版本使用驾照分
    #    app登陆    ${激活用户_驾照分为4}
    #    获取用户信息
    #    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    #    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    客户端=${ios客户端}
    #    Should Be Equal    xxx    ${content}[1]

user.ride.create_确认开锁_未充押金的用户
    app登陆    ${注册用户_已实名}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    客户端=${ios客户端}
    #期望返回：{'code': 0, 'data': {'cause': '未充押金', 'causeType': 301, 'result': False, 'missBike': False}}
    Should Be Equal    未充押金    ${content}[1][data][cause]

user.ride.create_确认开锁_无效的车辆二维码
    app登陆    ${激活用户_无效车辆编码}
    获取用户信息
    ${车辆编号}    Set Variable    999111199900
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：(200, {'code': 205, 'msg': '这不是哈啰单车哦, 换一辆试试'})
    Should Be Equal    这不是哈啰单车哦, 换一辆试试    ${content}[1][msg]

user.ride.create_确认开锁_失联车
    #开锁失联车仅能创建阈值订单--需再次确认
    app登陆    ${激活用户_失联车}
    获取用户信息
    ${车辆编号}    获取失联的普通车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    Dictionary Should Contain Key    ${content}[1]    data    msg 【单车确认开锁】接口返回应该有key：data,实际返回：${content}[1]
    ${orderInfo}    获取当前订单的信息    ${content}[1][data][rideId]
    Should Be Equal As Numbers    -1    ${orderInfo}[0][0]
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_确认开锁_用户有单车骑行中订单
    app登陆    ${激活用户_用户有单车骑行中订单}
    获取用户信息
    用户骑行中或者待支付的最近一笔订单退费
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${bikeKey}    获取bikeKey    ${车辆编号}
    连接车辆    ${车辆编号}    bikeKey=${bikeKey}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    #第二次开锁
    ${第二辆车编号}    获取普通运营中闲置的车辆    ${区号_上海}    whichBike=1
    ${二次接口返回}    单车确认开锁    ${第二辆车编号}    返回验证=${false}
    #期望返回：(200, {'code': 30012, 'msg': '你已有骑行中订单,不可扫码哦'})
    Should Be Equal    你已有骑行中订单,不可扫码哦    ${二次接口返回}[1][msg]
    ${结束时间戳}    获取now毫秒级时间戳
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_确认开锁_用户有待支付单车订单
    app登陆    ${激活用户_用户有待支付单车订单}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 0, 'data': {'cause': '你有一笔未支付的订单，请支付后再用车', 'causeType': 309, 'result': False, 'missBike': False}}
    Should Be Equal    你有一笔未支付的订单，请支付后再用车    ${content}[1][data][cause]

user.ride.create_确认开锁_用户有助力车待支付订单
    app登陆    ${激活用户_用户有助力车待支付订单}
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回： {'code': 0, 'data': {'cause': '你有一笔未支付的订单，请支付后再用车', 'causeType': 309, 'result': False, 'missBike': False}}
    Should Be Equal    你有一笔未支付的订单，请支付后再用车    ${content}[1][data][cause]

user.ride.create_确认开锁_正在被别人骑行中的车辆==bug
    app登陆    ${激活用户_A用户开始骑行}
    获取用户信息
    用户骑行中或者待支付的最近一笔订单退费
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    ${bikeKey}    获取bikeKey    ${车辆编号}
    连接车辆    ${车辆编号}    bikeKey=${bikeKey}
    Log    第一个用户开锁一辆车${车辆编号}
    获取车辆信息    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}
    ${结束时间戳}    获取now毫秒级时间戳
    app登陆    ${激活用户_正在被别人骑行中的车辆}
    获取用户信息
    Log    第二个用户开锁同一辆车${车辆编号}
    获取车辆信息    ${车辆编号}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    正常开锁=${false}
    Dictionary Should Contain Key    ${content}[1]    data    msg 【单车确认开锁】接口返回应该有key：data,实际返回：${content}[1]
    Should Be Equal    车辆暂不可用，换一辆吧    ${content}[1][data][cause]
    #结束第一个用户的订单
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}
    [Teardown]    Run Keyword If Test Failed    用户骑行中或者待支付的最近一笔订单退费

user.ride.create_确认开锁_全能车黑名单用户
    app登陆    ${激活用户_全能车黑名单用户}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    Should Be Equal    账号已加入黑名单，不可用车    ${content}[1][data][cause]

user.ride.create_确认开锁_开锁别人预约的车辆
    app登陆    ${激活用户_别人已预约车辆}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    设置车辆位置    ${车辆编号}
    取消预约车辆    ${车辆编号}
    预约车辆    ${车辆编号}
    app登陆    ${激活用户_开锁被预约的车辆}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}
    #期望返回：{'code': 0, 'data': {'cause': '车辆被预约了, 请换一辆试试', 'causeType': 203, 'result': False, 'missBike': False}}
    Should Be Equal    车辆被预约了, 请换一辆试试    ${content}[1][data][cause]
    [Teardown]    取消预约车辆    ${车辆编号}

user.ride.create_确认开锁_失联车，客户端未打开蓝牙，提示'该单车只支持蓝牙开锁'
    app登陆    ${appMobile_shaohui_authed}
    获取用户信息
    ${bikeNo}    获取普通运营中闲置的车辆-sh    ${区号_蓝牙开锁}
    车辆设置失联车标签    ${bikeNo}
    ${content}    单车确认开锁    ${bikeNo}    ${区号_蓝牙开锁}    ${行政代码_蓝牙开锁}    ${纬度_南通_人民政府}    ${经度_南通_人民政府}    返回验证=${false}    connectBluetooth=${false}
    should be equal as Numbers    ${content}[0]    200
    should be equal as Numbers    ${content}[1][code]    0
    should be equal as strings    ${content}[1][data][cause]    该单车只支持蓝牙开锁
    should be equal as Numbers    ${content}[1][data][causeType]    602
    [Teardown]    run Keywords    车辆断开连接    ${bikeNo}    ${bikeKey}
    ...    AND    车辆设置失联车标签    ${bikeNo}    ${删除失联车标签}

user.ride.create_确认开锁_失联车，客户端打开蓝牙，走蓝牙开锁
    app登陆    ${appMobile_shaohui_authed}
    获取用户信息
    ${bikeNo}    获取普通运营中闲置的车辆-sh    ${区号_蓝牙开锁}
    车辆设置失联车标签    ${bikeNo}
    ${content}    单车确认开锁    ${bikeNo}    ${区号_蓝牙开锁}    ${行政代码_蓝牙开锁}    ${纬度_南通_人民政府}    ${经度_南通_人民政府}    connectBluetooth=${true}
    should be equal as Numbers    ${content}[0]    200
    should be equal as Numbers    ${content}[1][code]    0
    should be equal as strings    ${content}[1][data][result]    True
    should be equal as Numbers    ${content}[1][data][rideId]    ${rideId}
    should not be empty    ${content}[1][data][bluetoothKey]
    should be equal as strings    ${content}[1][data][missBike]    True
    [Teardown]    run Keywords    结束订单通用    ${bikeNo}    ${rideId}
    ...    AND    车辆设置失联车标签    ${bikeNo}    ${删除失联车标签}

create_压测用户只能开压测的锁
    ${data}    set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"create","request":{"arg0":{"adCode":"310112","areaEdgeDistance":-3,"signalType":4,"lat":31.122583,"clientId":"","bikeNo":"2100887277","force":1,"deviceFingerprinting":{"datatype":"aimt_datas","id_ver":"Android_1.0.1","rdata":"pI5IRWmldU9tn/kyBRhiKNKSpBq+AxEYIYUo1efIHUwqJWTBagocesajn3JvPFSflfbLFFhXj8WF0RMqsXhZN5dFtU3/soxmhTYCboXTfmmNl067jo3pD3+MmbwBB/o4OG0hfTazkOXwo9JvztxHnwaSvv8Ryc6K1ZfbWMi957BcOGKA7oIOEvM174P6iX2kR3cAUx+Tn2uOWke+oK/8h6lBehfzufaSHL1lxzmg1MY0Pp9KbNzG/QtkvLWHVAvqqf6YgIom7TTF1vK7KUkpd95ZS+cInoeFQnJdr0emT64X8RqjULhMcV7O0v2CCtNt2pjOuicvoc5p84/6tREKNwBEP2G8MlqDWICNEyXewnwT597NHz8ikGVWYB2/IrYglx8TYC+VSVTWDhPPnV1fDAoJLqs9MMgIVunFFH0I+f1DXvF8nYJfQErpFcYI3Qq8utEi4EX709MXimBPVJRTs1Qs2r+6kF8In5CjBx81oZAC/ObhY0Kn1/K/gsoA0RP82q06YdBUDkegfJNPRpMoEQURx+nl9kwbdFhVBOE2o9dBF80D+CzU6TX9zKpPY0kl4hZKVLkw2IDkjFd9OMBFJDHnmXiOhxPCephChBnNGOg=","rk":"PeOxOZL+RGxtUFdLVFBlc0rhy8fLAGC1F01bC+9poY8EV7Ekf1wZKIA3Si/2UZ8wiL6pNEYJho1DfgJZ9w3+rDC2vbY/Q2Yl6mgpEGNfITQv8gEpuSxk6ejv/722appPRqmuxtzRVL0YS7Qyton9TA3ianSFqC75Hmvk3Dj3C6c="},"model":0,"ip":"116.228.30.6","_fingerPrintHash":"","ticket":"MTU5NDUzNjQ0Nw==.o6W09UWdEnYzQkZGSBKaLtoqT3NlMExNBmGPbXmdMQk=","token":"3eb18816ecc84b528beb0bf565e380bd","adSource":"","deviceId":"869044039730559","mode":0,"riskControlData":{"batteryLevel":"52","deviceLat":31.122583,"mobileNoInfo":"","capability":"Unknown","roam":"","ssidName":"Unknown","deviceLon":121.36407,"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","network":"Wifi"},"_riskId":"91099e4c171a4d91b02851555eea7903","__sysTag":"monarch-0e4555bc","systemCode":"62","deviceHash":"c3266b9b532e77578bc576b47868837170e2825855d2020533b77a0e02acb4e8","cityCode":"021","deviceUserAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","userNewId":"1200126207","rideLicenseforce":1,"_uuid":"yc_164253e67f5240a89973758dbf2bd43b","_userAgent":"okhttp/3.12.2","version":"${接口的最新版本}","connectBluetooth":False,"lng":121.36407,"action":"user.ride.create","deviceModel":"Redmi 6 Pro","_xff":"116.228.30.6"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    205
    should be equal as strings    ${repdata}[1][response][msg]    这不是哈啰单车哦, 换一辆试试

create_用户不存在
    ${data}    set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"create","request":{"arg0":{"adCode":"310112","areaEdgeDistance":-3,"signalType":4,"lat":31.122583,"clientId":"","bikeNo":"2100887277","force":1,"deviceFingerprinting":{"datatype":"aimt_datas","id_ver":"Android_1.0.1","rdata":"pI5IRWmldU9tn/kyBRhiKNKSpBq+AxEYIYUo1efIHUwqJWTBagocesajn3JvPFSflfbLFFhXj8WF0RMqsXhZN5dFtU3/soxmhTYCboXTfmmNl067jo3pD3+MmbwBB/o4OG0hfTazkOXwo9JvztxHnwaSvv8Ryc6K1ZfbWMi957BcOGKA7oIOEvM174P6iX2kR3cAUx+Tn2uOWke+oK/8h6lBehfzufaSHL1lxzmg1MY0Pp9KbNzG/QtkvLWHVAvqqf6YgIom7TTF1vK7KUkpd95ZS+cInoeFQnJdr0emT64X8RqjULhMcV7O0v2CCtNt2pjOuicvoc5p84/6tREKNwBEP2G8MlqDWICNEyXewnwT597NHz8ikGVWYB2/IrYglx8TYC+VSVTWDhPPnV1fDAoJLqs9MMgIVunFFH0I+f1DXvF8nYJfQErpFcYI3Qq8utEi4EX709MXimBPVJRTs1Qs2r+6kF8In5CjBx81oZAC/ObhY0Kn1/K/gsoA0RP82q06YdBUDkegfJNPRpMoEQURx+nl9kwbdFhVBOE2o9dBF80D+CzU6TX9zKpPY0kl4hZKVLkw2IDkjFd9OMBFJDHnmXiOhxPCephChBnNGOg=","rk":"PeOxOZL+RGxtUFdLVFBlc0rhy8fLAGC1F01bC+9poY8EV7Ekf1wZKIA3Si/2UZ8wiL6pNEYJho1DfgJZ9w3+rDC2vbY/Q2Yl6mgpEGNfITQv8gEpuSxk6ejv/722appPRqmuxtzRVL0YS7Qyton9TA3ianSFqC75Hmvk3Dj3C6c="},"model":0,"ip":"116.228.30.6","_fingerPrintHash":"","ticket":"MTU5NDUzNjQ0Nw==.o6W09UWdEnYzQkZGSBKaLtoqT3NlMExNBmGPbXmdMQk=","token":"3eb18816ecc84b528beb0bf565e380bd","adSource":"","deviceId":"869044039730559","mode":0,"riskControlData":{"batteryLevel":"52","deviceLat":31.122583,"mobileNoInfo":"","capability":"Unknown","roam":"","ssidName":"Unknown","deviceLon":121.36407,"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","network":"Wifi"},"_riskId":"91099e4c171a4d91b02851555eea7903","__sysTag":"monarch-0e4555bc","systemCode":"62","deviceHash":"c3266b9b532e77578bc576b47868837170e2825855d2020533b77a0e02acb4e8","cityCode":"021","deviceUserAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","userNewId":"1200126207","rideLicenseforce":1,"_uuid":"xxx164253e67f5240a89973758dbf2bd43b","_userAgent":"okhttp/3.12.2","version":"${接口的最新版本}","connectBluetooth":False,"lng":121.36407,"action":"user.ride.create","deviceModel":"Redmi 6 Pro","_xff":"116.228.30.6"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    114
    should be equal as strings    ${repdata}[1][response][msg]    用户不存在

create_已预约的车辆
    app登陆    ${appMobile_shaohui_authed}
    获取用户信息
    ${bikeNo}    获取普通运营中闲置的车辆-sh
    预约车辆    ${bikeNo}
    ${data}    set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"create","request":{"arg0":{"adCode":"310112","areaEdgeDistance":-3,"signalType":4,"lat":31.122583,"clientId":"","bikeNo":"${bikeNo}","force":1,"deviceFingerprinting":{"datatype":"aimt_datas","id_ver":"Android_1.0.1","rdata":"pI5IRWmldU9tn/kyBRhiKNKSpBq+AxEYIYUo1efIHUwqJWTBagocesajn3JvPFSflfbLFFhXj8WF0RMqsXhZN5dFtU3/soxmhTYCboXTfmmNl067jo3pD3+MmbwBB/o4OG0hfTazkOXwo9JvztxHnwaSvv8Ryc6K1ZfbWMi957BcOGKA7oIOEvM174P6iX2kR3cAUx+Tn2uOWke+oK/8h6lBehfzufaSHL1lxzmg1MY0Pp9KbNzG/QtkvLWHVAvqqf6YgIom7TTF1vK7KUkpd95ZS+cInoeFQnJdr0emT64X8RqjULhMcV7O0v2CCtNt2pjOuicvoc5p84/6tREKNwBEP2G8MlqDWICNEyXewnwT597NHz8ikGVWYB2/IrYglx8TYC+VSVTWDhPPnV1fDAoJLqs9MMgIVunFFH0I+f1DXvF8nYJfQErpFcYI3Qq8utEi4EX709MXimBPVJRTs1Qs2r+6kF8In5CjBx81oZAC/ObhY0Kn1/K/gsoA0RP82q06YdBUDkegfJNPRpMoEQURx+nl9kwbdFhVBOE2o9dBF80D+CzU6TX9zKpPY0kl4hZKVLkw2IDkjFd9OMBFJDHnmXiOhxPCephChBnNGOg=","rk":"PeOxOZL+RGxtUFdLVFBlc0rhy8fLAGC1F01bC+9poY8EV7Ekf1wZKIA3Si/2UZ8wiL6pNEYJho1DfgJZ9w3+rDC2vbY/Q2Yl6mgpEGNfITQv8gEpuSxk6ejv/722appPRqmuxtzRVL0YS7Qyton9TA3ianSFqC75Hmvk3Dj3C6c="},"model":0,"ip":"116.228.30.6","_fingerPrintHash":"","ticket":"MTU5NDUzNjQ0Nw==.o6W09UWdEnYzQkZGSBKaLtoqT3NlMExNBmGPbXmdMQk=","token":"3eb18816ecc84b528beb0bf565e380bd","adSource":"","deviceId":"869044039730559","mode":0,"riskControlData":{"batteryLevel":"52","deviceLat":31.122583,"mobileNoInfo":"","capability":"Unknown","roam":"","ssidName":"Unknown","deviceLon":121.36407,"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","network":"Wifi"},"_riskId":"91099e4c171a4d91b02851555eea7903","__sysTag":"monarch-0e4555bc","systemCode":"62","deviceHash":"c3266b9b532e77578bc576b47868837170e2825855d2020533b77a0e02acb4e8","cityCode":"021","deviceUserAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","userNewId":"${usernewid}","rideLicenseforce":1,"_uuid":"${用户全局标识}","_userAgent":"okhttp/3.12.2","version":"${接口的最新版本}","connectBluetooth":False,"lng":121.36407,"action":"user.ride.create","deviceModel":"Redmi 6 Pro","_xff":"116.228.30.6"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    0
    should be equal as Numbers    ${repdata}[1][response][code]    0
    should not be empty    ${repdata}[1][response][data]
    [Teardown]    取消预约车辆    ${bikeNo}

create_红包车mode&不是运营中模式，先判断距离再校正位置==TobeCheck
    app登陆    ${appMobile_shaohui_authed}
    获取用户信息
    连接数据库    ${database}    ${user}    ${password}    ${host}    ${port}
    ${bikeNo}    查询    select bike_no,bike_key from t_bike_info where bike_type = ${车辆类型_普通车} and bike_status<> ${车辆状态_运营中} and bike_running_status = ${骑行状态_闲置} and city_code='021' order by update_date desc limit 1
    Should Not Be Empty    ${bikeNo}
    ${data}    set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"create","request":{"arg0":{"adCode":"310112","areaEdgeDistance":-3,"signalType":4,"lat":31.122583,"clientId":"","bikeNo":"${bikeNo}[0][0]","force":1,"deviceFingerprinting":{"datatype":"aimt_datas","id_ver":"Android_1.0.1","rdata":"pI5IRWmldU9tn/kyBRhiKNKSpBq+AxEYIYUo1efIHUwqJWTBagocesajn3JvPFSflfbLFFhXj8WF0RMqsXhZN5dFtU3/soxmhTYCboXTfmmNl067jo3pD3+MmbwBB/o4OG0hfTazkOXwo9JvztxHnwaSvv8Ryc6K1ZfbWMi957BcOGKA7oIOEvM174P6iX2kR3cAUx+Tn2uOWke+oK/8h6lBehfzufaSHL1lxzmg1MY0Pp9KbNzG/QtkvLWHVAvqqf6YgIom7TTF1vK7KUkpd95ZS+cInoeFQnJdr0emT64X8RqjULhMcV7O0v2CCtNt2pjOuicvoc5p84/6tREKNwBEP2G8MlqDWICNEyXewnwT597NHz8ikGVWYB2/IrYglx8TYC+VSVTWDhPPnV1fDAoJLqs9MMgIVunFFH0I+f1DXvF8nYJfQErpFcYI3Qq8utEi4EX709MXimBPVJRTs1Qs2r+6kF8In5CjBx81oZAC/ObhY0Kn1/K/gsoA0RP82q06YdBUDkegfJNPRpMoEQURx+nl9kwbdFhVBOE2o9dBF80D+CzU6TX9zKpPY0kl4hZKVLkw2IDkjFd9OMBFJDHnmXiOhxPCephChBnNGOg=","rk":"PeOxOZL+RGxtUFdLVFBlc0rhy8fLAGC1F01bC+9poY8EV7Ekf1wZKIA3Si/2UZ8wiL6pNEYJho1DfgJZ9w3+rDC2vbY/Q2Yl6mgpEGNfITQv8gEpuSxk6ejv/722appPRqmuxtzRVL0YS7Qyton9TA3ianSFqC75Hmvk3Dj3C6c="},"model":0,"ip":"116.228.30.6","_fingerPrintHash":"","ticket":"MTU5NDUzNjQ0Nw==.o6W09UWdEnYzQkZGSBKaLtoqT3NlMExNBmGPbXmdMQk=","token":"3eb18816ecc84b528beb0bf565e380bd","adSource":"","deviceId":"869044039730559","mode":1,"riskControlData":{"batteryLevel":"52","deviceLat":31.122583,"mobileNoInfo":"","capability":"Unknown","roam":"","ssidName":"Unknown","deviceLon":121.36407,"systemCode":"62","userAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","network":"Wifi"},"_riskId":"91099e4c171a4d91b02851555eea7903","__sysTag":"monarch-0e4555bc","systemCode":"62","deviceHash":"c3266b9b532e77578bc576b47868837170e2825855d2020533b77a0e02acb4e8","cityCode":"021","deviceUserAgent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Pro Build/OPM1.171019.019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36","userNewId":"${usernewid}","rideLicenseforce":1,"_uuid":"${用户全局标识}","_userAgent":"okhttp/3.12.2","version":"${接口的最新版本}","connectBluetooth":False,"lng":121.36407,"action":"user.ride.create","deviceModel":"Redmi 6 Pro","_xff":"116.228.30.6"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200

parseBleReport_bikeNo为空，接口返回‘设备编号不能为空’
    ${data}    Set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"parseBleReport","request":{"arg0":{"_fingerPrintRawdata":"","action":"user.ride.bleReport","bikeNo":"","result":"","_userAgent":"GRequests/0.10","_fingerPrintHash":"","_riskId":"a961bf7367b6483088bc071a34c7d492","token":"${token}","_uuid":"${guid}","userNewId":"${usernewid}","ip":"47.96.225.67","_xff":"47.96.225.67"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    124
    should be equal as strings    ${repdata}[1][response][msg]    设备编号不能为空

parseBleReport_正常传参，接口返回type=-1
    ${data}    Set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"parseBleReport","request":{"arg0":{"action":"user.ride.bleReport","bikeNo":"1110003046","result":"","_uuid":"ebf332d1b8cc4c17b463eb44c7e0992f","_xff":"47.96.225.67","_userAgent":"GRequests/0.10","_fingerPrintRawdata":"","token":"d18ac2232f524d92b126359470ced7c8","userNewId":"1200005176","ip":"47.96.225.67","_fingerPrintHash":"","_riskId":"143d0c0e16f84433b8abc5c7df2d5268"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    0
    should be equal as Numbers    ${repdata}[1][response][data][type]    -1
    should be equal as Numbers    ${repdata}[1][response][data][resultType]    0

reCreate_orderGuid为空，接口返回‘参数不合法’
    [Documentation]    锁环卡住重新开锁
    ${data}    Set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"reCreate","request":{"arg0":{"bikeNo":"2500704438","orderGuid":"","token":"${token}","version":"${接口的最新版本}","_uuid":"${guid}","_xff":"47.96.225.67","_userAgent":"GRequests/0.10","action":"user.ride.reCreate","_fingerPrintHash":"","userNewId":"${usernewid}","ip":"47.96.225.67","_riskId":"fa86614ceca44273afa5939e29e98bf2","systemCode":"62"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    444
    should be equal as strings    ${repdata}[1][response][msg]    参数不合法

reCreate_userGuid为空，接口返回‘参数不合法’
    ${data}    Set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"reCreate","request":{"arg0":{"bikeNo":"2500704438","orderGuid":"15597480307661013306814","token":"${token}","version":"${接口的最新版本}","_uuid":"","_xff":"47.96.225.67","_userAgent":"GRequests/0.10","action":"user.ride.reCreate","_fingerPrintHash":"","userNewId":"${usernewid}","ip":"47.96.225.67","_riskId":"fa86614ceca44273afa5939e29e98bf2","systemCode":"62"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    444
    should be equal as strings    ${repdata}[1][response][msg]    参数不合法

reCreate_bikeNo为空，接口返回‘参数不合法’
    ${data}    Set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"reCreate","request":{"arg0":{"bikeNo":"","orderGuid":"15597480307661013306814","token":"${token}","version":"${接口的最新版本}","_uuid":"${guid}","_xff":"47.96.225.67","_userAgent":"GRequests/0.10","action":"user.ride.reCreate","_fingerPrintHash":"","userNewId":"${usernewid}","ip":"47.96.225.67","_riskId":"fa86614ceca44273afa5939e29e98bf2","systemCode":"62"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    444
    should be equal as strings    ${repdata}[1][response][msg]    参数不合法

reCreate_订单createTime缓存为空或者超过配置的重新开锁时间,接口返回‘请返回首页重新扫码开锁’
    ${data}    Set Variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"reCreate","request":{"arg0":{"bikeNo":"2500704438","orderGuid":"15597480307661013306814","token":"a0f77325dc6444c89767bba6856604e4","version":"5.35.2","_uuid":"9f80a0da0cdb4266ad917ad4d1c9b5f0","_xff":"47.96.225.67","_userAgent":"GRequests/0.10","action":"user.ride.reCreate","_fingerPrintHash":"","userNewId":"1200101019","ip":"47.96.225.67","_riskId":"fa86614ceca44273afa5939e29e98bf2","systemCode":"62"}}}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    603
    should be equal as strings    ${repdata}[1][response][msg]    请返回首页重新扫码开锁

reCreate_正常流程开锁，锁环被卡，重新开锁
    app登陆    ${appMobile_shaohui_authed}
    获取用户信息
    查询城市可用车辆-sh_创建订单
    ${table}    连接数据库_分库分表    ${bike_order_database}    ${bike_order_user_fat}    ${bike_order_password_fat}    ${bike_order_host_fat}    ${bike_order_port_fat}
    ${sql}    Set Variable    update t_ride_info_${table} set ride_status=-2 where guid='${rideId}'
    ${content}    更新    ${sql}
    ${data}    set variable    {"addr":"${AppHellobikeOpenlockService}","iface":"com.hellobike.openlock.ifaces.OpenlockServiceIface","method":"reCreate","request":{"arg0":{"bikeNo":"${bikeNo}","orderGuid":"${rideId}","token":"${token}","version":"${接口的最新版本}","_uuid":"${guid}","_xff":"47.96.225.67","_userAgent":"GRequests/0.10","action":"user.ride.reCreate","_fingerPrintHash":"","userNewId":"${usernewid}","ip":"47.96.225.67","_riskId":"fa86614ceca44273afa5939e29e98bf2","systemCode":"62"}}}
    redis command without database    bikeuser-cluster    del userBike:${guid}
    修改车辆骑行状态Redis    ${bikeNo}
    修改车辆骑行状态DB    ${bikeNo}
    redis command without database    bikeuser-cluster    get bikeServiceIp:${bikeNo}
    ${repdata}    request client    data=${data}
    should be Equal as Numbers    ${repdata}[0]    200
    should be equal as Numbers    ${repdata}[1][response][code]    0
    should be equal as strings    ${repdata}[1][response][msg]    ok

*** Keywords ***
预开锁_东营
    [Arguments]    ${车辆编号}    ${客户端}=${安卓客户端}    ${版本}=${接口的最新版本}
    ${content}    预开锁    车辆编号=${车辆编号}    区号=${区号_东营}    行政代码=${行政代码_东营区}    纬度=${纬度_东营市政府}    经度=${经度_东营市政府}    客户端=${客户端}    版本=${版本}
    log    【预开锁_东营】执行成功
    [Return]    ${content}

预开锁_东莞
    [Arguments]    ${车辆编号}    ${客户端}=${安卓客户端}    ${版本}=${接口的最新版本}    ${纬度}=${纬度_东莞虎门镇麒麟公园}    ${经度}=${经度_东莞虎门镇麒麟公园}
    ${content}    预开锁    车辆编号=${车辆编号}    区号=${区号_东莞}    行政代码=${行政代码_虎门镇}    纬度=${纬度}    经度=${经度}    客户端=${客户端}    版本=${版本}
    log    【预开锁_东莞】执行成功
    [Return]    ${content}

确认开锁_低驾照分
    [Arguments]    ${低驾照分用户}    ${警告标题}
    app登陆    ${低驾照分用户}
    获取用户信息
    ${车辆编号}    获取普通运营中闲置的车辆    ${区号_上海}
    ${content}    单车确认开锁    ${车辆编号}    返回验证=${false}    客户端=${ios客户端}
    Log    【确认开锁_低驾照分】${content}
    Should Be Equal    ${警告标题}    ${content}[1][data][notice][warnTitle]

生成东莞亮高校车超区订单
    [Arguments]    ${车辆编号}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    ${content}    单车确认开锁    ${车辆编号}    行政代码=${行政代码_虎门镇}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    ${订单信息}    Run Keyword If    ${订单全局标识} != None    获取当前订单的信息    ${订单全局标识}
    ${订单数量}    Get Length    ${订单信息}
    ${开始时间}    Run Keyword If    ${订单数量} != 0    Evaluate    '${订单信息}[0][6]'    modules=datetime
    ${更新开始时间}    Run Keyword If    ${订单数量} != 0    日期加时间    ${开始时间}    -3 minutes
    Run Keyword If    ${订单数量} != 0    更新订单开始时间    ${订单全局标识}    ${更新开始时间}
    #区外关锁
    ${结束时间戳}    获取now毫秒级时间戳
    设置车辆位置    ${车辆编号}    纬度=${纬度_东莞虎门镇麒麟公园}    经度=${经度_东莞虎门镇麒麟公园}
    #rideapi中阿波罗配置paymentGraytestConfig中设置{"openPayment":false,"openCitys":["DBC2FA2D0FBF413393124FEA3039048E"]}则自动支付
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}    纬度=${纬度_东莞虎门镇麒麟公园}    经度=${经度_东莞虎门镇麒麟公园}

生成东莞亮高校车超区订单后从区外骑回区内
    [Arguments]    ${车辆编号}
    设置车辆位置    ${车辆编号}    纬度=${纬度_东莞虎门镇麒麟公园}    经度=${经度_东莞虎门镇麒麟公园}
    ${content}    单车确认开锁    ${车辆编号}    行政代码=${行政代码_虎门镇}    纬度=${纬度_东莞虎门镇麒麟公园}    经度=${经度_东莞虎门镇麒麟公园}
    ${订单全局标识}    Set Variable    ${content}[1][data][rideId]
    ${当前时间戳}    获取now毫秒级时间戳
    直接上报单车开锁成功    ${车辆编号}    ${订单全局标识}    ${当前时间戳}    纬度=${纬度_东莞虎门镇麒麟公园}    经度=${经度_东莞虎门镇麒麟公园}
    ${订单信息}    Run Keyword If    ${订单全局标识} != None    获取当前订单的信息    ${订单全局标识}
    ${订单数量}    Get Length    ${订单信息}
    ${开始时间}    Run Keyword If    ${订单数量} != 0    Evaluate    '${订单信息}[0][6]'    modules=datetime
    ${更新开始时间}    Run Keyword If    ${订单数量} != 0    日期加时间    ${开始时间}    -3 minutes
    Run Keyword If    ${订单数量} != 0    更新订单开始时间    ${订单全局标识}    ${更新开始时间}
    #区内关锁
    ${结束时间戳}    获取now毫秒级时间戳
    设置车辆位置    ${车辆编号}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
    直接上报单车关锁成功    ${车辆编号}    ${订单全局标识}    ${结束时间戳}    纬度=${纬度_东莞凌屋村文化广场}    经度=${经度_东莞凌屋村文化广场}
