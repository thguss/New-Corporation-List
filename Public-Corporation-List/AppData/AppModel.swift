//
//  AppModel.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/22/24.
//

import SwiftUI

public class AppModel: ObservableObject {
    @Published var isLoading = true
    @Published var computedCorporations: [ListedCorporationInfo] = []
    @Published var progress: Double = 0.0
    @Published var randomPickCorp: ListedCorporationInfo?
    @Published var favorites: [ListedCorporationInfo] = []

    private var totalCorporations: [ListedCorporationInfo] = []
    private var isLoadingMorePage = false
    private var currentPage = 0
    private let itemsPerPage = 100

    func fetch() {
        Task {
            do {
                /**
                 LAZY 호출
                 - 전체 기업 조회
                 - 최근 5년 내 신규 상장 기업 조회
                 - 일별 매매 정보 조회
                 */
                async let fetchedCorporations = try await GetCorporationAPI.shared.fetchCompanies()
                async let fetchedStocks = try await GetStockAPI.shared.fetch(baseDate: yesterday().toString())
                    .filter{$0.listDate >= fiveYearsAgo()}
                async let fetchedDailyTradings = try await GetDailyTradingAPI.shared.fetch(baseDate: yesterday().toString())
                
                let (corporations, stocks, dailyTradings) = try await (fetchedCorporations, fetchedStocks, fetchedDailyTradings)

                let listedCorporations = listedCorporations(
                    corporations: corporations,
                    stocks: stocks,
                    dailyTradings: dailyTradings
                )
                
                await MainActor.run {
                    self.totalCorporations = listedCorporations
                    self.loadInfoInSequence()
                    self.progress = 30 / Double(totalCorporations.count)
                }
            } catch {
                print(error)
            }
        }
    }

    /**
     pagination 기법으로 단위별로 데이터 호출
     */
    func loadInfoInSequence() {
        guard !isLoadingMorePage else { return }
        
        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, totalCorporations.count)
        
        guard startIndex < endIndex else { return }
        
        self.isLoadingMorePage = true
        
