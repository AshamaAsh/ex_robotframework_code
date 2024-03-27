from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword
import datetime
from selenium.webdriver.common.action_chains import ActionChains
from selenium import webdriver

@keyword('Read_upload_initiate_file')
def readUploadInitiateFile(file):

    with open (file,'r') as myfile:
        data = myfile.readlines()
        allData = []
        for line in data:
            dict = {}
            #print(line)
            line = line.strip()
            dataLine = line.split('|')
            dict['referenceNo'] = dataLine[0]
            dict['underlyingType'] = dataLine[1]
            dict['settlementType'] = dataLine[2]
            dict['marketID'] = dataLine[3]
            dict['etfSymbol'] = dataLine[4]
            dict['isinCode'] = dataLine[5]
            dict['toDeliverQty'] = dataLine[6]
            dict['toReceiveQty'] = dataLine[7]
            dict['parti_id'] = dataLine[8]
            dict['accountNo'] = dataLine[9]
            dict['tradingID'] = dataLine[10]
            dict['brokerageA/C'] = dataLine[11]
            dict['refType'] = dataLine[12]
            dict['refNo'] = dataLine[13]
            dict['nationality'] = dataLine[14]

            allData.append(dict)
        print('first row: ',allData[0]["etfSymbol"])

    return allData



@keyword('Compare_table_upload_initiate_file')
def compareTableUploadInitiateFile(locator, expectedData, etfAcc_ownAcc, ulAcc, etf_pdAcc, etf_amAcc, parti):
# def compareTableWithUploadFile(locator, expectedData,parti):
    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')
    # print('row: ', rowListObj)
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
        subLocator = '//div[@id="toDeliverVolume_' + str(row - 1) + '"]'
        # toDelivery = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["toDeliverQty"] == 0:
            expectedToDelivery = ""
        else:
            # expectedToDelivery = expectedData[row - 1]["toDeliverQty"]
            expectedToDelivery = int(expectedData[row - 1]["toDeliverQty"])
            expectedToDelivery = str("{0:,.0f}".format(expectedToDelivery))
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
        subLocator = '//div[@id="toReceiveVolume_' + str(row - 1) + '"]'
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

        # compare trading id
        subLocator = '//div[@id="tradingId_' + str(row - 1) + '"]'
        tradingID = driver.find_element_by_xpath(subLocator)
        if expectedData[row - 1]["settlementType"] == "H":
            expectedTradingId = ""
        else:
            expectedTradingId = expectedData[row - 1]["tradingID"]

        if tradingID.text != "":
            if tradingID.text != expectedTradingId:
                notMatch = 1
                print('*ERROR* Row:' + index)
                print('*ERROR* Actual Account name: ' + tradingID.text)
                print('*ERROR* Expected Account name: ' + expectedTradingId)
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
        elif expectedData[row - 1]["underlyingType"] == "O":
            expectedAccName = ""

        accName = driver.find_element_by_xpath(subLocator)
        # print(accName.text)
        # print('account name: ', expectedAccName)
        if accName.text == "":
            if expectedData[row - 1]["settlementType"] != "E":
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