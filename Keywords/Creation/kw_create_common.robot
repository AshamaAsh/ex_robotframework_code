*** Keywords ***
User choose transaction type : Redemption
    click element           id:txnType_RD

User choose transaction type : Creation
    click element           id:txnType_CR

ETF symbol/ISIN is empty
    ${etf_sym}=         get value           id:securityAssetID
    should be empty     ${etf_sym}
    ${isin}=            get value           id:isinCode
    should be empty     ${isin}

Input ETF Symbol "${etf_symb}"
#    click element       id:look-up-btn
    wait until page contains element         id:securityAssetID
    input text          id:securityAssetID      ${etf_symb}
    click element       id:isinCode
    wait for loading page

ISIN code of ETF show "${expected_etf_isin}"
    ${etf_isin}=        wait until keyword succeeds     5x  4s      get value           id:isinCode
    ${actual_etf_isin}=           strip string        ${etf_isin}
    should be equal         ${actual_etf_isin}             ${expected_etf_isin}

Security name of ETF show "${expected_etf_full_name}"
    ${etf_security}=                  get value           id:securityNameEng
    ${actual_etf_security}=           strip string        ${etf_security}
    should be equal         ${actual_etf_security}        ${expected_etf_full_name}

Select underlying settlement status: not fully
    wait for loading data
    Click_by_javascript         not-fully

Creation volume show as expected
    ${creation_volume}=                 get value                           id:cuQty
    ${creat_redemp_volume_cu}=          Convert_cu_format                   ${creation_volume}
    ${expected_cu_volume_decimal}=      compare_cu_format_10decimal         ${creation_volume}
    log         ${expected_cu_volume_decimal}
    should be equal                     ${creation_volume}                  ${expected_cu_volume_decimal}
    set suite variable                  ${creat_redemp_volume_cu}

Input creation volumn "${cu}" cu
    Set_value_by_javascript          cuQty              ${EMPTY}
    input text                       cuQty              ${cu}
    click element                    cashAmt

Cash amount is disable
    element should be disabled          id:cashAmt

Cash amount show "${expected_cash_amount}"
    ${actual_cash_amount}=                  get value                        id:cashAmt
    ${cash_amount}=                         EVALUATE                         ${expected_cash_amount}*${creat_redemp_volume_cu}
    ${expected_cash_amount}=                Convert_cash_amount_format       ${cash_amount}
    should be equal                         ${actual_cash_amount}            ${expected_cash_amount}

ETF volume show as expected
    ${etf_vol}=                     get value                   id:etfVolume
    ${etf_volume}=                  Convert_cu_format           ${etf_vol}
    should be equal as numbers      ${etf_vol}      0

ETF Volume show "${etf_sth.cuShareQty}"
    ${etf_vol}=                 get value                   id:etfVolume
    ${expected_etf_vol}=        EVALUATE                    ${etf_sth.cuShareQty}*${creat_redemp_volume_cu}
    ${expected_etf_vol}=        Convert_volume_format       ${expected_etf_vol}
    should be equal             ${etf_vol}                  ${expected_etf_vol}

Available reg issuing limit show "${expected_avail_limit}"
    ${availableReg}=                      get value                   id:availableIssuingLimitQty
    ${expected_avail_reg_limit}=          Convert_volume_format       ${expected_avail_limit}
    should not be empty                   ${availableReg}             ${expected_avail_reg_limit}

ETF account no. show "${expected_etf_account.acc_no}"
    ${accountNo}=                   get value               id:accountNo_label.account-etf
    ${actual_account_no}=           strip string            ${accountNo}
    should be equal                 ${actual_account_no}    ${expected_etf_account.acc_no}
ETF account flag show "${expected_etf_account.acc_flag}"
    ${accountFlag}=                  get value                 id:pcFlagDesc_label.account-etf
    ${actual_account_flag}=          strip string              ${accountFlag}
    should be equal                  ${actual_account_flag}    ${expected_etf_account.acc_flag}
ETF account name show "${expected_etf_account.acc_name}"
    ${accountName}=                  get value                       id:accountName_label.account-etf
    ${actual_account_name}=          strip string                    ${accountName}
    should be equal                  ${actual_account_name}          ${expected_etf_account.acc_name}

UL account no. show "${expected_ul_account.acc_no}"
    ${accountNo}=                   get value               id:accountNo_label.u/l
    ${actual_account_no}=           strip string            ${accountNo}
    should be equal                 ${actual_account_no}    ${expected_ul_account.acc_no}

