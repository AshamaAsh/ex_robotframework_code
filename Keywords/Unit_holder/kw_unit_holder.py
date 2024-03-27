from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword
import pickle
import time
import datetime
from selenium.webdriver.common.action_chains import ActionChains
from selenium import webdriver

@keyword('check_popup_message_unit_holder')
def checkPopupUnitHolderMessage():
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

import pickle
from robot.api.deco import keyword
import time
import datetime


@keyword('Dump_Variable_To_File')
def dumpVariable(arg,filename):
 fileObject = open(filename, 'wb')

 # Write object to file
 pickle.dump(arg, fileObject)

 fileObject.close()

@keyword('Load_Variable_From_File')
def loadVariable(filename):
 # open the file for reading
 fileObject = open(filename, 'rb')

 # Load object from file
 arg = pickle.load(fileObject)

 return arg


@keyword('check_occupation_code')
def test():
    driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
    occupation = BuiltIn().get_variable_value("${occupation_all}")
    actual_occupation = BuiltIn().get_variable_value("${actual_occupationCode}")

    list = []

    for item in occupation:
        occupationCode = item["occupationCode"]
        list.append(occupationCode)

    occupation_code = actual_occupation in list
    if occupation_code == False:
        print('*WARNING* Occupation Code is not match with Share Holder Type')
    else:
        print('Occupation Code match with Share Holder Type')


