*** Settings ***
Library      ../../Keywords/Common/kw_approve_confirm.py

*** Keywords ***
Create another transaction for testing ETF "${etf_sym}"/in-kind/not-fully/"${cu}" CU
    Input ETF symbol "${etf_sym}"
    Select basket type: in kind
    Select underlying settlement status: not fully
    Input creation volumn "${cu}" cu

Create another redemption transaction for testing ETF "${etf_sym}"/in-kind/fully/"${cu}" CU
    Input ETF symbol "${etf_sym}"
    Select basket type: in kind
    Select underlying settlement status: fully
    Input redemption volume "${cu}" cu

Create another redemption transaction for testing ETF "${etf_sym}"/in-kind/"${cu}" CU
    Input ETF symbol "${etf_sym}"
    Select basket type: in kind
    Input redemption volume "${cu}" cu

Create another transaction for testing ETF "${etf_sym}"/in-cash/unitHolder"${unitholder}"/amount"${amount}"
    Input ETF symbol "${etf_sym}"
    Input unit holder id "${unitholder}" : in-cash
    Click search ETF button
    Click edit button at row "1"
    Edit 'amount' "${amount}"
    Click submit add/edit

Create another redemption transaction for testing ETF "${etf_sym}"/in-cash/unitHolder"${unitholder}"/amount"${amount}"
    Input ETF symbol "${etf_sym}"
    Click search ETF button
    Click edit button at row "1"
    Edit 'amount' "${amount}"
    Input unit holder id "${unitHolder}"
    Click submit add/edit

Create another redemption transaction for testing ETF "${etf_sym}"/in-cash/"${cu}" CU
    Input ETF symbol "${etf_sym}"
    Select basket type: in cash
    Input redemption volume "${cu}" cu

Create another redemption transaction for testing ETF "${etf_sym}"/in-cash
    Input ETF symbol "${etf_sym}"
    Select basket type: in cash
#    Input redemption volume "${cu}" cu

Create another transaction for testing ETF "${etf_sym}"/in-cash
    Input ETF symbol "${etf_sym}"
    Select basket type: in cash

Create another transaction for testing ETF "${etf_sym}"/in-kind/"${cu}" CU
    Input ETF symbol "${etf_sym}"
    Select basket type: in kind
    Input creation volumn "${cu}" cu

Sign out from current account
    wait for loading data
    Click_by_javascript                         signOut

Select Approve/reject menu
    Click_by_javascript                         Approve/RejectCreate

Select basket type for approve/reject: in kind
    Click_by_javascript               basketType-in-ind

Select basket type for approve/reject: in cash
    Click_by_javascript               basketType-in-cash

Select underlying settlement type for approve/reject: fully
    Click_by_javascript               underlyingSellement-fully

Select underlying settlement type for approve/reject: not fully
    wait for loading data
    Click_by_javascript               not-fully

Select underlying settlement type for approve/reject: decrease
    wait for loading data
    Click_by_javascript               decrease-etf

Click search button in approve/reject menu
    Click_by_javascript               btn-search

## Approve
Approve transaction of row "${row}"
    wait until element is not visible           id:msg
    ${table_row}=                               evaluate        ${row}-1
    Click_by_javascript                         checkbox_approve_${table_row}

Approve another transaction for testing at row "${row}"
    Click search button in approve/reject menu
    Approve transaction of row "${row}"
    Click submit button in approve/reject menu

Click submit button in approve/reject menu
    Click_by_javascript           btn-submit

Click close button of success popup message
    wait for loading data
    click button          xpath://button[@class="btn btn-success"]

Click close button of warning popup message
    wait for loading data
    click button          xpath://button[@class="btn btn-warning"]

##Reject
Reject transaction of row "${row}"
    wait until element is not visible           id:msg
    ${table_row}=                               evaluate        ${row}-1
    Click_by_javascript                         checkbox_reject_${table_row}

Input reason of rejection "${reason}" of row "${row}"
    ${table_row}=        evaluate        ${row}-1
    Input Text            id:reasonReject_${table_row}             ${reason}

System show popup warning to enter reason of rejection
    Page should contain element         //div[@class="modal-header bg-warning"]

Click close warning popup meassage
    wait for loading data
    wait until keyword succeeds     5x      4s      click element           //div[@class="modal-header bg-warning"]

##Confirm
Select Confirm/Reject manu
    Click_by_javascript           Confirm/RejectCreate

Input ETF Symbol "${etf_symb}" for confirming
#    click element       id:look-up-btn
    wait until page contains element                    id:securityAssetID
    input text                  id:securityAssetID      ${etf_symb}
    click element               id:isinCode
    wait for loading data

Input parti id "${parti_id}"
    Set_value_by_javascript         partiID                 ${EMPTY}
    input text                      xpath://input[@class="some-class-path"]              ${parti_id}
    click element                   id:asset-name
    wait for loading data

Click search button in confirm/reject menu
    Click_by_javascript           btn-search

Confirm transaction of row "${row}"
    wait until element is not visible           id:msg
    ${table_row}=                               evaluate        ${row}-1
    Click_by_javascript                         checkbox_approve_${table_row}

Click submit button in confirm/reject menu
    Click_by_javascript           btn-submit

####check status
System show status message successfully
    ${notMatch}=              approve_status              //table[@id='some_path']
    should be equal         ${notMatch}                 ${0}

#check_popup_message
System show pop-up message
    ${notMatch}=                check_popup_message
    wait until keyword succeeds     5x    4s    should be equal             ${notMatch}                 ${0}

