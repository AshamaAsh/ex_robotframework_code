*** Settings ***
Resource     ../../Keywords/Common/kw_common.robot
Resource     ../../Keywords/Common/kw_approve_confirm.robot
Resource     ../../Keywords/Creation/kw_create_common.robot
Resource     ../../Keywords/API/kw_common_api.robot
Variables    ../../Variables/Creation/var_creation_IC_AM.py
Library      ../../Keywords/Common/kw_common.py
Library      ../../Keywords/Creation/kw_create_common.py

Suite Setup         Run Keywords
...                 User enter to website "${url_web}"
...                 And Get expected settlement date from api
...                 And Get expected parti info "sth"
...                 And Get expected parti info "002"
...                 And Get expected ETF symbol from api "sth"
...                 And Get expected cash amount of "sth" from api
...                 And Get expected holder account from api
...                 And Get expected unit holder account from api: incash :AM as PD
Suite Teardown      Close All Browsers

*** Test Cases ***
AM entry user can search create in-cash creation #part1
    When Get expected available issuing limit of "${etf_sth}" from api
    And Get expected pdf data of "${etf_sth}" from api

    And User login with username "username" and "password"
    And Select ETF menu
    And Select creation and redemption menu
    And Select create creation and redemption
    Then Transaction date shows current date
    And Settlement date show "${expected_settlement_date}"

    When User choose transaction type : Creation
    Then PD/MM ID show "${parti_sth.parti_id}"
    And PD/MM short name show "${parti_sth.parti_abbr}"
    And PD/MM full name show "${parti_sth.parti_name_eng}"
    And ETF symbol/ISIN is empty

    When Input ETF Symbol "sth"
    Then ISIN code of ETF show "${etf_sth.isinCode}"
    And Security name of ETF show "${etf_sth.securityNameEng}"
    And Creation volume show as expected
    Then Cash amount show "${expected_cash_amount}"
    And ETF volume show as expected
    And Available reg issuing limit show "${expected_avail_limit}"

    When Input unit holder id "sth0001" : in-cash
    Then Unit holder flag show "${unit_holder_role_am.pcFlagDesc}"
    And Unit holder name show "${unit_holder_role_am.unitholderName}"

    When Click search ETF button
    And Change records per page to "15"
    Then System show etf table same as expected pdf data of in cash: AM as PD

AM entry user can 'edit' records of ETF:TSD
    When Click edit button at row "1"
    And Edit 'amount' "10000"
    And Click submit add/edit
    Then Amount of row "1" show "10,000.00"

##############################################################################################

AM entry user can 'add' ETF for in-cash creation: Units [Own account]
    When Click add button
    And Select underlying type : ETF
    And Input reference sequence no. "1D-units"
    Then ETF symbol show "${etf_sth.securityAssetAbbr}"
    And ISIN code of securities show "${etf_sth.isinCode}"
    And Full name of securities show "${etf_sth.securityNameEng}"
    And Amount field is disabled
    And To deliver field is disabled

    When Input 'to receive qty' "3000"
    And Parti ID show "${parti_sth.parti_id}"
    And Parti ID short name show "${parti_sth.parti_abbr}"
    And Parti ID full name show "${parti_sth.parti_name_eng}"
    And Deliver account no. is disabled
    And Input unit holder id "sth0001"
    Then Unit holder flag show "${unit_holder_role_am.pcFlagDesc}"
    And Unit holder account name show "${unit_holder_role_am.unitholderName}"
    And Brokerage a/c is disable
    And Ref. type is disable
    And Ref. no is disable
    And Nationality is disable
    And Account name show "${unit_holder_role_am.unitholderName}"

    When Click submit add/edit
    Then ETF table show ETF "sth" at row "2"

AM entry user can click back button #part2
    When Click add button
    And Click back button
    Then User can use back button
AM entry user can click reset button #part2
    When Click edit button at row "2"
    And Click reset button
    Then User can click reset successfully
    And Click back button
AM entry user can 'delete' records #part2
    When Click add button
    And Input reference sequence no. "test"
    And Input 'to receive qty' "1000000"
    And Input unit holder id "sth0001"
    And Click submit add/edit
    And Click delete at row "2"
    Then User can delete ETF "test" of row "2"

############################################################