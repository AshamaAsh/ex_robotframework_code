*** Settings ***
Library         SeleniumLibrary        timeout=10      implicit_wait=10
Library         DateTime
Library         RequestsLibrary
Library         Collections
Library         String

*** Variables ***
${url_web}=         http://00.00.00.00   #example url

*** Keywords ***
####
Wait for loading page
    sleep   2s

wait for loading data
    sleep   1s
####
User enter to website "${url_web}"
    ${url_web}=                     set variable        ${url_web}${/}
    log                             ${url_web}
    set selenium speed              0.15s
    open browser                    ${url_web}          Chrome
    Maximize Browser Window
    Execute javascript              document.body.style.zoom="110%"
    set suite variable              ${url_web}

User login with username "${username}" and "${password}"
    Input Text                  id:username             ${username}
    Input Text                  id:password              ${password}
    wait for loading page
    Click_by_javascript         btn-submit

System show message of
    page should contain element         //div[@class="modal-content"]

Click accept condition
    wait until keyword succeeds     5x      4s      click element               //label[text()="Accept"]

User select creation and redemption menu
    Click_by_javascript               Creation&Redemption
    Click_by_javascript               CreateCreation&Redemption

Select ETF menu
    Click_by_javascript             etf

Select creation and redemption menu
    Click_by_javascript             CRRD001menu

Select create creation and redemption
    Click_by_javascript             CreateCreation&Redemption

Transaction date shows current date
#    ${date_now}=    Evaluate    '{dt.day}/{dt.month}/{dt.year}'.format(dt=datetime.datetime.now())    modules=datetime
#    ${date}=        convert date        ${date_now}         	result_format=%d.%mm.%Y
    ${date}=        get_date_time
    ${value}=       get value            id:transactionDate
    should be equal         ${value}             ${date}

PD/MM ID show "${expected_parti_id}"
    ${actual_parti_id}=          get value           id:partiID
    ${actual_parti_id}=          strip string        ${actual_parti_id}
    should be equal         ${actual_parti_id}             ${expected_parti_id}

PD/MM short name show "${expected_parti_short_name}"
    ${actual_parti_shortName}=          Get value                       id:asset-name
    ${actual_parti_shortName}=          strip string                    ${actual_parti_shortName}
    should be equal             ${actual_parti_shortName}           ${expected_parti_short_name}

PD/MM full name show "${expected_parti_full_name}"
    ${str}=                         Get value                       id:asset-name-full
    ${actual_parti_fullName}=       strip string                    ${str}
    should be equal                 ${actual_parti_fullName}        ${expected_parti_full_name}

Get access token from "${web_login}" and set it in variable "${request}" for authorization
    [Documentation]     get access token in each re-login and put it to variable for authorization
    set to dictionary                   ${web_login}     url=${url_web}

    ${result}=                          Send post api           ${web_login}

    ${actual_access_token}=             Get From Dictionary     ${result.json()}     accessToken
    ${json_str}=        evaluate        json.dumps(${result.content})     json
    ${json_dic}=        evaluate        json.loads('''${json_str}''')       json
    set to dictionary           ${request["headers"]}    Authorization=Bearer ${actual_access_token}
    Set Suite variable          ${actual_access_token}
    [Return]            ${request}

Get expected settlement date from api
    set to dictionary                   ${get_settlement_date_from_api}             url=${url_web}
    ${get_settlement_date_from_api}=    Get access token from "${web_login}" and set it in variable "${get_settlement_date_from_api}" for authorization
    ${date}=        get_date_for_api
    set to dictionary    ${get_settlement_date_from_api["params"]}    txnDate=${date}
    ${result}=      Send get api            ${get_settlement_date_from_api}
    ${expected_settlement_date}=          Get From Dictionary     ${result.json()}     settlementDate
    Set Suite variable           ${expected_settlement_date}

Get expected cash amount of "${etf}" from api
    set to dictionary             ${get_cash_amount}                     url=${url_web}
    ${get_cash_amount}=    Get access token from "${web_login}" and set it in variable "${get_cash_amount}" for authorization
    ${date}=        get_date_for_api
    set to dictionary    ${get_cash_amount["body"]}    txnDate=${date}
    set to dictionary    ${get_cash_amount["body"]}    etfSecurityAssetID=${etf_${etf}.securityAssetID}
#    log             ${get_cash_amount}
    ${result}=      Send post api            ${get_cash_amount}
    ${expected_cash_amount}=          Get From Dictionary     ${result.json()}     cashAmount
    Set Suite variable           ${expected_cash_amount}

Get actual settlement date from screen
    ${actual_sttDate}=          Get_value_by_javascript        settlementDate
    ${actual_settlement_date}=                change_format_date      ${actual_sttDate}
    Set Suite variable         ${actual_settlement_date}

Settlement date "${actual_settlement_date}" show "${expected_settlement_date}"
    Should be equal     ${actual_settlement_date}     ${expected_settlement_date}


Call api get parti info "${partiID}"
    set to dictionary               ${get_parti_info_from_api}                 url=${url_web}
    ${get_parti_info_from_api}=    Get access token from "${web_login}" and set it in variable "${get_parti_info_from_api}" for authorization
#    ${access_token}=        Get From Dictionary     ${get_parti_info_from_api}       Authorization
    Set to dictionary       ${get_parti_info_from_api["params"]}    partiID=${partiID}
    ${result}=              Send get api            ${get_parti_info_from_api}
    ${parti}=                           Get From Dictionary     ${result.json()}     content
    [Return]                            ${parti}

