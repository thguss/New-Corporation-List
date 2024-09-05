//
//  ByDayTradingInfo.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/18/24.
//

import Foundation

struct DailyTradingInfo: Codable, Equatable {
    let baseDate: String                            // 기준일자
    let issueCode: String                           // 종목코드
    let issueName: String                           // 종목명
    let marketName: String                          // 시장구분
    let sectorTypeName: String                      // 소속부
    let todayClosingPrice: Int?                     // 종가
    let currentMonthPreviousDayPercentChange: Int?  // 대비
    let fluctuationRate: Double?                    // 등락률
    let todayOpeningPrice: Int?                     // 시가
    let todayHighPrice: Int?                        // 고가
    let todayLowPrice: Int?                         // 저가
    let accumulatedTradingVolume: Int?              // 거래량
    let accumulatedTradingValue: Int?               // 거래대금
    let marketCapitalization: Int?                  // 시가총액
    let listedShares: Int?                          // 상장주식수

    enum CodingKeys: String, CodingKey {
        case baseDate = "BAS_DD"
        case issueCode = "ISU_CD"
        case issueName = "ISU_NM"
        case marketName = "MKT_NM"
        case sectorTypeName = "SECT_TP_NM"
        case todayClosingPrice = "TDD_CLSPRC"
        case currentMonthPreviousDayPercentChange = "CMPPREVDD_PRC"
        case fluctuationRate = "FLUC_RT"
        case todayOpeningPrice = "TDD_OPNPRC"
        case todayHighPrice = "TDD_HGPRC"
        case todayLowPrice = "TDD_LWPRC"
        case accumulatedTradingVolume = "ACC_TRDVOL"
        case accumulatedTradingValue = "ACC_TRDVAL"
        case marketCapitalization = "MKTCAP"
        case listedShares = "LIST_SHRS"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.baseDate = try container.decode(String.self, forKey: .baseDate)
        self.issueCode = try container.decode(String.self, forKey: .issueCode)
        self.issueName = try container.decode(String.self, forKey: .issueName)
        self.marketName = try container.decode(String.self, forKey: .marketName)
        self.sectorTypeName = try container.decode(String.self, forKey: .sectorTypeName)

        self.todayClosingPrice = try container.decode(String.self, forKey: .todayClosingPrice).toCommaDeletedInt()
        self.currentMonthPreviousDayPercentChange = try container.decode(String.self, forKey: .currentMonthPreviousDayPercentChange).toCommaDeletedInt()
        self.fluctuationRate = try container.decode(String.self, forKey: .fluctuationRate).toDouble()
        self.todayOpeningPrice = try container.decode(String.self, forKey: .todayOpeningPrice).toCommaDeletedInt()
        self.todayHighPrice = try container.decode(String.self, forKey: .todayHighPrice).toCommaDeletedInt()
        self.todayLowPrice = try container.decode(String.self, forKey: .todayLowPrice).toCommaDeletedInt()
        self.accumulatedTradingVolume = try container.decode(String.self, forKey: .accumulatedTradingVolume).toCommaDeletedInt()
        self.accumulatedTradingValue = try container.decode(String.self, forKey: .accumulatedTradingValue).toCommaDeletedInt()
        self.marketCapitalization = try container.decode(String.self, forKey: .marketCapitalization).toCommaDeletedInt()
        self.listedShares = try container.decode(String.self, forKey: .listedShares).toCommaDeletedInt()
    }
}

struct DailyTradingsInfo: Codable {
    let result: [DailyTradingInfo]

    enum CodingKeys: String, CodingKey {
        case result = "OutBlock_1"
    }
}
