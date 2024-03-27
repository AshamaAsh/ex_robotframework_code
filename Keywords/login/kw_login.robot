*** Keywords ***
Go to web
    Open Browser        http://webpage/           Chrome

Input username
    [Arguments]      ${username}
    Input Text       id:username             ${username}

Input password
    [Arguments]     ${password}
    Input Text      id:password              ${password}

Click signin
    Click_by_javascript       btn-submit

Enter to website
    Click Element       id:go-sth
    sleep       1s




