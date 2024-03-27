*** Keywords ***
Click adjust unit holder menu
    click element       Adjust

Input ETF symbol "${etfSymbol}" for unit holder adjust
    input text              securityAssetID             ${etfSymbol}
    click element           isinCode

Search unit holder account for adjusting
    Click_by_javascript           btn-search

Get value of new value at row "${row}"
    ${new_balance}=         get_value_old_balance           //table[@id='enquiry_table']     ${unit_holder_adjust}
    set suite variable      ${new_balance}

Get value of old value at row "${row}"
    ${old_balance}=         get value           shareQty_0
    set suite variable      ${old_balance}

Old outs. balance of row "${row}" is "${expected_oldBalance}"
    ${table_row}=                   evaluate                ${row}-1
    ${actual_old_balance}=          get text                shareQty_${table_row}
    ${expected_old_balance}=        convert_format          ${expected_oldBalance}
    should be equal             ${actual_old_balance}       ${expected_old_balance}

Edit new outs. balance "${newValue}" at row "${row}"
#    ${new_balance}=         get_value_old_balance           //table[@id='enquiry_table']     ${unit_holder_adjust}
    ${table_row}=           evaluate        ${row}-1
    clear element text                      newShareQty_${table_row}
    input text                              newShareQty_${table_row}            ${newValue}
#    set suite variable                      ${new_balance}

Select adjust balance at row "${row}"
    ${table_row}=           evaluate        ${row}-1
    Click_by_javascript                     checkbox_approve_${table_row}

System show table from api
    ${notMatch}=       compare_table_unit_holder_with_api          //table[@id='enquiry_table']        ${unit_holder_adjust}
    Should Be Equal         ${notMatch}             ${0}

Click submit for adjusting unit holder
    click element       btn-submit

Click approve/reject adjust unit holder balance menu
    click element       Approve/Reject

###api unit holder adjust
Call api get unit holder account for adjusting info "${etfID}"
    set to dictionary               ${get_unit_holder_account_inquiry_adjust}                 url=${url_web}
    ${get_unit_holder_account_inquiry_adjust}=    Get access token from "${web_login}" and set it in variable "${get_unit_holder_account_inquiry_adjust}" for authorization
#    ${access_token}=        Get From Dictionary     ${get_parti_info_from_api}       Authorization
    Set to dictionary               ${get_unit_holder_account_inquiry_adjust["params"]}    etfSecurityAssetID=${etfID}
    ${result}=                      Send get api                ${get_unit_holder_account_inquiry_adjust}
    ${unit_holder_adjust}=          Get From Dictionary         ${result.json()}     content
    [Return]                        ${unit_holder_adjust}
    set suite variable              ${unit_holder_adjust}

Get adjust unit holder account inquiry
    ${unit_holder_api}=     Call api get unit holder account for adjusting info ""
    ${unit_holder}=             Create dictionary      unitHolderId=            etfSymbol=         etfIsinCode=      registarAbbr=    referenceNo=     oldShareQty=     newShareQty=     toReceiveQty=    toDeliverQty=
#    ${dict_unit_holder}=        Get From Dictionary    ${unit_holder_api.json()}         content
    ${unit_holder.unitHolderId}=            Get From Dictionary     ${unit_holder_api}[0]     unitHolderId
    ${unit_holder.etfSymbol}=               Get From Dictionary     ${unit_holder_api}[0]     etfSymbol
    ${unit_holder.etfIsinCode}=             Get From Dictionary     ${unit_holder_api}[0]     etfIsinCode
    ${unit_holder.registarAbbr}=            Get From Dictionary     ${unit_holder_api}[0]     registarAbbr
    ${unit_holder.referenceNo}=             Get From Dictionary     ${unit_holder_api}[0]     referenceNo
    ${unit_holder.oldShareQty}=             Get From Dictionary     ${unit_holder_api}[0]     oldShareQty
    ${unit_holder.newShareQty}=             Get From Dictionary     ${unit_holder_api}[0]     newShareQty
    ${unit_holder.toReceiveQty}=            Get From Dictionary     ${unit_holder_api}[0]     toReceiveQty
    ${unit_holder.toDeliverQty}=            Get From Dictionary     ${unit_holder_api}[0]     toDeliverQty
    Set Suite variable             ${unit_holder}

Call api get unit holder account inquiry for adjusting info "${etfID}"
    set to dictionary               ${get_unit_holder_account_inquiry}                 url=${url_web}
    ${get_unit_holder_account_inquiry}=    Get access token from "${web_login}" and set it in variable "${get_unit_holder_account_inquiry}" for authorization
#    ${access_token}=        Get From Dictionary     ${get_parti_info_from_api}       Authorization
    Set to dictionary               ${get_unit_holder_account_inquiry["params"]}    etfSecurityAssetID=${etfID}
    ${date}=        get_date_for_api
    Set to dictionary               ${get_unit_holder_account_inquiry["params"]}    txnDate=${date}
    ${result}=                      Send get api                ${get_unit_holder_account_inquiry}
    ${unit_holder_inquiry}=          Get From Dictionary         ${result.json()}     content
    [Return]                        ${unit_holder_inquiry}
    set suite variable              ${unit_holder_inquiry}

Get adjust unit holder balance inquiry
    ${unit_holder_api}=     Call api get unit holder account inquiry for adjusting info "2348"
    ${unit_holder_balance}=             Create dictionary      unitHolderId=            etfSymbol=         etfIsinCode=      registarAbbr=     shareQty=
#    ${dict_unit_holder}=        Get From Dictionary    ${unit_holder_api.json()}         content
    ${unit_holder_balance.unitHolderId}=            Get From Dictionary     ${unit_holder_api}[0]     unitHolderId
    ${unit_holder_balance.etfSymbol}=               Get From Dictionary     ${unit_holder_api}[0]     etfSymbol
    ${unit_holder_balance.etfIsinCode}=             Get From Dictionary     ${unit_holder_api}[0]     etfIsinCode
    ${unit_holder_balance.registarAbbr}=            Get From Dictionary     ${unit_holder_api}[0]     registarAbbr
    ${unit_holder_balance.shareQty}=                Get From Dictionary     ${unit_holder_api}[0]     shareQty
    log     ${unit_holder_balance}
    Set Suite variable             ${unit_holder_balance}
#
###check status message
System show status message Fail:pending approve
    ${status}=              get text             statusMessage_0
    log     ${status}
    should be equal         ${status}             Failed : Exists pending adjustment, please approve/reject pending adjustment.

####unit holding balance
Click unit holder balance menu
    Click_by_javascript           UnitHoldingBalance

Search unit holder balance for checking balance
    wait until keyword succeeds     5x  4s      Click_by_javascript           btn-search









