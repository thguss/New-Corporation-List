//
//  FinancialMultipleAccount.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/15/24.
//

import Foundation

struct FinancialMultipleAccountInfo: Identifiable, Codable {
    var id = UUID()
    let businessYear: String            // 사업연도
    let corpCode: String                // 고유번호
    let stockCode: String               // 종목코드
    let accountName: String             // 금액 이름 (매출액, 당기순이익, 영업이익, 자산총계)
    let thisTermAmount: Int?            // 당기 금액
    let formerTermAmount: Int?          // 전기 금액
    let beforeFormerTermAmount: Int?    // 전전기 금액

    enum CodingKeys: String, CodingKey {
        case businessYear = "bsns_year"
        case corpCode = "corp_code"
        case stockCode = "stock_code"
        case accountName = "account_nm"
        case thisTermAmount = "thstrm_amount"
        case formerTermAmount = "frmtrm_amount"
        case beforeFormerTermAmount = "bfefrmtrm_amount"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.businessYear = try container.decode(String.self, forKey: .businessYear)
        self.corpCode = try container.decode(String.self, forKey: .corpCode)
        self.stockCode = try container.decode(String.self, forKey: .stockCode)
        self.accountName = try container.decode(String.self, forKey: .accountName)
        
        let thisTermAmountStr = try container.decode(String.self, forKey: .thisTermAmount)
        self.thisTermAmount = thisTermAmountStr.toCommaDeletedInt()
        
        let formerAmountStr = try container.decode(String.self, forKey: .formerTermAmount)
        self.formerTermAmount = formerAmountStr.toCommaDeletedInt()
        
        let beforeFormerAmountAccountStr = try container.decode(String.self, forKey: .beforeFormerTermAmount)
        self.beforeFormerTermAmount = beforeFormerAmountAccountStr.toCommaDeletedInt()
    }
}

extension String {
    func toCommaDeletedInt() -> Int? {
        return Int(
            self.replacingOccurrences(of: ",", with: "")
        )
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
}

struct FinancialMultipleAccountsInfo: Codable {
    let result: [FinancialMultipleAccountInfo]

    enum CodingKeys: String, CodingKey {
        case result = "list"
    }
}
