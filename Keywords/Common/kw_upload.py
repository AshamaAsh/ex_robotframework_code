from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword
import datetime
from selenium.webdriver.common.action_chains import ActionChains
from selenium import webdriver

@keyword('Read_upload_file')
def readUploadFile(file):

    with open (file,'r') as myfile:
        data = myfile.readlines()
        allData = []
        for line in data:
            dict = {}
            #print(line)
            line = line.strip()
            dataLine = line.split('|')
            dict['headerSequenceNo'] = dataLine[0]
            dict['referenceNo'] = dataLine[1]
            dict['underlyingType'] = dataLine[2]
            dict['deliveryType'] = dataLine[3]
            dict['marketID'] = dataLine[4]
            dict['etfSymbol'] = dataLine[5]
            dict['isinCode'] = dataLine[6]
            dict['toDeliverQty'] = dataLine[7]
            dict['toReceiveQty'] = dataLine[8]
            dict['amount'] = dataLine[9]
            dict['parti_id'] = dataLine[10]
            dict['accountNo'] = dataLine[11]
            dict['unitHolderID'] = dataLine[12]
            dict['brokerageA/C'] = dataLine[13]
            dict['refType'] = dataLine[14]
            dict['refNo'] = dataLine[15]
            dict['nationality'] = dataLine[16]

            allData.append(dict)
        print('first row: ',allData[0]["etfSymbol"])

    return allData



