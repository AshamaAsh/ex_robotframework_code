*** Settings ***
Resource     ../../Keywords/Creation/kw_create_common.robot
Resource     ../../Keywords/API/kw_common_api.robot
Resource     ../../Keywords/Common/kw_common.robot
Resource     ../../Keywords/Initiate/kw_initiate.robot
Resource     ../../Keywords/Common/kw_approve_confirm.robot
Variables    ../../Variables/Initiate/var_initiate.py
Library      ../../Keywords/Common/kw_common.py
Library      ../../Keywords/Initiate/kw_initiate.py
Library      ../../Keywords/Creation/kw_create_common.py

Suite Setup         Run Keywords
...                 And User enter to website "${url_web}"
...                 And Get expected settlement date from api
...                 And Get expected parti info "sth"
...                 And Get expected ETF symbol from api "sth"
...                 And Get expected ETF account from api
...                 And Get expected UL account from api
Suite Teardown      Close All Browsers

*** Test Cases ***
PD entry user can search create creation in-kind: Deposited fully
    When Get value from text file "sth_sth.txt" for "Initiate"
    And User login with username "username" and "password"
    And Select ETF menu
    And Select creation and redemption menu
    And Select upload initiate ssettlement menu

    Then PD/MM ID show "${parti_sth.parti_id}"
    And PD/MM short name show "${parti_sth.parti_abbr}"
    And PD/MM full name show "${parti_sth.parti_name_eng}"

    When Input ETF symbol "sth"
    Then ISIN code of ETF show "${etf_sth.isinCode}"
    And Security name of ETF show "${etf_sth.securityNameEng}"
    And Registrar name show "${etf_sth.registrarNameEng}"
    And Click search button of upload initiate

    When Select edit for upload initiate settlement of row "1"
    Then Transaction date shows current date
    And Settlement date show "${expected_settlement_date}"
    And PD/MM ID show "${parti_sth.parti_id}"
    And PD/MM short name show "${parti_sth.parti_abbr}"
    And PD/MM full name show "${parti_sth.parti_name_eng}"

    And Registrar name show "${etf_sth.registrarNameEng}"
    And Creation volume show as expected
    And ETF Volume show "${etf_sth.cuShareQty}"

PD entry user can upload initiate file: own account
    When Upload initiate file "sth_sth.txt" from "Initiate" to website
    Then System show table of upload initiate as expected of parti "sth"

    When Click submit upload initiate file
    Then System show pop up message: upload initiate file successfully
    And Click close button of success popup message
    And Select edit for upload initiate settlement of row "1"
    And Upload initiate file "sth_sth.txt" from "Initiate" to website
    And Click submit upload initiate file
    Then System show pop up message: upload initiate file successfully
    And Click close button of success popup message
    And Sign out from current account

##############################################################################

PD authorized user can approve for upload initiate
    When User login with username "username" and "password"
    And Select ETF menu
    And Select creation and redemption menu
    And Click approve/reject initiate settlement menu

    Then PD/MM ID show "${parti_sth.parti_id}"
    And PD/MM short name show "${parti_sth.parti_abbr}"
    And PD/MM full name show "${parti_sth.parti_name_eng}"

    When Input ETF symbol "sth"
    Then ISIN code of ETF show "${etf_sth.isinCode}"
    And Security name of ETF show "${etf_sth.securityNameEng}"
    And Registrar name of approve initiate show "${etf_sth.registrarNameEng}"

    When Click search button of approve/reject initiate
    And Approve transaction of row "1"
    And Click submit for aprrove/reject upload initiate
    Then System show popup success
    And Click close button of success popup message
    And System show status message successfully

PD authorized user cannot reject for upload initiate without reason
    When Click search button of approve/reject initiate
    And Reject transaction of row "1"
    And Click submit for aprrove/reject upload initiate
    Then System show popup warning to enter reason of rejection
    And Click close button of warning popup message

PD authorized user can reject for upload initiate with reason
    When Click search button of approve/reject initiate
    And Reject transaction of row "1"
    And Input reason of rejection "test" of row "1"
    And Click submit for aprrove/reject upload initiate
    Then System show popup success
    And Click close button of success popup message
    And System show status message successfully