Click search ETF button
    Click_by_javascript                         searchBtn

Change records per page to "${records}"
    clear element text          id:recordsPage
    input text                  id:recordsPage                 ${records}

System show table after searching
    wait until keyword succeeds     5x      4s      Page Should Contain Element         enquiry_table

## add/edit ##
Click add button
    click element       id:btn-add
    wait for loading page

Click edit button at row "${row}"
    ${table_row}=        evaluate        ${row}-1
    Click_by_javascript         edit_${table_row}
    wait for loading page

Select underlying type : ETF
    click element       id:underlyingType_E
    wait for loading data

Input reference sequence no. "${ref_seqNO}"
    input text          id:referenceSeqNo      ${ref_seqNO}

Reference sequence no. must be "${refSeq}"
    ${referenceSeqNo}=      get value               id:referenceSeqNo
    should be equal         ${referenceSeqNo}       ${refSeq}

Full name of securities show "${etf_sth.securityNameEng}"
    ${full_name}=             get value               id:securityNameEng
    ${actual_full_name}=      strip string            ${full_name}
    log              ${actual_full_name}
    should be equal         ${actual_full_name}       ${etf_sth.securityNameEng}

Select deliver type: Units
    click element       id:deliverType_UN

Select deliver type: Cash
    Click_by_javascript             deliverType_CA

Input 'amount' "${amount}"
    Set_value_by_javascript         amount          ${EMPTY}
    input text                      id:amount       ${amount}

Edit 'amount' "${amount}"
    Set_value_by_javascript         amount          ${EMPTY}
    input text                      id:amount       ${amount}

Amount field is disabled
    element should be disabled          id:amount

Input 'to deliver' "${toDeliver}"
    Set_value_by_javascript         toDeliverQty          ${EMPTY}
    input text                  id:toDeliverQty         ${toDeliver}

Edit 'to deliver' "${toDeliver}"
    wait until page contains element        id:toDeliverQty
    Set_value_by_javascript         toDeliverQty          ${EMPTY}
    input text                  id:toDeliverQty         ${toDeliver}

To deliver field is disabled
    element should be disabled          id:toDeliverQty

Input 'to receive qty' "${toReceive}"
    Set_value_by_javascript         toReceiveQty          ${EMPTY}
    input text                      id:toReceiveQty     ${toReceive}

To receive field is disabled
    element should be disabled          id:toReceiveQty

Edit 'to receive' "${toReceive}"
    Set_value_by_javascript         toReceiveQty          ${EMPTY}
    input text                  id:toReceiveQty         ${toReceive}

Edit parti ID : another AM "${partiID}" : account type C
    Set_value_by_javascript         partiID        ${EMPTY}
    input text                      id:partiID             ${partiID}
    click element                   id:asset-name
    wait for loading page

Edit parti ID : another broker "${partiID}" : account type B
    Set_value_by_javascript         partiID          ${EMPTY}
    input text                      id:partiID          ${partiID}
    click element                   id:asset-name
    wait for loading page

Parti ID show "${expected_parti_id}"
    ${asset-id}=                        get value               id:partiID
    ${parti}=                           strip string            ${asset-id}
    should be equal                     ${parti}                ${expected_parti_id}
    wait for loading page

Parti ID short name show "${expected_parti_short_name}"
    ${asset-shortname}=                 get value               id:asset-name
    ${shortname}=                       strip string            ${asset-shortname}
    should be equal                     ${shortname}                ${expected_parti_short_name}

Parti ID full name show "${expected_parti_full_name}"
    ${asset-fullname}=                  get value               id:asset-name-full
    ${fullname}=                        strip string            ${asset-fullname}
    should be equal                     ${fullname}                ${expected_parti_full_name}

Deliver account no. show "${expected_etf_account.acc_no}"
    ${accountNo_label.account-no}=      get value                   id:accountNo_label.account-no
    ${actual_account_name}=             strip string                ${accountNo_label.account-no}
    should be equal                     ${actual_account_name}       ${expected_etf_account.acc_no}

Deliver account flag show "${expected_etf_account.acc_flag}"
    ${deliver_acc_flag}=            get value                               id:pcFlagDesc_label.account-no
    ${actual_deliver_acc_flag}=     strip string                            ${deliver_acc_flag}
    should be equal                 ${actual_deliver_acc_flag}              ${expected_etf_account.acc_flag}

