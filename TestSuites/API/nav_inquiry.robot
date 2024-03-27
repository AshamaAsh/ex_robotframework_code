*** Settings ***
Library         RequestsLibrary
Library         Collections
Variables        ../../Variables/API/var_web_login.py
Variables       ../../Variables/API/var_nav_inquiry.py
Resource        ../../Keywords/API/kw_common_only_api.robot

*** Test Cases ***
Login valid
    [Documentation]  #Ref01
    ${response}         Send post api       ${api_login_valid}
    Verify http status code "${response.status_code}" must be "${200}"
    log to console  ${response}
    ${token_global}=   Get access token "${response.json()}"
    set global variable     ${token_global}

Required Field with code E100
    [Documentation]  #Ref02
    ${nav_inquiry_req}=      Set access token to headers     ${nav_inquiry_invalid_E100}     ${token_global}
    ${resp_nav}=     Send get api      ${nav_inquiry_req}
    log to console      ${resp_nav.json()}
    Verify http status code "${resp_nav.status_code}" must be "${422}"
    Verify status code "${resp_nav.json()}" must be "E100"

Nav inquiry valid
    [Documentation]  #Ref03
    ${nav_inquiry_req}=      Set access token to headers     ${nav_inquiry_valid}     ${token_global}
    ${resp_nav}=     Send get api      ${nav_inquiry_req}
    log to console      ${resp_nav.json()}
    Verify http status code "${resp_nav.status_code}" must be "${200}"


