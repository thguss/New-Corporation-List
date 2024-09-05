//
//  CorporationTheme.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/23/24.
//

import Foundation

class CorporationTheme {
    static let shared = CorporationTheme()
}

extension CorporationTheme {
    /**
     저평가 성장 기업
     */
    func undervalueGrowth(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                // 연평균 순이익 증감률 20% 이상
                averageRate(amounts: $0.netProfit) ?? 0 >= 20

                // PER 0~20배
                && overLeftAndbelowRight(target: $0.per, left: 0, right: 20)
            }
            .sorted {
                $0.dailyTrading.fluctuationRate ?? 0 > $1.dailyTrading.fluctuationRate ?? 0
            }
    }

    /**
     숨겨진 가치 기업 TOP10
     */
    func hideValue(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                // PER 0~15배
                overLeftAndbelowRight(target: $0.per, left: 0, right: 15)
  
                // PBR 0~1.5배
                && overLeftAndbelowRight(target: $0.pbr, left: 0, right: 1.5)

                // 연평균 순이익 증감률 0% 이상
                && averageRate(amounts: $0.netProfit) ?? -1 >= 0
            }
            .sorted {
                // 거래량 DESC
                $0.dailyTrading.fluctuationRate ?? 0 < $1.dailyTrading.fluctuationRate ?? 0
            }
            .prefix(10)
            .map { $0 }
    }
    
    /**
     저평가 하락 기업
     */
    func undervalueDip(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                // PER 0~15배
                overLeftAndbelowRight(target: $0.per, left: 0, right: 15)
                
                // PBR 0~1.5배
                && overLeftAndbelowRight(target: $0.pbr, left: 0, right: 1.5)
                
                // 주가 하락
                && $0.dailyTrading.fluctuationRate ?? 0 < 0
            }
            .sorted {
                // 주가 하락률 DESC
                $0.dailyTrading.fluctuationRate ?? 0 < $1.dailyTrading.fluctuationRate ?? 0
            }
            .prefix(10)
            .map { $0 }
    }
    
    /**
     안정 기업
     */
    func stability(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                // 영업이익률 5% 이상
                operatingProfitRate(operatingProfit: $0.operatingProfit, revenue: $0.revenue) ?? 0 >= 5
                
                // ROE 3% 이상
                && roe(per: $0.per, pbr: $0.pbr) ?? 0 >= 3
            }
            .sorted {
                $0.dailyTrading.fluctuationRate ?? 0 > $1.dailyTrading.fluctuationRate ?? 0
            }
    }
    
    /**
     성장 기대
     */
    func hopeGrowth(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                // 순이익 증감률 10% 이상
                prepareRate(amounts: $0.netProfit) ?? 0 >= 10
                
                // 연평균 순이익 증감률 3% 이상
                && averageRate(amounts: $0.netProfit) ?? 0 > 3
            }
            .sorted {
                $0.dailyTrading.fluctuationRate ?? 0 > $1.dailyTrading.fluctuationRate ?? 0
            }
    }
    
    /**
     성장 지속
     */
    func keepGrowth(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                // 연평균 순이익 증감률 5% 이상
                averageRate(amounts: $0.netProfit) ?? 0 >= 5
                
                // 순이익 연속 증가 3년
                && continuosGrowthIn3Year(amounts: $0.netProfit)
                
                // ROE 0% 이상
                && roe(per: $0.per, pbr: $0.pbr) ?? 0 > 0
            }
            .sorted {
                $0.dailyTrading.fluctuationRate ?? 0 > $1.dailyTrading.fluctuationRate ?? 0
            }
    }
    
    /**
     흑자 전환
     */
    func reverseProfit(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                // 순이익 음수 -> 양수 전환
                $0.netProfit?.formerTermAmount ?? 0 < 0
                && $0.netProfit?.thisTermAmount ?? 0 > 0
            }
            .sorted {
                $0.dailyTrading.fluctuationRate ?? 0 > $1.dailyTrading.fluctuationRate ?? 0
            }
    }
    
    /**
     관심 집중 TOP10
     */
    func hot(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .sorted {
                $0.dailyTrading.accumulatedTradingVolume ?? 0 > $1.dailyTrading.accumulatedTradingVolume ?? 0
            }
            .prefix(10)
            .map { $0 }
    }
    
    /**
     급상승 TOP10
     */
    func rapidRising(corporations: [ListedCorporationInfo]) -> [ListedCorporationInfo] {
        return corporations
            .filter {
                $0.dailyTrading.fluctuationRate != nil
            }
            .sorted {
                $0.dailyTrading.fluctuationRate ?? 0 > $1.dailyTrading.fluctuationRate ?? 0
            }
            .prefix(10)
            .map { $0 }
    }

    // 연속 증가 달성
    private func continuosGrowthIn3Year(amounts: PeriodicAmount?) -> Bool {
        guard let beforeFormerTermAmount = amounts?.beforeFormerTermAmount,
              let formerTermAmount = amounts?.formerTermAmount,
              let thisTermAmount = amounts?.thisTermAmount else {
            return false
        }
        let isGrowth = formerTermAmount > beforeFormerTermAmount
        return isGrowth && (thisTermAmount > formerTermAmount)
    }

    // 대비 증감률
    private func prepareRate(amounts: PeriodicAmount?) -> Double? {
        guard let formerTermAmount = amounts?.formerTermAmount,
              let thisTermAmount = amounts?.thisTermAmount else {
            return nil
        }
        return (Double(thisTermAmount) - Double(formerTermAmount)) / Double(abs(formerTermAmount))
    }
    
    // ROE
    private func roe(per: Double?, pbr: Double?) -> Double? {
        guard let per = per,
              let pbr = pbr else {
            return nil
        }
        return pbr / per
    }

    // 영업이익률 계산
    private func operatingProfitRate(operatingProfit: PeriodicAmount?, revenue: PeriodicAmount?) -> Double? {
        guard let operatingProfit = operatingProfit?.thisTermAmount,
              let revenue = revenue?.thisTermAmount else {
            return nil
        }
        return Double(operatingProfit) / Double(revenue) * 100
    }

    // 연평균 증감률 계산 (최근 3년)
    private func averageRate(amounts: PeriodicAmount?) -> Double? {
        guard let beforeFormerTermAmount = amounts?.beforeFormerTermAmount else {
            guard let formerTermAmount = amounts?.formerTermAmount,
                let thisTermAmount = amounts?.thisTermAmount else {
                return nil
            }
            return (Double(thisTermAmount) - Double(formerTermAmount)) / Double(abs(formerTermAmount))
        }

        guard let formerTermAmount = amounts?.formerTermAmount,
              let thisTermAmount = amounts?.thisTermAmount else {
            return nil
        }
        
        let firstRate = (Double(formerTermAmount) - Double(beforeFormerTermAmount)) / Double(abs(beforeFormerTermAmount))
        let secondRate = (Double(thisTermAmount) - Double(formerTermAmount)) / Double(abs(formerTermAmount))
        
        return (firstRate + secondRate) / 2
    }
    
    // left < target <= right
    private func overLeftAndbelowRight(target: Double?, left: Double, right: Double) -> Bool {
        guard let target = target else { return false }
        return target > left && target <= right
    }
    
    /**
     저평가 배지
     */
    func checkUndervalue(corporation: ListedCorporationInfo) -> Bool {
        guard let per = corporation.per,
              let pbr = corporation.pbr else {
            return false
        }
        let isGrowthPer = per > 0 && per <= 20
        let isGrowthPbr = pbr > 0 && pbr < 3
        return isGrowthPbr && isGrowthPer
    }

    /**
     성장 중 배지
     */
    func checkGrowth(corporation: ListedCorporationInfo) -> Bool {
        guard let rate = CorporationTheme.shared.prepareRate(amounts: corporation.netProfit) else { return false }
        guard let averageRate = CorporationTheme.shared.averageRate(amounts: corporation.netProfit) else { return false }
        return (rate >= 10 && averageRate >= 3) || (averageRate >= 20) //TODO: check
    }
}
