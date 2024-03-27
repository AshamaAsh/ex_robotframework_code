*** Settings ***
Library         RequestsLibrary
Library         Collections
Variables       ../../Variables/API/var_pdf_create.py
Variables       ../../Variables/API/var_web_login.py
Resource        ../../Keywords/API/kw_common_only_api.robot

*** Test Cases ***
Unauthorized access with code sth
    [Documentation]  #Ref01
    ${response}     Send post api       ${web_login_valid}
    log to console  ${response.json()}
    ${token}=       Get access token "${response.json()}"
    ##########
    ${pdf_create_req}=          Set access token to headers     ${pdf_create_structure}     ${token}
    ${resp_pdf_create}=     Send post api      ${pdf_create_req}
    log to console      ${resp_pdf_create.json()}
    Verify http status code "${resp_pdf_create.status_code}" must be "${401}"
    Verify status code "${resp_pdf_create.json()}" must be "sth"

Token is invalid or expired with code sth
    [Documentation]  #Ref02
    ${pdf_create_req}=          Set access token to headers     ${pdf_create_structure}     ""
    ${resp_pdf_create}=     Send post api      ${pdf_create_req}
    log to console      ${resp_pdf_create.json()}
    Verify http status code "${resp_pdf_create.status_code}" must be "${403}"
    Verify status code "${resp_pdf_create.json()}" must be "sth"

Login success for set global token
    [Documentation]  #Ref03
    ${response}         Send post api       ${api_login_valid}
    Verify http status code "${response.status_code}" must be "${200}"
    ${token_global}=   Get access token "${response.json()}"
    set global variable     ${token_global}

Invalid ETF Symbol/Market/ISINCode with code sth
    [Documentation]  #Ref04
    ${pdf_create_req}=          Set access token to headers     ${pdf_create_invalid_E038}     ${token_global}
    ${resp_pdf_create}=     Send post api      ${pdf_create_req}
    log to console      ${resp_pdf_create.json()}
    Verify http status code "${resp_pdf_create.status_code}" must be "${422}"
    Verify status code "${resp_pdf_create.json()}" must be "sth"

Required field with code sth
    [Documentation]  #Ref05
    ${pdf_create_req}=          Set access token to headers     ${pdf_create_invalid_E100}     ${token_global}
    ${resp_pdf_create}=     Send post api      ${pdf_create_req}
    log to console      ${resp_pdf_create.json()}
    Verify http status code "${resp_pdf_create.status_code}" must be "${422}"
    Verify status code "${resp_pdf_create.json()}" must be "sth"

User cannot create PDF with code sth
    [Documentation]  #Ref06
    ${pdf_create_req}=      Set access token to headers     ${pdf_create_invalid_E125}     ${token_global}
    ${resp_pdf_create}=     Send post api      ${pdf_create_req}
    log to console      ${resp_pdf_create.json()}
    Verify http status code "${resp_pdf_create.status_code}" must be "${422}"
    Verify status code "${resp_pdf_create.json()}" must be "sth"

User cannot create PDF with code sth
    [Documentation]  #Ref07
    ${pdf_create_req}=      Set access token to headers     ${pdf_create_invalid_E117}     ${token_global}
    ${resp_pdf_create}=     Send post api      ${pdf_create_req}
    log to console      ${resp_pdf_create.json()}
    Verify http status code "${resp_pdf_create.status_code}" must be "${422}"
    Verify status code "${resp_pdf_create.json()}" must be "sth"

