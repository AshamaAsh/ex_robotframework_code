*** Settings ***
Library         RequestsLibrary
Library         Collections
Variables        ../../Variables/API/var_web_login.py
Variables       ../../Variables/API/var_nav_create.py
Resource        ../../Keywords/API/kw_common_only_api.robot
Resource        ../../Keywords/API/kw_web_login.robot
Resource        ../../Keywords/API/kw_nav_api.robot
Resource        ../../Keywords/kw_database.robot
Resource        ../../Keywords/Database/kw_db_nav_create.robot
Variables        ../../Variables/login/var_login.py

*** Test Cases ***
User can create NAV unsuccessfully (#test)
    [Documentation]      #Ref01
    ${response}=     Send post api      ${ws_api_login_valid}
    ${token}=   Get access token "${response.json()}"
    Get access token from "${response}" and "${token}" set it to headers of "${test_nav_create_valid}"
    ${response1}=     Send post api      ${test_nav_create_valid}
    Verify response code "${response1.status_code}" must be "${422}"
    log to console      ${test_nav_create_valid}
    log to console      ${response1.status_code}
    Verify error response contain all correct keys      ${response.json()}
    Verify status code "${response}" must be "sth"
    Verify message "${response.json()}" must be "Unable to proceed Only an asset manager can do that."
    ${name}=    Get ETF_Security_Asset_ID by userid "sth"
    log to console      ${name}

User can create NAV successfully (#test)
    ${response}=     Send post api      ${web_login_pd_role}
    ${token}=   Get access token "${response.json()}"
    Get access token from "${response}" and "${token}" set it to headers of "${get_settlement_date}"
    log to console      ${get_settlement_date}