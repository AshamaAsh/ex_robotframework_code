from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword
import datetime
from selenium.webdriver.common.action_chains import ActionChains
from selenium import webdriver

@keyword('approve_status')
def approveStatus(locator):
    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')
    notMatch = 0

    for row in range(1, len(rowListObj) + 1):
        index = "row" + str(row)
        subLocator = '//div[@id="statusMessage_' + str(row - 1) + '"]'
        #check status message
        statusMessage = driver.find_element_by_xpath(subLocator)
        if statusMessage.text != "Success":
            notMatch = 1
            print('*ERROR* Row:' + index)
            print('*ERROR* Actual Message: ' + statusMessage.text)
            print('*ERROR* Expected Message: Success')
            break

    return notMatch

@keyword('check_popup_message')
def checkPopupMessage():
    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    notMatch = 0
    headMessageLocator = '//app-modal-content/div/h4'
    headMessage = driver.find_element_by_xpath(headMessageLocator)
    # print('*ERROR*')
    subLocator = '//div/p[@id="msg"]'
    popupMessage = driver.find_element_by_xpath(subLocator)
    if headMessage.text != "Success":
        if headMessage.text != "Warning":
            notMatch = 1
            print('*ERROR*')
            print('*ERROR* Message: ' + popupMessage.text)

    return notMatch


