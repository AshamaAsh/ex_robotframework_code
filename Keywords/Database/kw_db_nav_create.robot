*** Settings ***
Library    DatabaseLibrary

*** Variables ***
${dbhostname}         00.00.00.00     #example db host name
${dbport}             0000            #example db port
${dbusername}         username        #example of db username
${dbpassword}         password        #example of db password
${dbname}             dbname             #example of db name

*** Keywords ***
Get ETF_Security_Asset_ID by userid "${Security_Asset_Abbr}"
    Connect To Database         dbapiModuleName=pymssql         dbName=${dbname}    dbUsername=${dbusername}
                ...                 dbPassword=${dbpassword}     dbHost=${dbhostname}      dbPort=${dbport}
    ${query_results}=      Query      SELECT Security_Asset_Abbr, ETF_Security_Asset_ID FROM vwETFProfile WHERE Security_Asset_Abbr='GOLD99' = '${userid}' Order by LastUpd_Dtm Desc;
    Disconnect From Database
    [Return]        ${query_results}[0][0]    ${query_results}[0][1]