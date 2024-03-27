*** Settings ***
Library         kw_unit_holder.py

*** Keywords ***
Generate random number
    [Tags]      run
    ${numbers}=     Evaluate                random.sample(range(1, 10000000000), 1)    random
    ${PO_Number}    Generate random string    10    0123456789
    Set Global Variable       ${PO_Number}

Dump generated number into file
    Dump_Variable_To_File          ${PO_Number}        random_unit_holder_id.txt

Get number from file for unit holder id
    ${number}=                  Load_Variable_From_File     random_unit_holder_id.txt
    set suite variable          ${number}

Select unit holder management menu
    click element           GUNH001menu

Select create unit holder
    click element           id:Create

Select reference type "${refType}"
    click element           refType-${refType}

Input nationality code "${nationality}" for create unit holder
    input text              nationalityCode             ${nationality}
    click element           nationalityDesc

Input reference number "${refNo}"
    input text              referenceNo                 ${refNo}
    click element           nationalityDesc

Click create new unit holder
    click element           //input[@type="checkbox"]

Click submit button unit holder management
    Click_by_javascript           btn-submit
    wait for loading page

AM ID show "${expectes_amID}"
    ${amID}=            get value           AMpartiID
    ${actual_amId}=     strip string        ${amID}
    should be equal     ${actual_amId}      ${expectes_amID}

AM short name show "${expectes_amShort_name}"
    ${am_shortName}=            get value                   AMasset-name
    ${actual_am_shortName}=     strip string                ${am_shortName}
    should be equal             ${actual_am_shortName}      ${expectes_amShort_name}

AM full name show "${expectes_am_fullName}"
    ${am_fullName}=             get value                   AMasset-name-full
    ${actual_am_fullName}=      strip string                ${am_fullName}
    should be equal             ${actual_am_fullName}       ${expectes_am_fullName}

Reference type show "${expected_ref_type}"
    ${refType}=                     get value               referenceType
    ${actual_ref_type}=             strip string            ${refType}
    should be equal                 ${actual_ref_type}      ${expected_ref_type}

Reference number show "${expected_ref_no}"
    ${refNo}=                       get value               referenceNo
    ${actual_ref_no}=               strip string            ${refNo}
    should be equal                 ${actual_ref_no}        ${expected_ref_no}

Nationality code of unit holder create is "${expected_nationalCode}"
    ${national_code}=            get value                      nationalityCode
    ${actual_nationalCode}=     strip string                    ${nationalCode}
    should be equal             ${actual_nationalCode}          ${expected_nationalCode}

Input unit holder id "${unitholder}" for creating unit holder account
    input text              unitHolder              ${unitholder}

Select pc flag: Port
    click element            //select[@id="pcFlag"]/option[@value="P"]

Select pc flag: Client
    click element           //select[@id="pcFlag"]/option[@value="C"]

Select shareholder type: "${shareholderType}"
#    click element          //select[@id="holderTypeId"]/option[@value="${shareholderType}"]
    click element           holderTypeId-${shareholderType}

Select gender: male
#    click element               //select[@id="sexType"]/option[@value="0"]
    click element               sexType-0

Select gender: female
    sleep   1s
    click element                                 sexType-1
#    Click_by_javascript                           sexType-1

Select gender: juristic
#    click element               //select[@id="sexType"]/option[@value="1"]
    click element               sexType-2

Input birth date "${birthDate}"
    Set_value_by_javascript         birthDate          ${EMPTY}
    input text                      birthDate          ${birthDate}

Occupation code should be empty
    ${occupation}=          get value        occupationCode
    should be empty         ${occupation}

Input occupation code "${actual_occupationCode}"
    input text          occupationCode              ${actual_occupationCode}
    click element       occupationDesc
    log                     ${actual_occupationCode}
    set suite variable      ${actual_occupationCode}

Select official prefix: "${prefix}"
#    wait for loading page
    wait until keyword succeeds     5x  4s      click element       //select[@id="officialSysPrefixId"]/option[text()=" ${prefix} "]

Select official prefix: นาย
    click element       officialSysPrefixId-15

Select official prefix: นาง
    click element       officialSysPrefixId-16

Select official prefix: นางสาว
    wait until element is visible           officialSysPrefixId-17
    click element                           officialSysPrefixId-17

Official prefix not contain: นางสาว prefix
    page should not contain element         officialSysPrefixId-17

Official prefix not contain: นาย prefix
    page should not contain element         officialSysPrefixId-15

Official prefix not contain: "${prefix}" prefix
    page should not contain element         //select[@id="officialSysPrefixId"]/option[text()=" ${prefix} "]

Input official first name "${name}"
    input text          officialFirstName           ${name}

Input official last name "${lastName}"
    input text          officialLastName            ${lastName}

Edit official first name "${firstName}"
    Set_value_by_javascript         officialFirstName               ${EMPTY}
    input text                      officialFirstName               ${firstName}

Clear official first name text
    clear element text               officialFirstName
    Press Key                       officialFirstName                ${SPACE}
    click element                   officialLastName
    sleep   2s

