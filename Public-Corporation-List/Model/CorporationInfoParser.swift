//
//  CorpCodeParser.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/11/24.
//

import Foundation

class CorporationInfoParser: NSObject, XMLParserDelegate {
    private var corporations: [CorporationInfo] = []
    private var currentElement = ""
    private var currentCorpCode: String = ""
    private var currentCorpName: String = ""
    private var currentStockCode: String = ""
    private var currentModifyDate: String = ""
    
    func parse(data: Data) -> [CorporationInfo] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return corporations
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
      currentElement = elementName
        
      if elementName == "list" {
          currentCorpCode = ""
          currentCorpName = ""
          currentStockCode = ""
          currentModifyDate = ""
      }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "corp_code":
            currentCorpCode += string
        case "corp_name":
            currentCorpName += string
        case "stock_code":
            currentStockCode += string
        case "modify_date":
            currentModifyDate += string
        default:
            break
      }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "list" {
            let corporationInfo = CorporationInfo(
                corpCode: currentCorpCode.trimmingCharacters(in: .whitespacesAndNewlines),
                corpName: currentCorpName.trimmingCharacters(in: .whitespacesAndNewlines),
                stockCode: currentStockCode.trimmingCharacters(in: .whitespacesAndNewlines),
                modifyDate: currentModifyDate.trimmingCharacters(in: .whitespacesAndNewlines))
            corporations.append(corporationInfo)
        }
    }
}
