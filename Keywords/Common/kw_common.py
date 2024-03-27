from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword
import datetime
# import time
# from selenium.webdriver.common.action_chains import ActionChains
# from selenium import webdriver
# from pynput.keyboard import Key, Controller
# import clipboard

#try
@keyword('Set_value_by_javascript')
def setValueByJavascript(locator,value):
 driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
 obj = driver.find_element_by_id(locator)

 #SET  VALUE
 setStr = "arguments[0].value='" + str(value) + "'"
 driver.execute_script(setStr, obj)

@keyword('Get_value_by_javascript')
def getValueByJavascript(locator):
 driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
 obj = driver.find_element_by_id(locator)

 #GET RETURN VALUE
 driver.execute_script('return arguments[0].value;', obj)
 txt = obj.get_attribute('value')
 return txt

@keyword('Click_by_javascript')
def clickByJavascript(locator):
 driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
 obj = driver.find_element_by_id(locator)
 driver.execute_script('arguments[0].click()', obj)

@keyword('change_format_date')
def changeFormatDate(variables):
 var = variables.split('/')
 var[0], var[2] = var[2], var[0]
 date = '-'.join(var)
 return date

@keyword('get_date_time')
def getDateTime():
 now = datetime.datetime.now()
 dts = now.strftime("%d/%m/%Y")
 return dts

@keyword('get_date_for_api')
def getDateForApi():
 now = datetime.datetime.now()
 dts = now.strftime("%Y-%m-%d")
 return dts

@keyword('get_day_name')
def getDayName():
 now = datetime.datetime.now()
 name = now.strftime("%A")
 return name

# @keyword('day_after_tomorrow')
# def dayAfterTommorow:
#  date = datetime.datetime.now() + datetime.timedelta(days=2)
#  next2days = date.strftime("%d/%m/%Y")
#  return next2days

@keyword('cal_etf_volume')
def calETFVolume(cu,cuShQty):
 etfVol = cu*cuShQty
 return etfVol

@keyword('Clear_text')
def clearTextBySelenium(locator) :
 driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
 #ADD Implicit wait
 driver.implicitly_wait(10)
 obj = driver.find_element_by_id(locator)
 obj.clear()

@keyword('click_basket_type')
def clickBasketType(locator) :
 driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
 #ADD Implicit wait
 driver.implicitly_wait(10)
 obj = driver.find_element_by_id(locator)
 val_class = obj.get_attribute("class")
 while(val_class!='form-check-input ng-dirty ng-valid ng-touched'):
  obj.click()
  val_class = obj.get_attribute("class")



