//
//  ListCorpInfo.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/12/24.
//

import Foundation

/**
 신규 상장 기업 기본 정보
 */
struct ListCorpInfo: Identifiable, Equatable {
    var id = UUID()
    let corpCode: String                    // 고유번호
    let name: String                        // 정식명칭 : CompanyInfo.corpName == StockInfo.isuNm
    let stockCode: String                   // 종목코드(단축코드)
    let listDate: String                    // 상장일
    let todayOpeningPrice: Int?
    let todayClosingPrice: Int?

//    var totalAssets: PeriodicAmount?        // 자산총계
//    var revenue: PeriodicAmount?            // 매출액
//    var operatingProfit: PeriodicAmount?    // 영업이익
//    var netProfit: PeriodicAmount?          // 당기순이익
}

///**
// 재무지표 기간별 금액 정보
// */
//struct PeriodicAmount: Equatable {
//    let thisTermAmount: Int?            // 당기 금액
//    let formerTermAmount: Int?          // 전기 금액
//    let beforeFormerTermAmount: Int?    // 전전기 금액
//}
