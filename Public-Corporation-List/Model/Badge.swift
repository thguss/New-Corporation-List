//
//  Badge.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/23/24.
//

import SwiftUI

enum Badge {
    case undervalue // 저평가
    case growth     // 성장 중
    case rapidRise  // 급상승
    case hot      // 관심 집중
}

extension Badge {
    var colors: (background: Color, text: Color) {
        switch self {
        case .undervalue:
            return (background: Color.blue, text: Color.white)
        case .growth:
            return (background: Color.green, text: Color.white)
        case .rapidRise:
            return (background: Color.yellow, text: Color.white)
        case .hot:
            return (background: Color.red, text: Color.white)
        }
    }

    var title: String {
        switch self {
        case .undervalue:
            "저평가"
        case .growth:
            "성장 중"
        case .rapidRise:
            "급상승"
        case .hot:
            "HOT"
        }
    }
    
    var subTitle: String {
        switch self {
        case .undervalue:
            "성과에 비해 저평가된 기업이에요. 투자 기회를 노려보세요! (PER 0~15배, PBR 0~3배)"
        case .growth:
            "성장 중인 기업이에요. (순이익 등락 10% 이상, 3년 이내 순이익 등락 평균 3% 이상)"
        case .rapidRise:
            "주가가 급상승한 기업이에요. (등락률 증가 Top10)"
        case .hot:
            "시가총액이 큰 기업이에요. (시가총액 증가 Top10)"
        }
    }
}
