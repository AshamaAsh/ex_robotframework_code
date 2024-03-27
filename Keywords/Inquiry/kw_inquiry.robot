*** Keywords ***
Click reset inquiry button
    Click_by_javascript       btn-reset
    sleep   1s

Select inquiry menu
    click element       id:Inquiry

Registrar show "${etf.registrarNameEng}"
    ${registrar}=       get value           id:registrarNameEng
    ${actual_regis}=    strip string        ${registrar}
    should be equal     ${actual_regis}     ${etf.registrarNameEng}

Transaction date from/to shows current date
#    ${date_now}=    Evaluate    '{dt.day}/{dt.month}/{dt.year}'.format(dt=datetime.datetime.now())    modules=datetime
#    ${date}=        convert date        ${date_now}            result_format=%d.%mm.%Y
    ${date}=            get_date_time
    ${date_from}=       get value            id:transactionDateFrom
    ${date_to}=         get value            id:transactionDateTo
    should be equal     ${date_from}             ${date}
    should be equal     ${date_to}               ${date}

Settlement date from/to show "${expected_settlement_date}"
    ${actual_sttDateFrom}=          Get_value_by_javascript        settlementDateFrom
    ${actual_sttDateTo}=            Get_value_by_javascript        settlementDateTo
    ${actual_settlement_date_from}=             change_format_date      ${actual_sttDateFrom}
    ${actual_settlement_date_to}=               change_format_date      ${actual_sttDateTo}
    Should be equal     ${actual_settlement_date_from}      ${expected_settlement_date}
    should be equal     ${actual_settlement_date_to}        ${expected_settlement_date}

Select inquiry transaction type: creation
    click element       id:txnType_CR
    sleep   1s

Select inquiry basket type : in kind
    click element       id:in-ind
    sleep   1s

Select inquiry basket type : in cash
    click element       id:in-cash

Selecet inquiry underlying settlement type : fully
    click element       id:fully

Select transaction type: Pending approve
    click element       id:txnStatus_PA

Select transaction type: Approve
    click element       id:txnStatus_AP

Select transaction type: Confirm(1/1)
    click element       id:txnStatus_F1

Select transaction type: Confirm(2/2)
    click element       id:txnStatus_CF

Select transaction type: Rejected by user
    click element       id:txnStatus_RU

Select transaction type: Rejected (Confirm) by AM
    click element       id:txnStatus_RC


Click search button for inquiry
    Click_by_javascript         btn-search
    sleep       2s

Click reset for new inquiry
    Click_by_javascript         btn-reset

Edit records per page is "${records_per_page}"
    Set_value_by_javascript         recordsPage             ${EMPTY}
    input text                      id:recordsPage          ${records_per_page}
    set suite variable              ${records_per_page}

Get expected data from inquiry: creation/in-kind/pending approve "some_comp"
    set to dictionary              ${get_inquiry_table_some_comp_creation_IK_PA}                 url=${url_web}
    ${get_inquiry_table_some_comp_creation_IK_PA}=    Get access token from "${web_login}" and set it in variable "${get_inquiry_table_some_comp_creation_IK_PA}" for authorization
    ${date}=        get_date_for_api
    set to dictionary              ${get_inquiry_table_some_comp_creation_IK_PA["params"]}           etfSecurityAssetID=${etf_some_comp.securityAssetID}
    set to dictionary              ${get_inquiry_table_some_comp_creation_IK_PA["params"]}           txnDateFrom=${date}
    set to dictionary              ${get_inquiry_table_some_comp_creation_IK_PA["params"]}           txnDateTo=${date}
    set to dictionary              ${get_inquiry_table_some_comp_creation_IK_PA["params"]}           settlementDateFrom=${expected_settlement_date}
    set to dictionary              ${get_inquiry_table_some_comp_creation_IK_PA["params"]}           settlementDateTo=${expected_settlement_date}
    ${result}=                       Send get api            ${get_inquiry_table_some_comp_creation_IK_PA}
#    log         ${result.content}
    ${expected_some_comp_creation_IK_PA}=             Get From Dictionary     ${result.json()}    content
    Set Suite variable                          ${expected_some_comp_creation_IK_PA}

