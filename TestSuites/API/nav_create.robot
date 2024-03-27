*** Settings ***
Library         RequestsLibrary
Library         Collections
Variables        ../../Variables/API/var_web_login.py
Variables       ../../Variables/API/var_nav_create.py
Resource        ../../Keywords/API/kw_common_only_api.robot


*** Test Cases ***
Unauthorized access with code sth
    [Documentation]  #Ref01
    ${response}     Send post api       ${web_login_valid}
    ${token}=       Get access token "${response.json()}"
    ##########
    ${nav_create_req}=      Set access token to headers     ${nav_create_valid}     ${token}
    ${resp_nav_create}=     Send post api      ${nav_create_req}
    log to console      ${resp_nav_create.json()}
    Verify http status code "${resp_nav_create.status_code}" must be "${401}"
    Verify status code "${resp_nav_create.json()}" must be "sth"

Token is invalid or expired with code sth
    [Documentation]  #Ref02
    ${nav_create_req}=          Set access token to headers     ${nav_create_valid}     ""
    ${resp_nav_create}=     Send post api      ${nav_create_req}
    log to console      ${resp_nav_create.json()}
    Verify http status code "${resp_nav_create.status_code}" must be "${403}"
    Verify status code "${resp_nav_create.json()}" must be "sth"

Login success for set global token
    [Documentation]  #Ref01
    ${response}         Send post api       ${api_login_valid}
    Verify http status code "${response.status_code}" must be "${200}"
    ${token_global}=    Get access token "${response.json()}"
    set global variable     ${token_global}

Proceed only an asset manager with code E026
    [Documentation]     #Ref02
    ${nav_create_req}=      Set access token to headers     ${nav_create_invalid_E026}     ${token_global}
    ${resp_nav_create}=     Send post api      ${nav_create_req}
    log to console      ${resp_nav_create.json()}
    Verify http status code "${resp_nav_create.status_code}" must be "${422}"
    Verify status code "${resp_nav_create.json()}" must be "E026"

Required field with code E100
    [Documentation]     #Ref02
    ${nav_create_req}=      Set access token to headers     ${nav_create_invalid_E100}     ${token_global}
    ${resp_nav_create}=     Send post api      ${nav_create_req}
    log to console      ${resp_nav_create.json()}
    Verify http status code "${resp_nav_create.status_code}" must be "${422}"
    Verify status code "${resp_nav_create.json()}" must be "E100"



