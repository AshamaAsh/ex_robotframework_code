from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword
import datetime
# import time
# from selenium.webdriver.common.action_chains import ActionChains
# from selenium import webdriver
# from pynput.keyboard import Key, Controller
# import clipboard

@keyword('compare_table_unit_holder_with_api')
def compareTableUnitHolderWithApi(locator,expectedData):
    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')

    notMatch = 0

    for row in range(1, len(rowListObj) + 1):

        index = "row" + str(row)
        subLocator = '//div[@id="unitHolderId_' + str(row - 1) + '"]'
        # Check unitHolderID
        unitHolderId = driver.find_element_by_xpath(subLocator)
        if unitHolderId.text != expectedData[row - 1]["unitHolderId"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Unit Holder ID: ' + unitHolderId.text)
            print('*ERROR* Expected Unit Holder ID: ' + expectedData[row - 1]["unitHolderId"])
            break

        # Compare etf symbol
        subLocator = '//div[@id="etfSymbol_' + str(row - 1) + '"]'
        etfSymbol = driver.find_element_by_xpath(subLocator)
        if etfSymbol.text != expectedData[row - 1]["etfSymbol"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual etfSymbol: ' + etfSymbol.text)
            print('*ERROR* Expected etfSymbol: ' + expectedData[row - 1]["etfSymbol"])
            break

        # Compare ISIN
        subLocator = '//div[@id="etfIsinCode_' + str(row - 1) + '"]'
        isin = driver.find_element_by_xpath(subLocator)
        if isin.text != expectedData[row - 1]["etfIsinCode"]:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual etfIsinCode: ' + isin.text)
            print('*ERROR* Expected etfIsinCode: ' + expectedData[row - 1]["etfIsinCode"])
            break

        # Compare old outs. balance
        subLocator = '//div[@id="oldShareQty_' + str(row - 1) + '"]'
        oldBalance = driver.find_element_by_xpath(subLocator)
        expectedOldBalance = str("{0:,.4f}".format(expectedData[row - 1]["oldShareQty"]))
        if oldBalance.text != expectedOldBalance:
            notMatch = 1
            # print('oldbaland1 : ' + oldBalance.text)
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Old Share Qty: ' + oldBalance.text)
            # print('value ', oldBalance.text)
            print('*ERROR* Expected Old Share Qty: ' + expectedOldBalance)
            break

        #Compare new outs. balance
        subLocator = '//input[@id="newShareQty_' + str(row - 1) + '"]'
        newBalance = driver.find_element_by_xpath(subLocator)
        expectedNewBalance = str("{0:,.4f}".format(expectedData[row - 1]["newShareQty"]))
        if newBalance.get_attribute('value') != expectedNewBalance:
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual New Share Qty: ' + newBalance.get_attribute('value'))
            print('*ERROR* Expected New Share Qty: ' + expectedNewBalance)
            break

        # Compare To Deliver
        # subLocator = '//div[@id="toDeliverQty_' + str(row - 1) + '"]'
        # toDelivery = driver.find_element_by_xpath(subLocator)
        # expectedToDeliver = str("{0:,.4f}".format(expectedData[row - 1]["toDeliverQty"]))
        # if toDelivery.text != expectedToDeliver:
        #     notMatch = 1
        #     print('*ERROR* Row:' + index)
        #     print('*ERROR* Actual To Deliver: ' + toDelivery.text)
        #     print('*ERROR* Expected To Deliver: ' + expectedToDeliver)
        #     break
        #
        # # Compare To Receive
        # subLocator = '//div[@id="toReceiveQty_' + str(row - 1) + '"]'
        # toReceive = driver.find_element_by_xpath(subLocator)
        # expectedToReceive = str("{0:,.4f}".format(expectedData[row - 1]["toReceiveQty"]))
        # if toReceive.text != expectedToReceive:
        #     notMatch = 1
        #     print('*ERROR* Row:' + index)
        #     print('*ERROR* Actual To Receive: ' + toReceive.text)
        #     print('*ERROR* Expected To Receive: ' + expectedToReceive)
        #     break

    return notMatch

@keyword('get_value_old_balance')
def getValueOldBalance(locator,expectedData):
    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')

    for row in range(1, len(rowListObj) + 1):

        old_balance = expectedData[row - 1]["oldShareQty"]
        new_value = old_balance - 1
        new_old_balance = str(new_value)

    return new_old_balance


@keyword('convert_format')
def ConvertFormat(vol):
    newFormat = str("{0:,.4f}".format(float(vol)))
    return	newFormat
