from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

@keyword('Compare_ETF_table_with_expected_data')
def compareEtfTable(locator,expectedData,cu,etfAcc,ulAcc,parti):

	driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
	rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')

	notMatch = 0

	for row in range(1,len(rowListObj)+1):

		index = "row" + str(row)
		subLocator = '//div[@id="securityAssetAbbr_' + str(row-1) +'"]'
		#Check securities
		securities = driver.find_element_by_xpath(subLocator)
		if securities.text != expectedData[row-1]["securityAssetAbbr"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Securities: ' + securities.text)
			print('*ERROR* Expected Securities: ' + expectedData[row-1]["securityAssetAbbr"])
			break

		# Compare ISIN
		subLocator = '//div[@id="isinCode_' + str(row - 1) + '"]'
		isin = driver.find_element_by_xpath(subLocator)
		if isin.text != expectedData[row-1]["isinCode"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual ISIN: ' + isin.text)
			print('*ERROR* Expected ISIN: ' + expectedData[row-1]["isinCode"])
			break

		# Compare To Deliver
		subLocator = '//div[@id="toDeliverQty_' + str(row - 1) + '"]'
		toDelivery = driver.find_element_by_xpath(subLocator)
		if expectedData[row-1]["toDeliverQty"] == 0:
			expectedToDelivery = ""
		else:
			expectedToDelivery = int(expectedData[row-1]["toDeliverQty"]) * int(cu)
			expectedToDelivery = str("{0:,.4f}".format(expectedToDelivery))
		if toDelivery.text != expectedToDelivery:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual To Deliver: ' + toDelivery.text)
			print('*ERROR* Expected To Deliver: ' + expectedToDelivery)
			break

		# Compare To Receive
		subLocator = '//div[@id="toReceiveQty_' + str(row - 1) + '"]'
		toReceive = driver.find_element_by_xpath(subLocator)
		if expectedData[row-1]["toReceiveQty"] == 0:
			expectedToReceive = ""
		else:
			expectedToReceive = int(expectedData[row-1]["toReceiveQty"]) * int(cu)
			expectedToReceive = str("{0:,.4f}".format(expectedToReceive))
		if toReceive.text != expectedToReceive:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual To Receive: ' + toReceive.text)
			print('*ERROR* Expected To Receive: ' + expectedToReceive)
			break

		#Compare Parti no.
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
		if expectedData[row-1]["underlyingType"] == "E":
			expectedAccNo = etfAcc['acc_no']
		elif expectedData[row - 1]["underlyingType"] == "S":
			expectedAccNo = ulAcc['acc_no']
		elif expectedData[row - 1]["underlyingType"] == "O":
			expectedAccNo = ""

		if accNo.text != expectedAccNo:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Account no.: ' + accNo.text)
			print('*ERROR* Expected Account no.: ' + expectedAccNo)
			break

		# Compare Account name
		subLocator = '//div[@id="accountName_' + str(row - 1) + '"]'
		accName = driver.find_element_by_xpath(subLocator)
		if expectedData[row-1]["underlyingType"] == "E":
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