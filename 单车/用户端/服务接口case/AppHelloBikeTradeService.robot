*** Settings ***
Resource          ../../../资源配置/一键导入配置.resource

Suite Setup       run keywords    app登陆    ${appMobile_shaohui_authed}
...               AND    获取userNewId

*** Test Cases ***
测试数据库连接
    获取当前用户预置骑行orderGuid
