*** Settings ***
Library         OperatingSystem

*** Keywords ***
Select upload initiate ssettlement menu
    click element           id:UploadInitiateSettlement

Registrar name show "${expected_registrarNameEng}"
    ${regis_name}=                  get value           id:registrarNameEng
    ${actual_regis_name}=           strip string        ${regis_name}
    should be equal         ${actual_regis_name}        ${expected_registrarNameEng}

Click search button of upload initiate
    click element         xpath://button[@class="btn btn-etfs-small btn-rounded logo-center"]

Select edit for upload initiate settlement of row "${row}"
    ${table_row}=           evaluate            ${row}-1
#    ${edit_row}=            get text            id:edit_${table_row}
    click element           id:edit_${table_row}

Creation volume must be "${cu}"
    ${creation}=            get value           id:cashAmt
    ${creation_vol}=        strip string        ${creation}
    should be equal         ${cu}               ${creation_vol}

Upload initiate file "${file_name}" from "${folder_name}" to website
    ${normal_path}=                         Normalize Path          ${CURDIR}//..//..//Upload//${folder_name}//${file_name}
    Choose file                             id:fileUpload           ${normal_path}
    wait for loading page

#get_initiate_upload_info_from_api
Get value from text file "${file_name}" for "${folder_name}"
    ${path}=        Normalize Path                  ${CURDIR}//..//..//Upload//${folder_name}//${file_name}
    ${data}=        Read_upload_initiate_file       ${path}
    set suite variable          ${data}

System show table of upload initiate as expected of parti "${parti_id}"
    ${notMatch}=    Compare_table_upload_initiate_file      //table[@id='enquiry_table']          ${data}     ${expected_etf_account}       ${expected_etf_account}     ${expected_etf_account}     ${expected_etf_account}     ${parti_${parti_id}}
#        ${notMatch}=    Compare_table_with_upload_file      //table[@id='enquiry_table']          ${data}      ${parti_${parti_id}}
    Should Be Equal         ${notMatch}             ${0}

Click submit upload initiate file
    Click_by_javascript                         btn-submit

System show pop up message: upload initiate file successfully
    wait until element is visible       msgSucess
    element text should be              msgSucess          Create Transaction successfully, Please Approve.

##approve initiate
Click approve/reject initiate settlement menu
    Click_by_javascript                    Approve/RejectInitiateSettlement

Click search button of approve/reject initiate
    Click_by_javascript                    searchBtn

Registrar name of approve initiate show "${expected_registrarNameEng}"
#    registrarName
    ${regis_name}=                  get value           id:registrarName
    ${actual_regis_name}=           strip string        ${regis_name}
    should be equal         ${actual_regis_name}        ${expected_registrarNameEng}

Click submit for aprrove/reject upload initiate
    Click_by_javascript             submitBtn

Click back after upload initiate successfully
    Click_by_javascript                     btn-back
    wait until element is visible           xpath://nav[@class="breadcrumb p-0"]