*** Settings ***
Library         RequestsLibrary
Library         Collections
Variables        ../../Variables/API/var_web_login.py
Resource        ../../Keywords/API/kw_common_api.robot
Resource        ../../Keywords/API/kw_web_login.robot
Resource        ../../Keywords/Database/kw_database.robot

*** Test Cases ***
User can login with valid username and password
    [Documentation]      #Ref01
    ${response}=     Send post api      ${api_login_valid}
    Verify http status code "${response.status_code}" must be "${200}"
    Verify success response contain all correct keys     ${response.json()}
    Verify status code "${response.json()}" must be "0000"
    Verify parti id "${response.json()}" must be "000"
    ${expected_access_token}  ${expected_refresh_token}=   Get latest token by userid "sth"
    #Verify access token "${response.json()}" must be "${expected_access_token}"
    Verify refresh token "${response.json()}" must be "${expected_refresh_token}"

User can not login with invalid password
    [Documentation]      #Ref02
    ${response}=     Send post api      ${api_login_invalid_password}
    Verify http status code "${response.status_code}" must be "${403}"
    Verify error response contain all correct keys      ${response.json()}
    Verify status code "${response.json()}" must be "sth"
    Verify message "${response.json()}" must be "Invalid Credentials"


