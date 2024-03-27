pdf_create_structure = {
    "url": "http://web.page",
    "uri": "/etf/someuri/pdf-create",
    "method": "POST",
    "params": "",
    "headers": {"Authorization": "", "Content-Type": "application/json"},
    "body": {}
}

pdf_create_invalid_E100 = {
    "url": "http://web.page",
    "uri": "/etfs/someuri/pdf-create",
    "method": "POST",
    "params": "",
    "headers": {"Authorization": "", "Content-Type": "application/json"},
    "body": {"effectiveDate": "", "etfMarketId": "A", "etfSymbol": "sth",
             "etfIsinCode": "sth", "basketType": "IK", "cashAmount": 0,
             "pdfDetails": [{
                 "underlyingType": "S",
                 "marketId": "A",
                 "secSymbol": "sth",
                 "isinCode": "sth",
                 "volume": 7500,
                 "amount": 7500}]
             }
}