Deliver account full name show "${expected_etf_account.acc_name}"
    ${deliver_acc_full}=            get value                       id:accountName_label.account-no
    ${actual_deliver_acc_full}=     strip string                    ${deliver_acc_full}
    should be equal                 ${actual_deliver_acc_full}      ${expected_etf_account.acc_name}

Deliver account no. is disabled
    wait for loading data
    element should be disabled          id:accountNo_label.account-no

Deliver account flag is disabled
    element should be disabled          id:pcFlagDesc_label.account-no

Deliver account full name is disabled
    element should be disabled          id:accountName_label.account-no

Input unit holder id "${unitHolder}"
    input text          id:unitHolderID         ${unitHolder}
    click element       id:brokerageAccountID

Input unit holder id "${unitHolder}" : in-cash
    input text          id:unitHolderID         ${unitHolder}
    click element       id:unitHolderFlag

Unit holder id show "${expected_unit_holder}"
    ${unitHolderId}=             get value              id:unitHolderID
    ${actual_unitHolder}=        strip string           ${unitHolderId}
    should be equal              ${actual_unitHolder}   ${expected_unit_holder}

Unit holder flag show "${expected_unit_holder}"
    ${unitHolderFlag}=              get value              id:unitHolderFlag
    ${actual_unitHolder}=           strip string           ${unitHolderFlag}
    should be equal                 ${actual_unitHolder}       ${expected_unit_holder}

Unit holder name show "${expected_unit_holder}"
    ${unitHolderFlag}=              get value              id:unitHolderName
    ${actual_unitHolder}=           strip string           ${unitHolderFlag}
    should be equal                 ${actual_unitHolder}       ${expected_unit_holder}

Unit holder ID is disable
    element should be disabled          id:unitHolderID

Unit holder ID is blank
    ${unitHolder}=                  get value                   id:unitHolderID
    ${actual_unitHolder}=           strip string                ${unitHolder}
    should be empty                 ${actual_unitHolder}

Brokerage a/c is disable
    element should be disabled          id:brokerageAccountID

Ref. type is disable
    element should be disabled          id:referenceTypeID

Ref. no is disable
    element should be disabled          id:referenceNo

Nationality is disable
    element should be disabled          id:nationalityCode
    wait for loading page

Input brokerage a/c "${brkAC}"
    input text          id:brokerageAccountID          ${brkAC}

Select ref. type "0-เลขประจำตัวประชาชนในประเทศ"
    click element           id:refType-0
    wait for loading data

Select ref. type "1-เลขประจำตัวประชาชนต่างประเทศ"
    click element           id:refType-1
    wait for loading data

Select ref. type "2-เลขที่ใบต่างด้าว "
    click element           id:

Select ref. type "3-เลขที่ PASSPORT"
    click element           id:refType-3
    wait for loading data

Input ref. no. "${refNo}"
    input text          id:referenceNo          ${refNo}

Input nationality code "${nation}"
    input text          id:nationalityCode      ${nation}
    click element       referenceNo
    wait for loading page

Brokerage a/c is "${brokerage}"
    ${brokerageNo}=                   get value             id:brokerageAccountID
    ${broker_no}=                   strip string             ${brokerage}
    should be equal                 ${broker_no}            ${brokerage}

Ref. type is "${ref_type}"
    ${refType}=                     get value               id:referenceTypeID
    ${actual_ref_type}=             strip string            ${refType}
    should be equal                 ${actual_ref_type}      ${ref_type}

Ref. no. is "${expected_ref_no}"
    ${refNumber}=                   get value           id:referenceNo
    ${actual_ref_no}=               strip string        ${refNumber}
    should be equal                 ${actual_ref_no}    ${expected_ref_no}

Nationality is "${expected_nation}"
    ${nationality}=                 get value           id:nationalityDesc
    ${actual_nation}=               strip string        ${nationality}
    should be equal                 ${actual_nation}    ${expected_nation}

Nationality code is "${expected_nation}"
    ${nationality}=                 get value                   nationalityCode
    ${actual_nation_code}=          strip string                ${nationality}
    should be equal                 ${actual_nation_code}       ${expected_nation}

Account name show "${expected_account}"
    wait for loading data
    ${accountName}=          wait until keyword succeeds    5x  4s     get value               id:accountName
    ${actual_acc_name}=             strip string            ${accountName}
    should be equal                 ${actual_acc_name}      ${expected_account}

