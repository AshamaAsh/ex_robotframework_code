*** Settings ***
Library         RequestsLibrary
Library         Collections
Variables       ../../Variables/API/var_pdf_inquiry.py
Variables       ../../Variables/API/var_web_login.py
Resource        ../../Keywords/API/kw_common_only_api.robot

*** Test Cases ***
Login valid
    [Documentation]  #Ref01
    ${response}         Send post api       ${api_login_valid}
    Verify http status code "${response.status_code}" must be "${200}"
    log to console  ${response}
    ${token_global}=   Get access token "${response.json()}"
    set global variable     ${token_global}

Required Field with code sth
    [Documentation]  #Ref02
    ${pdf_inquiry_req}=      Set access token to headers     ${pdf_inquiry_invalid_E100}     ${token_global}
    ${resp_pdf}=     Send get api      ${pdf_inquiry_req}
    log to console      ${resp_pdf.json()}
    Verify http status code "${resp_pdf.status_code}" must be "${422}"
    Verify status code "${resp_pdf.json()}" must be "sth"

Pdf inquiry valid
    [Documentation]  #Ref03
    ${pdf_inquiry_req}=      Set access token to headers     ${pdf_inquiry_valid}     ${token_global}
    ${resp_pdf}=     Send get api      ${pdf_inquiry_req}
    log to console      ${resp_pdf.json()}
    Verify http status code "${resp_pdf.status_code}" must be "${200}"