Call api get ETF info "${etf_sym}"
    set to dictionary               ${get_etf_info_from_api}                 url=${url_web}
    ${get_etf_info_from_api}=       Get access token from "${web_login}" and set it in variable "${get_etf_info_from_api}" for authorization
    log             ${get_etf_info_from_api}
    Set to dictionary               ${get_etf_info_from_api["params"]}      securityAssetAbbr=${etf_sym}
    ${result}=                      Send get api            ${get_etf_info_from_api}
#    ${etf_info}=                    Get From Dictionary     ${result.json()}     content
    log many            ${result.content}
    [Return]                        ${result}

Get expected parti info "002"
    ${parti}=       Call api get parti info "002"
    ${parti_002}=      Create dictionary      parti_id=            parti_abbr=         parti_name_eng=
    ${parti_002.parti_id}=                  Get From Dictionary     ${parti}[0]     partiID
    ${parti_002.parti_abbr}=                Get From Dictionary     ${parti}[0]     partiAbbr
    ${parti_002.parti_name_eng}=            Get From Dictionary     ${parti}[0]     partiNameEng
    Set Suite variable           ${parti_002}

Get expected ETF symbol from api "some_comp"
    ${etf}=       Call api get ETF info "some_comp"
    ${etf_some_comp}=      Create dictionary      securityAssetAbbr=            isinCode=         securityNameEng=      cuShareQty=    securityAssetID=          registrarNameEng=
    ${dict_etf}=       Get From Dictionary    ${etf.json()}         content
    ${etf_some_comp.securityAssetAbbr}=       Get From Dictionary     ${dict_etf}[0]     securityAssetAbbr
    ${etf_some_comp.isinCode}=                Get From Dictionary     ${dict_etf}[0]     isinCode
    ${etf_some_comp.securityNameEng}=         Get From Dictionary     ${dict_etf}[0]     securityNameEng
    ${etf_some_comp.cuShareQty}=              Get From Dictionary     ${dict_etf}[0]     cuShareQty
    ${etf_some_comp.securityAssetID}=         Get From Dictionary     ${dict_etf}[0]     securityAssetID
    ${etf_some_comp.registrarNameEng}=        Get From Dictionary     ${dict_etf}[0]     registrarNameEng
    Set Suite variable             ${etf_some_comp}          #return ปรับ ให้เป็น

Call api get some_comp2 stock info
    set to dictionary               ${get_ul_some_comp2_from_api}                 url=${url_web}
    ${get_ul_some_comp2_from_api}=         Get access token from "${web_login}" and set it in variable "${get_ul_some_comp2_from_api}" for authorization
    ${date}=                        get_date_for_api
    set to dictionary               ${get_ul_some_comp2_from_api["params"]}    txnDate=${date}
    ${result}=                      Send get api                        ${get_ul_some_comp2_from_api}
    [Return]        ${result}

Get expected some_comp2 stock(TSD) from api
    ${ul}=              Call api get some_comp2 stock info
    ${ul_some_comp2}=          Create dictionary      securityAssetAbbr=            isinCode=         securityNameEng=
    ${dict_ul}=        Get From Dictionary    ${ul.json()}         content
    ${ul_some_comp2.securityAssetAbbr}=       Get From Dictionary     ${dict_ul}[0]     securityAssetAbbr
    ${ul_some_comp2.isinCode}=                Get From Dictionary     ${dict_ul}[0]     isinCode
    ${ul_some_comp2.securityNameEng}=         Get From Dictionary     ${dict_ul}[0]     securityNameEng
    Set Suite variable           ${ul_some_comp2}

System show etf table same as expected pdf data
    wait for loading data
    ${notMatch}=            Compare_ETF_table_with_expected_data      //table[@id='enquiry_table']           ${expected_pdf_data}       ${creat_redemp_volume_cu}       ${expected_etf_account}        ${expected_ul_account}   ${parti_011}
    Should Be Equal         ${notMatch}             ${0}

System show etf table same as expected pdf data of in cash
    wait for loading data
    ${notMatch}=    Compare_ETF_table_with_expected_data_incash      //table[@id='enquiry_table']           ${expected_pdf_data}       ${creat_redemp_volume_cu}       ${expected_etf_account}        ${expected_ul_account}   ${parti_011}
    Should Be Equal         ${notMatch}             ${0}

Get expected available issuing limit of "${etf}" from api
    set to dictionary               ${get_avail_from_api}                 url=${url_web}
    ${get_avail_sth_from_api}=    Get access token from "${web_login}" and set it in variable "${get_avail_from_api}" for authorization
    Set to dictionary               ${get_avail_from_api["params"]}    etfSecurityAssetID=${etf.securityAssetID}
    ${result}=      Send get api            ${get_avail_from_api}
    ${expected_avail_limit}=                 Get From Dictionary     ${result.json()}    availableIssuingLimitQty
    Set Suite variable                      ${expected_avail_limit}

Get expected pdf data of "${etf}" from api
    set to dictionary               ${get_pdf_data_from_api}                 url=${url_web}
    ${get_pdf_data_from_api}=       Get access token from "${web_login}" and set it in variable "${get_pdf_data_from_api}" for authorization
    ${date}=        get_date_for_api
    Set to dictionary    ${get_pdf_data_from_api["params"]}    txnDate=${date}
    Set to dictionary    ${get_pdf_data_from_api["params"]}    etfSecurityAssetID=${etf.securityAssetID}
    ${result}=      Send get api            ${get_pdf_data_from_api}
    ${expected_pdf_data}=          Get From Dictionary     ${result.json()}     content
    Set Suite variable           ${expected_pdf_data}

Settlement date show "${expected_settlement_date}"
    ${actual_sttDate}=          Get_value_by_javascript        settlementDate
    ${actual_settlement_date}=                change_format_date      ${actual_sttDate}
    Should be equal     ${actual_settlement_date}     ${expected_settlement_date}


