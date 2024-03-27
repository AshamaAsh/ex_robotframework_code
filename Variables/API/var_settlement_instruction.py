settlement_invalid_E000 = {
    "url": "http://web.page",
    "uri": "/etfs/someuri/settlement-instruction",
    "method": "POST",
    "params": "",
    "headers": {"Content-Type": "application/json"},
    "body": {
        "partiId": "",
        "txnDate": "",
        "txnTypeId": "",
        "txnNo": "",
        "instructionDetails": []
    }
}

settlement_invalid_E000 = {
    "url": "http://web.page",
    "uri": "/etfs/someuri/settlement-instruction",
    "method": "POST",
    "params": "",
    "headers": {"Content-Type": "application/json"},
    "body": {
        "partiId": "013",
        "txnDate": "2020-05-08",
        "txnTypeId": "sth",
        "txnNo": "2",
        "instructionDetails": [
            {
                "rowNo": "",
                "referenceSeqNo": "sth",
                "underlyingType": "E",
                "settlementType": "E",
                "marketId": "A",
                "secSymbol": "sth",
                "isinCode": "sth",
                "toDeliverVolume": 100000000,
                "toReceiveVolume": 0,
                "partiID": "sth",
                "accountNo": "",
                "tradingId": "sth",
                "unitHolderId": "",
                "brokerageAccountId": "1234",
                "referenceTypeId": "0",
                "referenceNo": "sth",
                "nationalityCode": "sth",
                "securityAssetID": "sth"
            }
        ]
    }
}