Holder account name show "${dict_holder_acc}"
    ${accountName}=         wait until keyword succeeds     5x    4s      get value               id:accountName
    ${actual_acc_name}=             strip string            ${accountName}
    should be equal                 ${actual_acc_name}      ${dict_holder_acc}

Unit holder account name show "${expected_unitHolder_name}"
    ${unit_holder_name}=      wait until keyword succeeds       5x   4s    get value               id:accountName
    ${actual_unit_holder}=          strip string            ${unit_holder_name}
    should be equal                 ${actual_unit_holder}   ${expected_unitHolder_name}
#    Wait Until Keyword Succeeds

Click submit add/edit
#    wait until page contains element        id:btn-submit
    Wait for loading page
    Click_by_javascript                     btn-submit
    Wait for loading page

ETF table show ETF "${etf}" at row "${row}"
    ${table_row}=           evaluate            ${row}-1
    ${securities_row1}=      get text          id:securityAssetAbbr_${table_row}
#    ${security}=             strip string       ${securities_row1}
    should be equal          ${securities_row1}        ${etf}

ETF table show UL "${etf}" at row "${row}"
    ${table_row}=           evaluate            ${row}-1
    ${securities_row1}=      get text          id:securityAssetAbbr_${table_row}
#    ${security}=             strip string       ${securities_row1}
    should be equal          ${securities_row1}        ${etf}

To receive of row "${row}" show "${toReceive}"
#    Element Text Should Be          xpath://table/tbody/tr[${row}]/td[6]/div         ${toReceive}
    ${table_row}=        evaluate        ${row}-1
    Element Text Should Be          id:toReceiveQty_${table_row}         ${toReceive}

To deliver of row "${row}" show "${toDeliver}"
    wait for loading data
    Element Text Should Be          xpath://table/tbody/tr[${row}]/td[5]/div         ${toDeliver}

Amount of row "${row}" show "${amount}"
    wait for loading data
    ${amount_row}=                   evaluate                            ${row}-1
    Element Text Should Be          id:amount_${amount_row}              ${amount}

Account no. in table of row "${row}" show "${expected}"
    ${table_row}=                   evaluate        ${row}-1
    Element Text Should Be          id:accountNo_${table_row}         ${expected}

Deliver type in table of row "${row}" show "${expected}"
    ${table_row}=                   evaluate        ${row}-1
    ${table}=                       get value       id:deliverType_${table_row}
    should be equal                 ${table}        ${expected}

System show popup success
    Page should contain element         //div[@class="modal-header bg-success"]


Create date in popup success is current date
    wait for loading page
    ${success_message}=     Get text            //app-modal-content/div[@class="modal-body ml-5 pt-5"]/p
    ${actual_create_date}=     Get Substring           ${success_message}              -10
    ${current_date}=        get_date_time
    Should be equal         ${actual_create_date}       ${current_date}

Click submit after finishing
    wait for loading page
    Click_by_javascript           submitBtn


Click close success pop-up message
#    Wait Until Keyword Succeeds  5x     10s      Click_by_javascript           closeBtn
    Wait Until Keyword Succeeds  5x     10s      click element           closeBtn
    wait for loading data

Close button disappear
    wait until element is not visible        id:closeBtn      ##kw_then

### button ###
Click back button
    Click_by_javascript            btn-back

User can use back button
    page should contain element         id:submitBtn

Click reset button
    click element           id:btn-reset

User can click reset successfully
    ${refNo}=           get value       id:referenceSeqNo
    should be empty     ${refNo}
    ${acc-no}=          get value       id:accountNo_label.account-no
    should be equal     ${acc-no}     ${empty}

Click delete at row "${row}"
    ${table_row}=           evaluate            ${row}-1
    Click_by_javascript     delete_${table_row}

User can delete ETF "${etf}" after delete row "${row}"
    ${table_row}=           evaluate            ${row}-1
    ${securities_row1}=      get text          id:securityAssetAbbr_${table_row}
    should not be equal         ${etf}          ${securities_row1}

User can delete ETF "${test}" of row "${row}"
    ${table_row}=           evaluate            ${row}-1
    ${text_row}=            get text          id:referenceSeqNo_${table_row}
    should not be equal         ${test}          ${text_row}

####edit creation
Click upload create menu
    click element               UploadCreate

Upload creation file (header) "${filename}" for "${folder_name}"
    ${normal_path}=                         Normalize Path          ${CURDIR}//..//..//Upload//${folder_name}//${file_name}
    wait until keyword succeeds     5x  4s      Choose file         id:fusk                 ${normal_path}
#    wait for loading page
