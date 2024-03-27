*** Settings ***
Resource     ../../Keywords/Creation/kw_create_common.robot
Resource     ../../Keywords/API/kw_common_api.robot
Resource     ../../Keywords/Common/kw_common.robot
Resource     ../../Keywords/Unit_holder/kw_unit_holder.robot
Resource     ../../Keywords/Common/kw_approve_confirm.robot
Variables    ../../Variables/Initiate/var_initiate.py
Variables    ../../Variables/Unit_holder/var_unit_holder_create.py
Library      ../../Keywords/Common/kw_common.py
Library      ../../Keywords/Initiate/kw_initiate.py
Library      ../../Keywords/Creation/kw_create_common.py

Suite Setup         Run Keywords
...                 User enter to website "${url_web}"
...                 And Get expected parti info "520"
...                 Generate random number
...                 And Dump generated number into file
...                 And Get number from file for unit holder id
Suite Teardown      Close Browser

*** Test Cases ***
AM entry user cannot create new unit holder: cannot select opposite sex with prefix
    When User login with username "username" and "password"
    And Select ETF menu
    And Select unit holder management menu
    And Select create unit holder
    Then AM ID show "${parti_520.parti_id}"
    And AM short name show "${parti_520.parti_abbr}"
    And AM full name show "${parti_520.parti_name_eng}"

    When Select reference type "0"
    And Input nationality code "000" for create unit holder
    And Input reference number "1123581347112"
    And Click create new unit holder
    And Click submit button unit holder management
    Then Transaction date shows current date
    And AM ID show "${parti_520.parti_id}"
    And AM short name show "${parti_520.parti_abbr}"
    And AM full name show "${parti_520.parti_name_eng}"
    And Reference type show "0"
    And Reference number show "0000234234255"
    And Nationality code of unit holder create is "000"
    And Input unit holder id "${number}" for creating unit holder account
    And Select pc flag: Port
    And Select shareholder type: "1"
    And Select gender: male
    And Input birth date "30/05/1999"
    And Input occupation code "920"

    And Get occupation code from api: holder type "1"
    And Check occupation with share holder type from api
    Then Official prefix not contain: นางสาว prefix

AM entry user cannot create new unit holder: cannot select juristic prefix with personal shareholder type
    When Official prefix not contain: "บริษัท" prefix

AM entry user cannot create new unit holder: Occupation not match with holder type
    When Select gender: female
    And Input occupation code "200"
    Then Occupation code should be empty
    And Get occupation code from api: holder type "1"
    And Check occupation with share holder type from api
    And Select official prefix: "น.ส."

AM entry user cannot create new unit holder: Required field official first name
    When Input occupation code "920"
    And Clear official first name text
    And Click submit create unit holder account
    Then System show pop-up message "Official First Name is required"
    And Click close warning pop-up message

AM entry user cannot create new unit holder: Required field official last name
    When Input official first name "firstname"
    And Clear official last name text
    And Input address "6/9"
    And Input country code "TH"
    And Input zip code "10900"
    And Select payment type: Cheque
    And Click submit create unit holder account
    Then System show pop-up message "Official Last Name is required field."
    And Click close error pop-up message

AM entry user cannot create new unit holder: Country not match with zip code
    When Input official last name "Dee"
    And Edit country "CA"
    And Edit zip code "10900"
    Then Country code is "TH"

AM entry user cannot create new unit holder: Bank code not match
    When Select payment type: Bank account
    And Input bank code "001"
    And Input bank account "12345"

    And Input re-type bank code "002"
    Then System show pop-up message "Bank code doesn't match"
    And Click close warning pop-up message
    When Clear bank code and re-type bank code

AM entry user cannot create new unit holder: Bank account not match
    When Input re-type bank code "001"
    And Input bank code "001"
    And Input bank account "12345678911"
    And Input re-type bank account "12345678910"
    Then System show pop-up message "Bank account doesn't match"
    And Click close warning pop-up message

AM entry user cannot create new unit holder: Bank account must be between 10 to 15 characters
    When Input re-type bank code "001"
    And Input bank code "001"
    And Input bank account "12345"
    And Input re-type bank account "12345"

    And Click submit create unit holder account
    Then System show pop-up message "Bank account must be between 10 to 15 characters"
    And Click close warning pop-up message

################################################################################

AM entry user can create new unit holder
    When Select payment type: Cheque
    And Click submit create unit holder account
    Then System show create unit holder account successfully "Create Transaction successfully, Please Approve."
    And Click close success pop-up message

################################################################################

AM entry user cannot create unit holder account: Duplicate unit holder id
    When Select reference type "0"
    And Input nationality code "000" for create unit holder
    And Input reference number "sth"
    And Click search existing unit holder account
    And Select existing unit holder account at row "1"
    And Click submit button unit holder management
    And Edit official first name "notMe"
    And Click submit create unit holder account
    Then System show pop-up message "Unit Holder ID already exist. Not allow to create a new Unit Holder."
    And Click close error pop-up message
    And Click back button from unit holder create
    And Sign out from current account

################################################################################

AM authorized user can approve creating unit holder account
    When User login with username "username" and "password"
    And Select ETF menu
    And Select unit holder management menu
    And Select approve unit holder menu
    And Input unit holder id "${number}" for approving
    And Select transaction type: approve create
    And Click search unit holder account

    And Select approve at row "1"
    And Click submit button unit holder management
    Then System show pop-up message
    And Click close success pop-up message
    And Sign out from current account

################################################################################

AM entry user can create new account by using data of existing account
    When User login with username "username" and "password"
    And Select ETF menu
    And Select unit holder management menu
    And Select create unit holder
    Then AM ID show "${parti_520.parti_id}"
    And AM short name show "${parti_520.parti_abbr}"
    And AM full name show "${parti_520.parti_name_eng}"

    When Select reference type "0"
    And Input nationality code "000" for create unit holder
    And Input reference number "sth"
    And Click search existing unit holder account
    And Select existing unit holder account at row "1"
    And Click submit button unit holder management

    And Generate random number
    And Dump generated number into file
    And Get number from file for unit holder id

    And Edit unit holder id "${number}"
    And Click submit create unit holder account
    Then System show create unit holder account successfully "Create Transaction successfully, Please Approve."
    And Click close success pop-up message
    And Sign out from current account

AM entry user can approve wanted unit holder account
    When User login with username "username" and "password"
    And Select ETF menu
    And Select unit holder management menu
    And Select approve unit holder menu
    And Input unit holder id "${number}" for approving
    And Select transaction type: approve edit
    And Click search unit holder account

    And Select approve at row "1"
    And Click submit button unit holder management
    Then System show pop-up message