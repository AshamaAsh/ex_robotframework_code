*** Settings ***
Resource     ../../Keywords/Creation/kw_create_common.robot
Resource     ../../Keywords/API/kw_common_api.robot
Resource     ../../Keywords/Common/kw_upload_common.robot
Resource     ../../Keywords/Common/kw_common.robot
Resource     ../../Keywords/Common/kw_approve_confirm.robot
Variables    ../../Variables/Creation/var_creation_upload_incash_AM.py
Library      ../../Keywords/Common/kw_common.py
Library      ../../Keywords/Creation/kw_create_common.py
Library      ../../Keywords/Common/kw_upload.py
Suite Setup         Run Keywords
...                 User enter to website "${url_web}"
...                 And Get expected account name of upload file from api
...                 And Get expected ETF symbol from api "sth"
...                 And Get expected parti info "sth"
...                 And Get expected parti info "002"
Suite Teardown      Close All Browsers

*** Test Cases ***
AM entry user can search ETF in-kind: fully [own account]
    When Get value from text file "file.txt" for "Creation"
    And User login with username "username" and "password"
    And Select ETF menu
    And Select creation and redemption menu
    And Select create creation and redemption

    And User choose transaction type : Creation
    And Input ETF symbol "sth"
    And Select basket type: in cash
    And Click search ETF button
    And Change records per page to "100"
    Then System show table after searching

AM entry user can upload file in-kind: single ETF [own account]
    When Upload file "file.txt" for "Creation" to website
    Then System show table as uploaded file of parti "sth" for in-cash

AM entry user can submit upload file in-kind: single ETF [own account]
    When Click submit after finishing
    Then System show popup success
    And Create date in popup success is current date
    And Click close success pop-up message
######################################################################################
AM entry user can search ETF in-kind: fully [other's PD account]
    When Get value from text file "file.txt" for "Creation"
    And User choose transaction type : Creation
    And Input ETF symbol "sth"
    And Select basket type: in cash
    And Click search ETF button
    And Change records per page to "100"
    Then System show table after searching

###########################################################
AM authorized user can approve transaction after create creation
    When Sign out from current account
    And User login with username "username" and "password"
    And Select ETF menu
    And Select creation and redemption menu
    And Select Approve/reject menu
    Then PD/MM ID show "${parti_sth.parti_id}"
    And PD/MM short name show "${parti_sth.parti_abbr}"
    And PD/MM full name show "${parti_sth.parti_name_eng}"

    When Input ETF symbol "sth"
    Then ISIN code of ETF show "${etf_sth.isinCode}"
    And Security name of ETF show "${etf_sth.securityNameEng}"

    When User choose transaction type : Creation
    And Select basket type for approve/reject: in cash
    And Click search button in approve/reject menu
    And Approve transaction of row "1"
    And Click submit button in approve/reject menu
    Then System show popup success
    And Click close button of success popup message
    And System show status message successfully

    When Approve another transaction for testing at row "1"
    Then System show popup success
    And Click close button of success popup message
    And System show status message successfully

AM authorized user cannot reject transaction after create creation
    When Click search button in approve/reject menu
    And Reject transaction of row "1"
    And Click submit button in approve/reject menu
    Then System show popup warning to enter reason of rejection
    And Click close button of warning popup message

AM authorized user can reject transaction after create creation
    When Click search button in approve/reject menu
    And Reject transaction of row "1"
    And Input reason of rejection "test" of row "1"
    And Click submit button in approve/reject menu
    Then System show popup success
    And Click close button of success popup message
    And System show status message successfully

###########################################################
AM authorized user can confirm transaction after approving
    When Select Confirm/Reject manu
    And Input ETF Symbol "sth" for confirming
    Then ISIN code of ETF show "${etf_sth.isinCode}"
    And Security name of ETF show "${etf_sth.securityNameEng}"

    When Input parti id "sth"
    Then PD/MM short name show "${parti_sth.parti_abbr}"
    And PD/MM full name show "${parti_sth.parti_name_eng}"

    When User choose transaction type : Creation
    And Select basket type for approve/reject: in cash
    And Click search button in confirm/reject menu
    And Confirm transaction of row "1"
    And Click submit button in confirm/reject menu
    And Click accept condition
    Then System show popup success
    And Click close button of success popup message
    And System show status message successfully

AM authorized user cannot reject transaction after approving
    When Click search button in confirm/reject menu
    And Reject transaction of row "1"
    And Click submit button in confirm/reject menu
    Then System show popup warning to enter reason of rejection
    And Click close button of warning popup message

AM authorized user can reject transaction after approving
    When Click search button in confirm/reject menu
    And Reject transaction of row "1"
    And Input reason of rejection "test" of row "1"
    And Click submit button in confirm/reject menu
    And Click accept condition
    Then System show popup success
    And Click close button of success popup message
    And System show status message successfully


