from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

# cu,etfAcc,ulAcc,parti
@keyword('Compare_inquiry_table_with_expected_data_inkind')
def compareInquiryTableInkind(locator,expectedData):

	driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
	rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')

	notMatch = 0

	for row in range(1,len(rowListObj)+1):

		index = "row" + str(row)
		subLocator = '//div[@id="etfSymbol_' + str(row-1) +'"]'
		#Check securities
		securities = driver.find_element_by_xpath(subLocator)
		if securities.text != expectedData[row-1]["etfSymbol"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Securities: ' + securities.text)
			print('*ERROR* Expected Securities: ' + expectedData[row-1]["etfSymbol"])
			break

		# Compare ISIN
		subLocator = '//div[@id="etfIsinCode_' + str(row - 1) + '"]'
		isin = driver.find_element_by_xpath(subLocator)
		if isin.text != expectedData[row-1]["etfIsinCode"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual ISIN: ' + isin.text)
			print('*ERROR* Expected ISIN: ' + expectedData[row-1]["etfIsinCode"])
			break

		# Compare transaction type
		subLocator = '//div[@id="txnTypeDesc_' + str(row - 1) + '"]'
		txnType = driver.find_element_by_xpath(subLocator)
		if txnType.text != expectedData[row-1]["txnTypeDesc"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Transaction Type: ' + txnType.text)
			print('*ERROR* Expected Transaction Type: ' + expectedData[row-1]["txnTypeDesc"])
			break

		# Compare cu volume
		subLocator = '//div[@id="cuVolume_' + str(row - 1) + '"]'
		cuVolume = driver.find_element_by_xpath(subLocator)
		vol = cuVolume.text
		newCuVolume = str("{0:,.0f}".format(float(vol)))
		expCuVolume = expectedData[row - 1]["cuVolume"]
		expectedCuVolume = str("{0:,.0f}".format(float(expCuVolume)))
		if newCuVolume != expectedCuVolume:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual CU Volume: ' + newCuVolume)
			print('*ERROR* Expected CU Volume: ' + expectedCuVolume)
			break

		# Compare ETF volume
		subLocator = '//div[@id="etfVolume_' + str(row - 1) + '"]'
		etfVolume = driver.find_element_by_xpath(subLocator)
		vol = etfVolume.text
		print(type(vol))
		expEtfVolume = expectedData[row - 1]["etfVolume"]
		expectedEtfVolume = str("{0:,.4f}".format(float(expEtfVolume)))
		if etfVolume.text != expectedEtfVolume:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual ETF Volume: ' + etfVolume.text)
			print('*ERROR* Expected ETF Volume: ' + expectedEtfVolume)
			break

		# Compare underlying settlement status
		subLocator = '//div[@id="underlyingSettleStatusDesc_' + str(row - 1) + '"]'
		subLocator_bkType =	'//div[@id="basketTypeDesc_' + str(row - 1) + '"]'
		ulSettStatus = driver.find_element_by_xpath(subLocator)
		basketType = driver.find_element_by_xpath(subLocator_bkType)
		if basketType.text == 'In Kind':
			if ulSettStatus.text != expectedData[row - 1]["underlyingSettleStatusDesc"]:
				notMatch = 1
				print('*ERROR* Row:' + index)
				print('*ERROR* Actual Underlying settlement status: ' + ulSettStatus.text)
				print('*ERROR* Expected Underlying settlement status: ' + expectedData[row - 1][
					"underlyingSettleStatusDesc"])
				break

		# Compare transaction status
		subLocator = '//div[@id="txnStatusDesc_' + str(row - 1) + '"]'
		txnStatus = driver.find_element_by_xpath(subLocator)
		if txnStatus.text != expectedData[row - 1]["txnStatusDesc"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Transaction Status: ' + txnStatus.text)
			print('*ERROR* Expected Transaction Status: ' + expectedData[row - 1]["txnStatusDesc"])
			break

	return notMatch

@keyword('Compare_inquiry_table_with_expected_data')
def compareInquiryTable(locator,expectedData):

	driver = BuiltIn().get_library_instance('SeleniumLibrary')._current_browser()
	rowListObj = driver.find_elements_by_xpath(locator + '/tbody/tr')

	notMatch = 0

	for row in range(1,len(rowListObj)+1):

		index = "row" + str(row)
		subLocator = '//div[@id="etfSymbol_' + str(row-1) +'"]'
		#Check securities
		securities = driver.find_element_by_xpath(subLocator)
		if securities.text != expectedData[row-1]["etfSymbol"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Securities: ' + securities.text)
			print('*ERROR* Expected Securities: ' + expectedData[row-1]["etfSymbol"])
			break

		# Compare ISIN
		subLocator = '//div[@id="etfIsinCode_' + str(row - 1) + '"]'
		isin = driver.find_element_by_xpath(subLocator)
		if isin.text != expectedData[row-1]["etfIsinCode"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual ISIN: ' + isin.text)
			print('*ERROR* Expected ISIN: ' + expectedData[row-1]["etfIsinCode"])
			break

		# Compare transaction type
		subLocator = '//div[@id="txnTypeDesc_' + str(row - 1) + '"]'
		txnType = driver.find_element_by_xpath(subLocator)
		if txnType.text != expectedData[row-1]["txnTypeDesc"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Transaction Type: ' + txnType.text)
			print('*ERROR* Expected Transaction Type: ' + expectedData[row-1]["txnTypeDesc"])
			break

		# Compare transaction status
		subLocator = '//div[@id="txnStatusDesc_' + str(row - 1) + '"]'
		txnStatus = driver.find_element_by_xpath(subLocator)
		if txnStatus.text != expectedData[row - 1]["txnStatusDesc"]:
			notMatch = 1
			print('*ERROR* Row:' + index)
			print('*ERROR* Actual Transaction Status: ' + txnStatus.text)
			print('*ERROR* Expected Transaction Status: ' + expectedData[row - 1]["txnStatusDesc"])
			break

	return notMatch