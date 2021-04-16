*** Settings ***
Library           DatabaseLibrary

*** Keywords ***
连接数据库
    [Arguments]    ${database}    ${user}    ${password}    ${host}    ${port}
    Connect To Database Using Custom Params    psycopg2    database="${database}",user="${user}",password="${password}",host="${host}",port="${port}"

连接数据库_分库分表
    [Arguments]    ${bike_order_database}    ${bike_order_user_uat}    ${bike_order_password_uat}    ${bike_order_host_uat}    ${bike_order_port_uat}
    ${db}    evaluate    ${usernewid}%8
    ${table}    evaluate    ${usernewid}%64
    ${port_add}    evaluate    ${bike_order_port_uat}+${db}
    Connect To Database Using Custom Params    psycopg2    database="${bike_order_database}",user="${bike_order_user_uat}",password="${bike_order_password_uat}",host="${bike_order_host_uat}",port="${port_add}"
    [Return]    ${table}

关闭数据库
    Disconnect From Database

查询
    [Arguments]    ${sql}
    ${content}    Query    ${sql}
    [Return]    ${content}

更新
    [Arguments]    ${sql}
    should contain  ${sql}  where   msg 【更新】语句必须包含where条件
    ${content}    Execute Sql String    ${sql}
    should be equal as strings  None    ${content}
    Log     【更新】执行成功
    [Return]    ${content}

删除
    [Arguments]    ${sql}
    ${content}    更新    ${sql}
    [Return]    ${content}
