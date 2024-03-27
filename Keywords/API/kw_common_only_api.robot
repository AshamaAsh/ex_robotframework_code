
*** Keywords ***
Send get api
    [Arguments]     ${api}
    Create Session      request     url=${api}[url]
    ${result}=      Get request     request     uri=${api}[uri]     params=${api}[params]       headers=${api}[headers]
    [Return]    ${result}

Send post api
    [Arguments]     ${api}
    Create Session      request     url=${api}[url]
    ${result}=      Post request    request     uri=${api}[uri]
                    ...             params=${api}[params]      headers=${api}[headers]   data=${api}[body]
    [Return]    ${result}

Get access token "${response}"
    ${actual_access_token}=            Get From Dictionary     ${response}     accessToken
    [Return]        ${actual_access_token}

Set access token to headers
    [Arguments]     ${my_dictionary}         ${actual_access_token}
    ${headers}=     create dictionary       Authorization=Bearer ${actual_access_token}        Content-Type=application/json
    set to dictionary       ${my_dictionary}    headers=${headers}
    [Return]        ${my_dictionary}

Verify http status code "${actual_response_code}" must be "${expected_response_code}"
    should be equal     ${actual_response_code}      ${expected_response_code}

Verify status code "${response}" must be "${expected_status_code}"
    ${actual_status_code}=            Get From Dictionary     ${response}     code
    should be equal     ${actual_status_code}      ${expected_status_code}


