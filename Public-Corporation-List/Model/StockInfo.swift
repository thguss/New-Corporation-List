//
//  StockInfo.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/11/24.
//

import Foundation

/**
 [KRX] 종목 기본 정보 (코스닥)
 */

struct StockInfo: Identifiable, Codable, Equatable {
    var id = UUID()
    let issueCode: String                       // 표준코드
    let issueShortCode: String                  // 단축코드
    let issueName: String                       // 한글 종목명
    let issueAbbreviation: String               // 한글 종목 약명
    let issueEnglishName: String                // 영어 종목명
    let listDate: String                        // 상장일
    let marketTypeName: String                  // 시장구분
    let securityGroupName: String               // 증권구분
    let sectorTypeName: String                  // 소속부
    let kindOfStockCertificateTypeName: String  // 주식종류
    let parValue: String                        // 액면가
    let listedShares: String                    // 상장 주식 수

    enum CodingKeys: String, CodingKey {
        case issueCode = "ISU_CD"
        case issueShortCode = "ISU_SRT_CD"
        case issueName = "ISU_NM"
        case issueAbbreviation = "ISU_ABBRV"
        case issueEnglishName = "ISU_ENG_NM"
        case listDate = "LIST_DD"
        case marketTypeName = "MKT_TP_NM"
        case securityGroupName = "SECUGRP_NM"
        case sectorTypeName = "SECT_TP_NM"
        case kindOfStockCertificateTypeName = "KIND_STKCERT_TP_NM"
        case parValue = "PARVAL"
        case listedShares = "LIST_SHRS"
    }
}

struct StocksInfo: Codable {
    let result: [StockInfo]

    enum CodingKeys: String, CodingKey {
        case result = "OutBlock_1"
    }
}