Clear official last name text
    clear element text              officialLastName
    Press Key                       officialLastName                ${SPACE}

Input address "${address}"
    input text          address                     ${address}

Input country code "${countryCode}"
    input text          countryCode                 ${countryCode}
    click element       countryName

Input zip code "${zipCode}"
    input text              zipCode                 ${zipCode}
    click element           districtName

Select payment type: Cheque
    click element           //select[@id="paymentType"]/option[@value="0"]

Select payment type: Bank account
    click element           //select[@id="paymentType"]/option[@value="1"]

Click submit create unit holder account
    Click_by_javascript           btn-submit

System show pop-up message "${expected_message}"
    wait until element is visible       msg
    ${actual_message}=                  get text                   //div/p[@id="msg"]
    ${actual_message}=                  strip string                ${actual_message}
    should be equal                     ${actual_message}           ${expected_message}

Click close error pop-up message
    click element                           //button[@class="btn btn-danger"]
#    wait until element is not visible       msg

Click close warning pop-up message
    wait until keyword succeeds     5x  4s      click element                   //button[@class="btn btn-warning"]

Input bank code "${bankCode}"
    input text              bankCode_label.bank-code                ${bankCode}
    click element           bankName_label.bank-code

Input bank account "${bankAccount}"
    input text              bankAccount             ${bankAccount}

Input re-type bank code "${bankCode}"
    input text              bankCode_label.re-bank-name                ${bankCode}
    click element           bankName_label.re-bank-name

Input re-type bank account "${bankAccount}"
    input text              rebankAccount        ${bankAccount}
    click element           bankAccount

Clear bank code and re-type bank code
    clear element text                  bankCode_label.bank-code
    clear element text                  bankCode_label.re-bank-name
    clear element text                  bankAccount
    clear element text                  rebankAccount

Country code is "${expected_countryCode}"
    ${actual_countryCode}=            get value                     countryCode
    should be equal                   ${actual_countryCode}         ${expected_countryCode}

Edit country "${country}"
    Set_value_by_javascript             countryCode         ${EMPTY}
    input text                          countryCode         ${country}
    click element                       countryName

Edit zip code "${zipCode}"
    Set_value_by_javascript             zipCode             ${EMPTY}
    input text                          zipCode             ${zipCode}
    click element                       districtName

Click search unit holder account
    Click_by_javascript           btn-search

Click back button from unit holder create
#    click element           //div/button[text()="Back"]
    Click_by_javascript           btn-back

Click search existing unit holder account
    click element           recordsPage
    click element           btn-search

Select existing unit holder account at row "${row}"
    ${table_row}=           evaluate        ${row}-1
    Click_by_javascript                     radio_approve_${table_row}

System show create unit holder account successfully "${expected_message}"
    wait for loading data
    ${msg}=                 get text            msgSucess
    ${actual_msg}=          strip string        ${msg}
    should be equal         ${actual_msg}       ${expected_message}

####approve unit holder
Input unit holder id "${unitHolder}" for approving
    input text              unitHolder              ${unitHolder}

Select approve unit holder menu
    click element           Approve

Select transaction type: approve create
    click element           txnType_CH

Select transaction type: approve edit
    click element           txnType_EH

Select transaction type: approve deactivate
    click element           txnType_DH

Select approve at row "${row}"
    ${table_row}=           evaluate        ${row}-1
    Click_by_javascript                     checkbox_approve_${table_row}

Select reject at row "${row}"
    ${table_row}=           evaluate        ${row}-1
    Click_by_javascript                     checkbox_reject_${table_row}

#########edit unit holder id
#id:Edit
Click edit unit holder account menu
    click element               id:Edit

Input unit holder id "${unitHolder}" for editing unit holder account
    input text          unitHolderId                ${unitHolder}

Select edit unit holder account at row "${row}"
    ${table_row}=           evaluate        ${row}-1
    Click_by_javascript                     radio__${table_row}

####api unit holder
Call api inquiry occupation: holder type "${holderType}"
    set to dictionary               ${get_occupation_inquiry}                 url=${url_web}
    ${get_occupation_inquiry}=       Get access token from "${web_login}" and set it in variable "${get_occupation_inquiry}" for authorization
    Set to dictionary               ${get_occupation_inquiry["params"]}      holderTypeCode=${holderType}
    ${result}=                      Send get api                ${get_occupation_inquiry}
    ${byte_string}=                 Decode bytes to string      ${result.content}   UTF-8
#    ${etf_info}=                    Get From Dictionary     ${result.json()}     content
#    log many                        ${result.content}
    [Return]                        ${result}
#    [Return]                        ${byte_string}

Get occupation code from api: holder type "${holderType}"
    ${occupation}=          Call api inquiry occupation: holder type "${holderType}"
    ${occupation_all}=                     Get From Dictionary         ${occupation.json()}     content
    set global variable           ${occupation_all}

Check occupation with share holder type from api
    check_occupation_code

####existing unit holder
Edit unit holder id "${unitHolder}"
    clear element text              unitHolder
    Press Key                       unitHolder                ${SPACE}
    input text                      unitHolder                ${unitHolder}