@keyword('Compare_table_with_upload_file')
def compareTableWithUploadFile(locator, expectedData, etfAcc_ownAcc, ulAcc, etf_pdAcc, etf_amAcc, parti):
    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')
    notMatch = 0

    for row in range(1, len(rowListObj) + 1):

        index = "row" + str(row)
        subLocator = '//div[@id="securityAssetAbbr_' + str(row - 1) + '"]'
        # Check securities
        securities = driver.find_element_by_xpath(subLocator)
        if securities.text != expectedData[row - 1]["etfSymbol"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Securities: ' + securities.text)
            print('*ERROR* Expected Securities: ' + expectedData[row - 1]["etfSymbol"])
            break

        # Compare ISIN
        subLocator = '//div[@id="isinCode_' + str(row - 1) + '"]'
        isin = driver.find_element_by_xpath(subLocator)
        if isin.text != expectedData[row - 1]["isinCode"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual ISIN: ' + isin.text)
            print('*ERROR* Expected ISIN: ' + expectedData[row - 1]["isinCode"])
            break

        # Compare To Deliver
        subLocator = '//div[@id="toDeliverQty_' + str(row - 1) + '"]'
        # toDelivery = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["toDeliverQty"] == 0:
            expectedToDelivery = ""
        else:
            expectedToDelivery = int(expectedData[row - 1]["toDeliverQty"])
            expectedToDelivery = str("{0:,.4f}".format(expectedToDelivery))
        toDelivery = driver.find_element_by_xpath(subLocator)
        if toDelivery.text == "":
            notMatch = 0
        elif toDelivery.text != expectedToDelivery:
            print(type(toDelivery.text))
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual To Deliver: ' + toDelivery.text)
            print('*ERROR* Expected To Deliver: ' + expectedToDelivery)
            break

        # Compare To Receive
        subLocator = '//div[@id="toReceiveQty_' + str(row - 1) + '"]'
        toReceive = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["toReceiveQty"] == 0:
            expectedToReceive = ""
        else:
            expectedToReceive = int(expectedData[row - 1]["toReceiveQty"])
            expectedToReceive = str("{0:,.4f}".format(expectedToReceive))
        if toReceive.text == "":
            notMatch = 0
        elif toReceive.text != expectedToReceive:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual To Receive: ' + toReceive.text)
            print('*ERROR* Expected To Receive: ' + expectedToReceive)
            break

        # Compare Parti no.
        subLocator = '//div[@id="partiID_' + str(row - 1) + '"]'
        # print(expectedData[row - 1]["underlyingType"])
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedParti = expectedData[row - 1]["parti_id"]
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedParti = expectedData[row - 1]["parti_id"]
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedParti = ""

        # print('parti ID: ',expectedParti)
        partiNo = driver.find_element_by_xpath(subLocator)
        if partiNo.text != expectedParti:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Parti no: ' + partiNo.text)
            print('*ERROR* Expected Parti no.: ' + expectedParti)
            break

        # Compare Account no.
        subLocator = '//div[@id="accountNo_' + str(row - 1) + '"]'
        subLocator_parti = '//input[@id="partiID"]'
        accNo = driver.find_element_by_xpath(subLocator)
        partiSearch = driver.find_element_by_xpath(subLocator_parti)
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedAccNo = etfAcc_ownAcc['acc_no']
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedAccNo = ulAcc['acc_no']
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedAccNo = ""

        if accNo.text == "":
            if expectedData[row - 1]["underlyingType"] != "O":
                if partiNo.text != expectedData[row - 1]["parti_id"]:
                    notMatch = 0
        elif accNo.text != expectedAccNo:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Account no.: ' + accNo.text)
            print('*ERROR* Expected Account no.: ' + expectedAccNo)
            break

        # Compare Account name
        subLocator = '//div[@id="accountName_' + str(row - 1) + '"]'
        # unitHolderId_0
        subLocatorUnitHold = '//div[@id="unitHolderId_' + str(row - 1) + '"]'
        unitHolder = driver.find_element_by_xpath(subLocatorUnitHold)
        subLocatorBrok = '//div[@id="brokerageAccountId_' + str(row - 1) + '"]'
        brokerage = driver.find_element_by_xpath(subLocatorBrok)
        if expectedData[row - 1]["underlyingType"] == "E":
            if unitHolder.text != "":
                expectedAccName = etf_amAcc['acc_name']
            elif brokerage.text != "":
                expectedAccName = etf_pdAcc['acc_name']
            else:
                expectedAccName = etfAcc_ownAcc['acc_name']
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedAccName = ulAcc['acc_name']
            print(expectedAccName)
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedAccName = ""
            print(expectedAccName)

        accName = driver.find_element_by_xpath(subLocator)
        # print(accName.text)
        print('account name: ', expectedAccName)
        if accName.text == "":
            if expectedData[row - 1]["underlyingType"] != "O":
                notMatch = 1
                print('*ERROR* Account name does not show')
                break
        elif accName.text != expectedAccName:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Account name: ' + accName.text)
            print('*ERROR* Expected Account name: ' + expectedAccName)
            break

    return notMatch

@keyword('Compare_table_with_expected_data_from_file_incash')
def compareTableFromFileIncash(locator, expectedData, etfAcc, ulAcc, parti):

    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')

    notMatch = 0

    for row in range(1, len(rowListObj) + 1):

        index = "row" + str(row)
        subLocator = '//div[@id="securityAssetAbbr_' + str(row - 1) + '"]'
        # Check securities
        securities = driver.find_element_by_xpath(subLocator)
        if securities.text != expectedData[row - 1]["etfSymbol"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Securities: ' + securities.text)
            print('*ERROR* Expected Securities: ' + expectedData[row - 1]["etfSymbol"])
            break

        # Compare ISIN
        subLocator = '//div[@id="isinCode_' + str(row - 1) + '"]'
        isin = driver.find_element_by_xpath(subLocator)
        if isin.text != expectedData[row - 1]["isinCode"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual ISIN: ' + isin.text)
            print('*ERROR* Expected ISIN: ' + expectedData[row - 1]["isinCode"])
            break

        # Compare Amount
        subLocator = '//div[@id="amount_' + str(row - 1) + '"]'
        amount = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["amount"] == 0:
            expectedAmount = ""
        else:
            expectedAmount = int(expectedData[row - 1]["amount"])
            expectedAmount = str("{0:,.2f}".format(expectedAmount))
        if amount.text != "":
            if amount.text != expectedAmount:
                notMatch = 1
                print('*ERROR* Row:' + index)
                print('*ERROR* Actual Amount: ' + amount.text)
                print('*ERROR* Expected Amount: ' + expectedAmount)
                break

        # Compare To Receive
        subLocator = '//div[@id="toReceiveQty_' + str(row - 1) + '"]'
        toReceive = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["toReceiveQty"] == 0:
            expectedToReceive = ""
        else:
            expectedToReceive = int(expectedData[row - 1]["toReceiveQty"])
            expectedToReceive = str("{0:,.4f}".format(expectedToReceive))
        if toReceive.text == "":
            print('Stock does not have to receive')
        elif toReceive.text != expectedToReceive:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual To Receive: ' + toReceive.text)
            print('*ERROR* Expected To Receive: ' + expectedToReceive)
            break

        # Compare Parti no.
        subLocator = '//div[@id="partiID_' + str(row - 1) + '"]'
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedParti = parti["parti_id"]
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedParti = parti["parti_id"]
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedParti = ""
        partiNo = driver.find_element_by_xpath(subLocator)
        if partiNo.text != expectedParti:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Parti no: ' + partiNo.text)
            print('*ERROR* Expected Parti no.: ' + parti["parti_id"])
            break

        # Compare Account no.
        subLocator = '//div[@id="accountNo_' + str(row - 1) + '"]'
        accNo = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedAccNo = etfAcc['acc_no']
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedAccNo = ulAcc['acc_no']
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedAccNo = ""

        if accNo.text == "":
            break
        elif accNo.text != expectedAccNo:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Account no.: ' + accNo.text)
            print('*ERROR* Expected Account no.: ' + expectedAccNo)
            break

        # Compare Account name
        subLocator = '//div[@id="accountName_' + str(row - 1) + '"]'
        accName = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedAccName = etfAcc['acc_name']
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedAccName = ulAcc['acc_name']
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedAccName = ""

        if accName.text != expectedAccName:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Account name: ' + accName.text)
            print('*ERROR* Expected Account name: ' + expectedAccName)
            break

    return notMatch

@keyword('Compare_table_with_expected_data_from_file_incash_redem')
def compareTableFromFileIncashRedem(locator, expectedData, etfAcc, ulAcc, parti):

    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')

    notMatch = 0

    for row in range(1, len(rowListObj) + 1):

        index = "row" + str(row)
        subLocator = '//div[@id="securityAssetAbbr_' + str(row - 1) + '"]'
        # Check securities
        securities = driver.find_element_by_xpath(subLocator)
        if securities.text != expectedData[row - 1]["etfSymbol"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Securities: ' + securities.text)
            print('*ERROR* Expected Securities: ' + expectedData[row - 1]["etfSymbol"])
            break

        # Compare ISIN
        subLocator = '//div[@id="isinCode_' + str(row - 1) + '"]'
        isin = driver.find_element_by_xpath(subLocator)
        if isin.text != expectedData[row - 1]["isinCode"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual ISIN: ' + isin.text)
            print('*ERROR* Expected ISIN: ' + expectedData[row - 1]["isinCode"])
            break

        # Compare Amount
        subLocator = '//div[@id="amount_' + str(row - 1) + '"]'
        amount = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["amount"] == 0:
            expectedAmount = ""
        else:
            expectedAmount = int(expectedData[row - 1]["amount"])
            expectedAmount = str("{0:,.2f}".format(expectedAmount))
        if amount.text != "":
            if amount.text != expectedAmount:
                notMatch = 1
                print('*ERROR* Row:' + index)
                print('*ERROR* Actual Amount: ' + amount.text)
                print('*ERROR* Expected Amount: ' + expectedAmount)
                break

        # Compare To Deliver
        subLocator = '//div[@id="toDeliverQty_' + str(row - 1) + '"]'
        toDelivery = driver.find_element_by_xpath(subLocator)

        if expectedData[row - 1]["toDeliverQty"] == 0:
           expectedToDelivery = ""
        else:
            expectedToDelivery = int(expectedData[row - 1]["toDeliverQty"])
            expectedToDelivery = str("{0:,.4f}".format(expectedToDelivery))

        if toDelivery.text != "":
            if toDelivery.text != expectedToDelivery:
                # print(type(toDelivery.text))
                notMatch = 1
                print('*ERROR* Row:' + index)
                print('*ERROR* Actual To Deliver: ' + toDelivery.text)
                print('*ERROR* Expected To Deliver: ' + expectedToDelivery)
                break

        # Compare Parti no.
        subLocator = '//div[@id="partiID_' + str(row - 1) + '"]'
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedParti = parti["parti_id"]
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedParti = parti["parti_id"]
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedParti = ""
        partiNo = driver.find_element_by_xpath(subLocator)
        if partiNo.text != expectedParti:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Parti no: ' + partiNo.text)
            print('*ERROR* Expected Parti no.: ' + parti["parti_id"])
            break

        # Compare Account no.
        subLocator = '//div[@id="accountNo_' + str(row - 1) + '"]'
        accNo = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedAccNo = etfAcc['acc_no']
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedAccNo = ulAcc['acc_no']
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedAccNo = ""

        if accNo.text == "":
            break
        elif accNo.text != expectedAccNo:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Account no.: ' + accNo.text)
            print('*ERROR* Expected Account no.: ' + expectedAccNo)
            break

        # Compare Account name
        subLocator = '//div[@id="accountName_' + str(row - 1) + '"]'
        accName = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["underlyingType"] == "E":
            expectedAccName = etfAcc['acc_name']
        elif expectedData[row - 1]["underlyingType"] == "S":
            expectedAccName = ulAcc['acc_name']
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedAccName = ""

        if accName.text != expectedAccName:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Account name: ' + accName.text)
            print('*ERROR* Expected Account name: ' + expectedAccName)
            break

    return notMatch