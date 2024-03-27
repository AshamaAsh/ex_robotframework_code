*** Settings ***
Library    DatabaseLibrary

*** Variables ***
${dbhostname}         00.00.00.00           #example of db host name
${dbport}             000                   #example of db port
${dbusername}         username              #example of db username
${dbpassword}         password              #example of db password
${dbname}             dbname                   #example of db name

*** Keywords ***
Update user full name
    [Arguments]                 ${userid}            ${new_user_full_name}
    Connect To Database         dbapiModuleName=pymssql         dbName=${dbname}    dbUsername=${dbusername}
                ...                 dbPassword=${dbpassword}     dbHost=${dbhostname}      dbPort=${dbport}
    Execute Sql String          UPDATE MAS_USER SET User_Full_Name = '${new_user_full_name}' WHERE SysUser_ID = '${userid}' ;
    Disconnect From Database

Get latest token by userid "${userid}"
    Connect To Database         dbapiModuleName=pymssql         dbName=${dbname}    dbUsername=${dbusername}
                ...                 dbPassword=${dbpassword}     dbHost=${dbhostname}      dbPort=${dbport}
    ${query_results}=      Query      select Top 1 Token_ID,Refresh_Token_ID from LOG_USER_TOKEN where SysUser_ID = '${userid}' Order by LastUpd_Dtm Desc;
    Disconnect From Database
    [Return]        ${query_results}[0][0]    ${query_results}[0][1]

