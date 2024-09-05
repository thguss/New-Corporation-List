//
//  CorpInfo.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/11/24.
//

import Foundation

/**
 [DART] 고유번호 (XML)
 */

struct CorporationInfo: Identifiable, Equatable {
    let id = UUID()
    let corpCode: String    // 고유번호
    let corpName: String    // 정식명칭
    let stockCode: String   // 종목코드
    let modifyDate: String  // 최종변경일자
}
