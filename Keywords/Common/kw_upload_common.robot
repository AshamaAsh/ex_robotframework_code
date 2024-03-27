*** Settings ***
Library         OperatingSystem

*** Keywords ***

Get expected account name of upload file from api
    set to dictionary              ${get_account_name_from_api}                 url=${url_web}
    ${get_account_name_from_api}=    Get access token from "${web_login}" and set it in variable "${get_account_name_from_api}" for authorization
    ${result}=      Send get api            ${get_account_name_from_api}
    log many            ${result.content}
#    ${content}=                                 Get From Dictionary     ${result.json()}    content
    ${expected_account}                      Create dictionary       acc_no=         acc_flag=       acc_name=
    ${expected_account.acc_no}=              Get From Dictionary     ${result.json()}[0]    accountNo
    ${expected_account.acc_flag}=            Get From Dictionary     ${result.json()}[0]    pcFlag
    ${expected_account.acc_name}=            Get From Dictionary     ${result.json()}[0]    accountName
    Set Suite variable              ${expected_account}

Get expected PD's account name of upload file from api
    set to dictionary              ${get_pd_account_name_from_api}                 url=${url_web}
    ${get_pd_account_name_from_api}=    Get access token from "${web_login}" and set it in variable "${get_pd_account_name_from_api}" for authorization
    log             ${get_pd_account_name_from_api}
    ${result}=      Send get api            ${get_pd_account_name_from_api}
    log many            ${result.content}
#    ${content}=                                 Get From Dictionary     ${result.json()}    content
    ${expected_pdAccount}                      Create dictionary       acc_no=         acc_flag=       acc_name=
    ${expected_pdAccount.acc_no}=              Get From Dictionary     ${result.json()}[0]    accountNo
    ${expected_pdAccount.acc_flag}=            Get From Dictionary     ${result.json()}[0]    pcFlag
    ${expected_pdAccount.acc_name}=            Get From Dictionary     ${result.json()}[0]    accountName
    Set Suite variable              ${expected_pdAccount}

Get expected AM's account name of upload file from api
    set to dictionary              ${get_am_account_name_from_api}                 url=${url_web}
    ${get_am_account_name_from_api}=    Get access token from "${web_login}" and set it in variable "${get_am_account_name_from_api}" for authorization
    ${result}=      Send get api            ${get_am_account_name_from_api}
    log many            ${result.content}
#    ${content}=                                 Get From Dictionary     ${result.json()}    content
    ${expected_amAccount}                      Create dictionary       acc_no=         acc_flag=       acc_name=
    ${expected_amAccount.acc_no}=              Get From Dictionary     ${result.json()}[0]    accountNo
    ${expected_amAccount.acc_flag}=            Get From Dictionary     ${result.json()}[0]    pcFlag
    ${expected_amAccount.acc_name}=            Get From Dictionary     ${result.json()}[0]    accountName
    Set Suite variable              ${expected_amAccount}

## Upload file ##
Click upload file
    click element          xpath:somexpath
    wait for loading data

Click confirm upload file
    wait until page contains element        id:btn-modal-confirm        #element visible is better
    Click_by_javascript                     btn-modal-confirm

Upload file "${file_name}" for "${folder_name}" to website
    ${normal_path}=                         Normalize Path          ${CURDIR}//..//..//Upload//${folder_name}//${file_name}
    Choose file                             id:fusk                 ${normal_path}
    wait for loading page

Get value from text file "${file_name}" for "${folder_name}"
    ${path}=        Normalize Path         ${CURDIR}//..//..//Upload//${folder_name}//${file_name}
    ${data}=        Read_upload_file       ${path}
    set suite variable          ${data}

System show creation table as uploaded file of parti "${parti_id}"
    ${notMatch}=    Compare_table_with_upload_file      //table[@id='enquiry_table']          ${data}     ${expected_account}       ${expected_account}     ${expected_pdAccount}     ${expected_amAccount}     ${parti_${parti_id}}
#        ${notMatch}=    Compare_table_with_upload_file      //table[@id='enquiry_table']          ${data}      ${parti_${parti_id}}
    Should Be Equal         ${notMatch}             ${0}

System show redemption table as uploaded file of parti "${parti_id}"
    ${notMatch}=    Compare_table_with_upload_file      //table[@id='enquiry_table']          ${data}     ${expected_account}       ${expected_account}     ${expected_account}     ${expected_account}     ${parti_${parti_id}}
#        ${notMatch}=    Compare_table_with_upload_file      //table[@id='enquiry_table']          ${data}      ${parti_${parti_id}}
    Should Be Equal         ${notMatch}             ${0}

System show table as uploaded file of parti "${parti_id}" for in-cash
    wait for loading page                  #wait until
    ${notMatch}=    Compare_table_with_expected_data_from_file_incash      //table[@id='enquiry_table']          ${data}       ${expected_account}       ${expected_account}      ${parti_${parti_id}}
    Should Be Equal         ${notMatch}             ${0}
    wait for loading data

System show redemption table as uploaded file of parti "${parti_id}" for in-cash
    wait for loading page                 #wait until
    ${notMatch}=    Compare_table_with_expected_data_from_file_incash_redem      //table[@id='enquiry_table']          ${data}       ${expected_account}       ${expected_account}      ${parti_${parti_id}}
    Should Be Equal         ${notMatch}             ${0}
    wait for loading data

Compare etf volume with to receive
    Compare_etf_volume_with_to_receive


