//
//  ListedCorporationInfo.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/18/24.
//

import Foundation

/**
신규 상장 기업  Model
 */
struct ListedCorporationInfo: Identifiable, Equatable {
    var id = UUID()
    let corporation: CorporationInfo
    let stock: StockInfo
    let dailyTrading: DailyTradingInfo
    
    var totalAssets: PeriodicAmount?        // 자산총계
    var revenue: PeriodicAmount?            // 매출액
    var operatingProfit: PeriodicAmount?    // 영업이익
    var netProfit: PeriodicAmount?          // 당기순이익
    
    var per: Double?
    var pbr: Double?

    var badges: [Badge] = [] // TODO: 기본값 제거

    mutating func appendBadges(badges: [Badge]) {
        self.badges = badges
    }

    func copyWithBadges(badges: [Badge]) -> Self {
        return ListedCorporationInfo(
            id: id,
            corporation: corporation,
            stock: stock,
            dailyTrading: dailyTrading,
            totalAssets: totalAssets,
            revenue: revenue,
            operatingProfit: operatingProfit,
            netProfit: netProfit,
            per: per,
            pbr: pbr,
            badges: badges
        )
    }
}

/**
 재무지표 기간별 금액 정보
 */
struct PeriodicAmount: Equatable {
    let thisTermAmount: Int?            // 당기 금액
    let formerTermAmount: Int?          // 전기 금액
    let beforeFormerTermAmount: Int?    // 전전기 금액
}
