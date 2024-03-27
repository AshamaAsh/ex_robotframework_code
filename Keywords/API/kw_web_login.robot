*** Keywords ***
Verify success response contain all correct keys
    [Arguments]                        ${response}
    Dictionary Should Contain Key       ${response}      code
    Dictionary Should Contain Key       ${response}      partiID
    Dictionary Should Contain Key       ${response}      accessToken
    Dictionary Should Contain Key       ${response}      refreshToken


Verify error response contain all correct keys
    [Arguments]                        ${response}
    Dictionary Should Contain Key       ${response}      code
    Dictionary Should Contain Key       ${response}      message

Verify parti id "${response}" must be "${expected_parti_id}"
    ${actual_parti_id}=            Get From Dictionary     ${response}     partiID
    should be equal     ${actual_parti_id}      ${expected_parti_id}


Verify message "${response}" must be "${expected_message}"
    ${actual_message}=            Get From Dictionary     ${response}     message
    should be equal     ${actual_message}      ${expected_message}

Verify access token "${response}" must be "${expected_access_token}"
    ${actual_access_token}=            Get From Dictionary     ${response}     accessToken
    should be equal     ${actual_access_token}      ${expected_access_token}

Verify refresh token "${response}" must be "${expected_refresh_token}"
    ${actual_refresh_token}=            Get From Dictionary     ${response}     refreshToken
    should be equal     ${actual_refresh_token}      ${expected_refresh_token}

