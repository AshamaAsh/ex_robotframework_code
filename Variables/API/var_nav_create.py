nav_create_valid = {
    "url": "http://some.web",
    "uri": "/somepath/nav-create",
    "method": "POST",
    "params": "",
    "headers": "",
    "body": {"effectiveDate": "2020-01-01", "etfMarketId": "A", "etfSymbol": "sth", "etfIsinCode": "sth",
             "navFairValue": "33.6566", "navBFeeValue": "34.4562", "navBidValue": "34.3456", "navOfferValue": "35.2345"}
}


nav_create_invalid_E026 = {
    "url": "http://some.web",
    "uri": "/etfs/somepath/nav-create",
    "method": "POST",
    "params": "",
    "headers": {"Authorization": "", "Content-Type": "application/json"},
    "body": {"effectiveDate": "2020-04-20", "etfMarketId": "A", "etfSymbol": "sth", "etfIsinCode": "sth",
             "navFairValue": "33.6566", "navBFeeValue": "34.4562", "navBidValue": "34.3456", "navOfferValue": "35.2345"}
}