        Task {
            let newItems = totalCorporations[startIndex..<endIndex]
            let query = newItems.map { $0.corporation.corpCode }.joined(separator: ",")
            
            // 다중회사 재무지표
            let accounts = try await GetFinancialMultipleAccountAPI.shared.fetch(corpCodes: query, businessYear: lastYear())
            
            let accountDict = Dictionary.init(grouping: accounts) { account in
                account.corpCode
            }
            
            let filledItems = newItems.compactMap { item -> ListedCorporationInfo? in
                guard let reports = accountDict[item.corporation.corpCode] else { return nil }
                
                let totalAssets = reports.first { $0.accountName == "자산총계" }
                let revenue = reports.first { $0.accountName == "매출액" }
                let operatingProfit = reports.first { $0.accountName == "영업이익" }
                let netProfit = reports.first { $0.accountName == "당기순이익" }
                
                if (totalAssets == nil || revenue == nil || operatingProfit == nil || netProfit == nil) { return nil }
                
                let marketCapitalization = item.dailyTrading.marketCapitalization
                let thisTermNetProfit = netProfit?.thisTermAmount
                let thistTermTotalAssets = totalAssets?.thisTermAmount
                
                let item = ListedCorporationInfo(
                    corporation: item.corporation,
                    stock: item.stock,
                    dailyTrading: item.dailyTrading,
                        
                    totalAssets: .init(
                        thisTermAmount: totalAssets?.thisTermAmount,
                        formerTermAmount: totalAssets?.formerTermAmount,
                        beforeFormerTermAmount: totalAssets?.beforeFormerTermAmount
                    ),

                    revenue: .init(
                        thisTermAmount: revenue?.thisTermAmount,
                        formerTermAmount: revenue?.formerTermAmount,
                        beforeFormerTermAmount: revenue?.beforeFormerTermAmount
                    ),

                    operatingProfit: .init(
                        thisTermAmount: operatingProfit?.thisTermAmount,
                        formerTermAmount: operatingProfit?.formerTermAmount,
                        beforeFormerTermAmount: operatingProfit?.beforeFormerTermAmount
                    ),

                    netProfit: .init(
                        thisTermAmount: netProfit?.thisTermAmount,
                        formerTermAmount: netProfit?.formerTermAmount,
                        beforeFormerTermAmount: netProfit?.beforeFormerTermAmount
                    ),
                    
                    per: per(marketCapitalization: marketCapitalization, netProfit: thisTermNetProfit),
                    pbr: pbr(marketCapitalization: marketCapitalization, totalAssets: thistTermTotalAssets)
                )

                return item
            }

            await MainActor.run {
                self.computedCorporations.append(contentsOf: filledItems)
                self.currentPage += 1
                self.isLoadingMorePage = false
                self.updateProgress()
                
                if endIndex < self.totalCorporations.count {
                    self.loadInfoInSequence()
                } else {
                    appendBadges()
                }
            }
        }
    }
    
    /**
     관심 집중, 급상승 TOP10 배지 붙이기
     */
    func appendBadges() {
        Task {
            // 급상승 Top10
            let rapidRisingCoporations = CorporationTheme.shared.rapidRising(corporations: computedCorporations)
            
            // 거래량 Top10
            let hotCorporations = CorporationTheme.shared.hot(corporations: computedCorporations)
            
            let badgeAddedCorporations = computedCorporations.map { corporation in
                var badges: [Badge] = []

                if CorporationTheme.shared.checkUndervalue(corporation: corporation) {
                    badges.append(Badge.undervalue)
                }

                if CorporationTheme.shared.checkGrowth(corporation: corporation) {
                    badges.append(Badge.growth)
                }

                // Top 10 ~ 30
                if let volume = corporation.dailyTrading.accumulatedTradingVolume,
                   let index = hotCorporations.firstIndex(of: corporation),
                   index <= 30 {
                    badges.append(.hot)
                }

                // Top 10 ~ 30
                if let volume = corporation.dailyTrading.fluctuationRate,
                   let index = rapidRisingCoporations.firstIndex(of: corporation),
                   index <= 30 {
                    badges.append(.rapidRise)
                }

                return corporation.copyWithBadges(badges: badges)
            }
            
            await MainActor.run {
                computedCorporations = badgeAddedCorporations
                isLoading = false
            }
        }
    }
    
    /**
     신규 상장한 기업 정보 조회
     */
    func listedCorporations(
        corporations: [CorporationInfo],
        stocks: [StockInfo],
        dailyTradings: [DailyTradingInfo]
    ) -> [ListedCorporationInfo] {
        
        // 상장 정보
        let stockDict = Dictionary.init(grouping: stocks) { stock in
            stock.issueShortCode
        }

        // 일별 매매 정보
        let dailyTradingDict = Dictionary.init(grouping: dailyTradings) { trading in
            trading.issueCode
        }

        return corporations.compactMap { corporation in
            guard let stock = stockDict[corporation.stockCode]?.first else {
                return nil
            }
            
            guard let dailyTrading = dailyTradingDict[corporation.stockCode]?.first else {
                return nil
            }
 
            return ListedCorporationInfo(
                corporation: corporation,
                stock: stock,
                dailyTrading: dailyTrading
            )
        }
        .sorted(by: {$0.stock.listDate > $1.stock.listDate}) // 상장일 기준으로 내림차순 정렬
    }
    
    /**
     어제 날짜 구하기 (yyyyMMdd)
     */
    func yesterday() -> Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    }

    /**
     ProgressBar 업데이트
     */
    private func updateProgress() { // 30: 임의 상수
        let totalItems = totalCorporations.count + 30
        let loadedItems = currentPage * itemsPerPage + 30
        self.progress = min(Double(loadedItems) / Double(totalItems), 1.0)
    }

    /**
     PER = 시가총액 / 당기순이익
     */
    private func per(marketCapitalization: Int?, netProfit: Int?) -> Double? {
        guard let marketCapitalization, let netProfit else {
            return nil
        }

        return Double(marketCapitalization) / Double(netProfit)
    }

    /**
     PBR = 시가총액 / 자산총계
     */
    private func pbr(marketCapitalization: Int?, totalAssets: Int?) -> Double? {
        guard let marketCapitalization, let totalAssets else {
            return nil
        }
        
        return Double(marketCapitalization) / Double(totalAssets)
    }
    
    /**
     5년 전 날짜 구하기 (yyyyMMdd)
     */
    private func fiveYearsAgo() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let fiveYearsAgoDate = Calendar.current.date(byAdding: .year, value: -5, to: today)!
        return dateFormatter.string(from: fiveYearsAgoDate)
    }
    
    /**
     작년 구하기
     */
    func lastYear() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let lastYear = currentYear - 1
        return String(lastYear)
    }
    
    func rerollRandomCorp() {
        withAnimation {
            self.randomPickCorp = computedCorporations.randomElement()
        }
    }
}

extension AppModel {
    func loadFavorites() {
        let corpCodes = UserDefaults.standard.getStringArray()
        self.favorites = computedCorporations.filter {
            corpCodes.contains($0.corporation.corpCode)
        }
    }
    
    func saveAsFavorite(corpCode: String) {
        var corpCodes = UserDefaults.standard.getStringArray()
        if !corpCodes.contains(corpCode) {
            corpCodes.append(corpCode)
        }
        UserDefaults.standard.saveStringArray(corpCodes)
        self.favorites = computedCorporations.filter {
            corpCodes.contains($0.corporation.corpCode)
        }
    }
    
    func removeFromFavorites(corpCode: String) {
        var corpCodes = UserDefaults.standard.getStringArray()
        corpCodes.removeAll { $0 == corpCode }
        UserDefaults.standard.saveStringArray(corpCodes)
        self.favorites = computedCorporations.filter {
            corpCodes.contains($0.corporation.corpCode)
        }
    }
}

extension UserDefaults {
    
    private var userDefaultsKey: String {
        return "favorites"
    }
    
    func saveStringArray(_ array: [String]) {
        self.set(array, forKey: userDefaultsKey)
    }
    
    func getStringArray() -> [String] {
        return self.stringArray(forKey: userDefaultsKey) ?? []
    }
    
    func addStringToArray(_ newString: String) {
        var currentArray = self.getStringArray()
        currentArray.append(newString)
        self.saveStringArray(currentArray)
    }
    
    func removeStringFromArray(_ stringToRemove: String) {
        var currentArray = self.getStringArray()
        if let index = currentArray.firstIndex(of: stringToRemove) {
            currentArray.remove(at: index)
        }
        self.saveStringArray(currentArray)
    }
}