Get expected data from inquiry: creation/in-kind/pending approve
    set to dictionary              ${get_inquiry_table_creation_IK_PA}                 url=${url_web}
    ${get_inquiry_table_creation_IK_PA}=    Get access token from "${web_login}" and set it in variable "${get_inquiry_table_creation_IK_PA}" for authorization
    log             ${get_inquiry_table_creation_IK_PA}
    ${date}=        get_date_for_api
    set to dictionary              ${get_inquiry_table_creation_IK_PA["params"]}           txnDateFrom=${date}
    set to dictionary              ${get_inquiry_table_creation_IK_PA["params"]}           txnDateTo=${date}
    set to dictionary              ${get_inquiry_table_creation_IK_PA["params"]}           settlementDateFrom=${expected_settlement_date}
    set to dictionary              ${get_inquiry_table_creation_IK_PA["params"]}           settlementDateTo=${expected_settlement_date}
    log             ${get_inquiry_table_creation_IK_PA}
    ${result}=                       Send get api            ${get_inquiry_table_creation_IK_PA}
    log         ${result.content}
    ${expected_table_creation_IK_PA}=             Get From Dictionary     ${result.json()}    content
    Set Suite variable                          ${expected_table_creation_IK_PA}

Get expected data from inquiry: creation/pending approve
    set to dictionary              ${get_inquiry_table_creation_PA}                 url=${url_web}
    ${get_inquiry_table_creation_PA}=    Get access token from "${web_login}" and set it in variable "${get_inquiry_table_creation_PA}" for authorization
    ${date}=        get_date_for_api
    set to dictionary              ${get_inquiry_table_creation_PA["params"]}           txnDateFrom=${date}
    set to dictionary              ${get_inquiry_table_creation_PA["params"]}           txnDateTo=${date}
    set to dictionary              ${get_inquiry_table_creation_PA["params"]}           settlementDateFrom=${expected_settlement_date}
    set to dictionary              ${get_inquiry_table_creation_PA["params"]}           settlementDateTo=${expected_settlement_date}
    ${result}=                       Send get api            ${get_inquiry_table_creation_PA}
#    log         ${result.content}
    ${expected_table_creation_PA}=             Get From Dictionary     ${result.json()}    content
    Set Suite variable                          ${expected_table_creation_PA}

Get expected data from inquiry: pending approve
    set to dictionary              ${get_inquiry_table_PA}                 url=${url_web}
    ${get_inquiry_table_PA}=    Get access token from "${web_login}" and set it in variable "${get_inquiry_table_PA}" for authorization
    ${date}=        get_date_for_api
    set to dictionary              ${get_inquiry_table_PA["params"]}           txnDateFrom=${date}
    set to dictionary              ${get_inquiry_table_PA["params"]}           txnDateTo=${date}
    set to dictionary              ${get_inquiry_table_PA["params"]}           settlementDateFrom=${expected_settlement_date}
    set to dictionary              ${get_inquiry_table_PA["params"]}           settlementDateTo=${expected_settlement_date}
    ${result}=                       Send get api            ${get_inquiry_table_PA}
#    log         ${result.content}
    ${expected_table_PA}=             Get From Dictionary     ${result.json()}    content
    Set Suite variable                          ${expected_table_PA}

System show inquiry table: creation/in-kind/pending approve: ETF some_comp
    sleep       1s
    ${notMatch}=            Compare_inquiry_table_with_expected_data_inkind      //table[@id='enquiry_table']           ${expected_some_comp_creation_IK_PA}
    Should Be Equal         ${notMatch}             ${0}

System show inquiry table: creation/in-kind/pending approve
    sleep       1s
    ${notMatch}=            Compare_inquiry_table_with_expected_data_inkind      //table[@id='enquiry_table']           ${expected_table_creation_IK_PA}
    Should Be Equal         ${notMatch}             ${0}

System show inquiry table: creation/pending approve
    sleep       1s
    ${notMatch}=            Compare_inquiry_table_with_expected_data      //table[@id='enquiry_table']           ${expected_table_creation_PA}
    Should Be Equal         ${notMatch}             ${0}

System show inquiry table: pending approve
    sleep       1s
    ${notMatch}=            Compare_inquiry_table_with_expected_data      //table[@id='enquiry_table']           ${expected_table_PA}
    Should Be Equal         ${notMatch}             ${0}