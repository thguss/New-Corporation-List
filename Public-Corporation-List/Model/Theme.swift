//
//  Theme.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/23/24.
//

import SwiftUI

enum Theme {
    case undervaluedGrowth  // 저평가 성장
    case hiddenValue        // 숨겨진 가치
    case undervaluedDecline // 저평가 하락
    case stability          // 안정
    case expectedGrowth     // 성장 기대
    case continuousGrowth   // 성장 지속
    case turningProfit      // 흑자 전환
    case hotIssue           // 관심 집중
    case surge              // 급상승
    case all                // 전체보기
}

extension Theme {
    var title: String {
        switch self {
        case .undervaluedGrowth
            : "저평가 성장"
        case .hiddenValue
            : "숨겨진 가치"
        case .undervaluedDecline
            : "저평가 하락"
        case .stability
            : "안정"
        case .expectedGrowth
            : "성장 기대"
        case .continuousGrowth
            : "성장 지속"
        case .turningProfit
            : "흑자 전환"
        case .hotIssue
            : "관심 집중"
        case .surge
            : "급상승"
        case .all
            : "전체 보기"
        }
    }

    var description: String {
        switch self {
        case .undervaluedGrowth
            : "저평가 받지만 성장하고 있어요. 투자의 기회에요!"
        case .hiddenValue
            : "잘 모르는 가치주에요. 발굴의 기회에요!"
        case .undervaluedDecline
            : "하락했지만 저평가 받는 가치주에요. 어쩌면 다시 상승?"
        case .stability
            : "꾸준히 이익을 내고 있어 안정적이에요. 편안해요!"
        case .expectedGrowth
            : "성장할 것 같아요! 서둘러 잡아볼까요?"
        case .continuousGrowth
            : "꾸준히 성장하고 있어요."
        case .turningProfit
            : "흑자로 전환했어요!"
        case .hotIssue
            : "거래량이 가장 많은 10개 종목을 확인해보세요."
        case .surge
            : "급상승한 10개 종목을 확인해보세요."
        case .all
            : "전체 종목을 확인해보세요."
        }
    }

    var criteria: String {
        switch self {
        case .undervaluedGrowth
            : "연평균 순이익 증감률 20% 이상 \nPER 0 ~ 20배"
        case .hiddenValue
            : "PER 0 ~ 15배 \nPBR 0 ~ 1.5배 \n연평균 순이익 증감률 0% 이상 \n거래량 하위 10개"
        case .undervaluedDecline
            : "PER 0 ~ 15배 \nPBR 0 ~ 1.5배 \n주가 하락 상위 10개"
        case .stability
            : "영업 이익률 5% 이상 \nROE 3% 이상"
        case .expectedGrowth
            : "순이익 증감률 10% 이상 \n연평균 순이익 증감률 3% 이상"
        case .continuousGrowth
            : "연평균 순이익 증감률 5% 이상 \n순이익 3년 연속 증가 \nROE 0% 이상"
        case .turningProfit
            : "전기 순이익 적자 \n당기 순이익 흑자"
        case .hotIssue
            : "거래량 상위 10개"
        case .surge
            : "주가 등락률 상위 10개"
        case .all
            : ""
        }
    }
    
    func corporations(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        switch self {
        case .undervaluedGrowth
            : return CorporationTheme.shared.undervalueGrowth(corporations: corporations)
        case .hiddenValue
            : return CorporationTheme.shared.hideValue(corporations: corporations)
        case .undervaluedDecline
            : return CorporationTheme.shared.undervalueDip(corporations: corporations)
        case .stability
            : return CorporationTheme.shared.stability(corporations: corporations)
        case .expectedGrowth
            : return CorporationTheme.shared.hopeGrowth(corporations: corporations)
        case .continuousGrowth
            : return CorporationTheme.shared.keepGrowth(corporations: corporations)
        case .turningProfit
            : return CorporationTheme.shared.reverseProfit(corporations: corporations)
        case .hotIssue
            : return CorporationTheme.shared.hot(corporations: corporations)
        case .surge
            : return CorporationTheme.shared.rapidRising(corporations: corporations)
        case .all
            : return corporations
        }
    }
}
