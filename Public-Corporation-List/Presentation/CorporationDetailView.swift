//
//  CorporationDetailView.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/15/24.
//

import SwiftUI
import Charts

struct CorporationDetailView: View {
    @EnvironmentObject var appModel: AppModel
    @StateObject var viewModel: CorporationDetailViewModel
    @State private var selectedMetric: Metric = .revenue

    var body: some View {
        content
    }

    private var content: some View {
        ScrollView {
            VStack {
                corporationView
                
                Text("상장일과 어떻게 달라졌나요?")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                Divider()
                    .padding(.horizontal, 16)
                
                growthRateView
                
                Divider()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                
                Spacer()
                
                chartView
                
                Spacer()
            }
        }
    }
    
    /**
     지표 성장률(상장일 vs 현재) view
     */
    private var growthRateView: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Text("/")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text("시가")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text("종가")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text("PER")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text("PBR")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text("ROE")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
            }
            .padding(.leading)
            
            Spacer()
            
            VStack {
                Text("상장일")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.listOpeningPrice?.toWonString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.listClosingPrice?.toWonString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.listPer?.toString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.listPbr?.toString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.roe(pbr: viewModel.listPbr, per: viewModel.listPer)?.toString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
            }
            
            
            Spacer()
            
            VStack {
                Text("현재")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.corporation.dailyTrading.todayOpeningPrice?.toWonString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.corporation.dailyTrading.todayClosingPrice?.toWonString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.corporation.per?.toString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.corporation.pbr?.toString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.roe(pbr: viewModel.corporation.pbr, per: viewModel.corporation.per)?.toString() ?? "-")
                    .padding(.vertical)
                    .lineLimit(1)
            }

            Spacer()

            VStack {
                Text("대비")
                    .bold()
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.growthRateForInt(
                    before: viewModel.listOpeningPrice,
                    after: viewModel.corporation.dailyTrading.todayOpeningPrice
                )?.toStringWithPercent() ?? "-")
                    .foregroundColor(viewModel.colorByRate(
                        rate: viewModel.growthRateForInt(
                            before: viewModel.listOpeningPrice,
                            after: viewModel.corporation.dailyTrading.todayOpeningPrice
                        )
                    ))
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.growthRateForInt(
                    before: viewModel.listClosingPrice,
                    after: viewModel.corporation.dailyTrading.todayClosingPrice
                )?.toStringWithPercent() ?? "-")
                    .foregroundColor(viewModel.colorByRate(
                        rate: viewModel.growthRateForInt(
                            before: viewModel.listClosingPrice,
                            after: viewModel.corporation.dailyTrading.todayClosingPrice
                        )
                    ))
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.growthRateForDouble(
                    before: viewModel.listPer,
                    after: viewModel.corporation.per
                )?.toStringWithPercent() ?? "-")
                    .foregroundColor(viewModel.colorByRate(
                        rate: viewModel.growthRateForDouble(
                            before: viewModel.listPer,
                            after: viewModel.corporation.per
                        )
                    ))
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.growthRateForDouble(
                    before: viewModel.listPbr,
                    after: viewModel.corporation.pbr
                )?.toStringWithPercent() ?? "-")
                    .foregroundColor(viewModel.colorByRate(
                        rate: viewModel.growthRateForDouble(
                            before: viewModel.listPbr,
                            after: viewModel.corporation.pbr
                        )
                    ))
                    .padding(.vertical)
                    .lineLimit(1)
                
                Text(viewModel.growthRateForDouble(
                    before: viewModel.roe(pbr: viewModel.listPbr, per: viewModel.listPer),
                    after: viewModel.roe(pbr: viewModel.corporation.pbr, per: viewModel.corporation.per)
                )?.toStringWithPercent() ?? "-")
                    .foregroundColor(viewModel.colorByRate(
                        rate: viewModel.growthRateForDouble(
                            before: viewModel.roe(pbr: viewModel.listPbr, per: viewModel.listPer),
                            after: viewModel.roe(pbr: viewModel.corporation.pbr, per: viewModel.corporation.per)
                        )
                    ))
                    .padding(.vertical)
                    .lineLimit(1)
            }
            
            Spacer()
        }
    }

    /**
     기업 정보 view
     */
    private var corporationView: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Spacer()
                    Text("\(viewModel.corporation.corporation.corpName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    favoriteButton
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("상장일: \(viewModel.corporation.stock.listDate.toDateString() ?? "-")")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
        }
        .padding()
    }

    private var favoriteButton: some View {
        let corpCode = viewModel.corporation.corporation.corpCode
        let isAlreadyFavorites = appModel.favorites.contains { $0.corporation.corpCode == corpCode }
        return Button(action: {
            if isAlreadyFavorites {
                appModel.removeFromFavorites(corpCode: corpCode)
            } else {
                appModel.saveAsFavorite(corpCode: corpCode)
            }
        }) {
            Image(systemName: isAlreadyFavorites ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: 20)
        }
        .buttonStyle(.plain)
    }

    /**
     차트 view
     */
    private var chartView: some View {
        VStack {
            Text("차트로 최근 3년 재무지표를 확인해보세요")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            chartPeeker
            corporationAmount
            chart
        }
    }

    /**
     재무지표 view
     */
    @ViewBuilder
    private var corporationAmount: some View {
        let amountData = viewModel.amountDataForMetric(selectedMetric)
        let lastYear = Calendar.current.component(.year, from: Date()) - 1
        
        HStack(spacing: 16) { // 간격을 조정할 수 있도록 spacing 추가
                VStack(alignment: .center, spacing: 8) {
                    Text("\(String(lastYear - 2))년")
                        .font(.system(size: 14)) // 텍스트 크기를 조정
                        .bold()
                        .foregroundColor(.black)
                    Text("\(amountData?.beforeFormerTermAmount?.toTenThousandsString() ?? "-")")
                        .font(.system(size: 14)) // 텍스트 크기를 조정
                        .lineLimit(1) // 한 줄로 나타내기
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                VStack(alignment: .center, spacing: 8) {
                    Text("\(String(lastYear - 1))년")
                        .font(.system(size: 14)) // 텍스트 크기를 조정
                        .bold()
                        .foregroundColor(.black)
                    Text("\(amountData?.formerTermAmount?.toTenThousandsString() ?? "-")")
                        .font(.system(size: 14)) // 텍스트 크기를 조정
                        .lineLimit(1) // 한 줄로 나타내기
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                VStack(alignment: .center, spacing: 8) {
                    Text("\(String(lastYear))년")
                        .font(.system(size: 14)) // 텍스트 크기를 조정
                        .bold()
                        .foregroundColor(.black)
                    Text("\(amountData?.thisTermAmount?.toTenThousandsString() ?? "-")")
                        .font(.system(size: 14)) // 텍스트 크기를 조정
                        .lineLimit(1) // 한 줄로 나타내기
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 20) // 좌우 여백 추가
            .padding(.vertical, 10)   // 상하 여백 추가
    }
    
    /**
     차트 지표 정보 view
     */
    private var chartPeeker: some View {
        Picker("Select Metric", selection: $selectedMetric) {
            ForEach(Metric.allCases, id: \.self) { metric in
                Text(metric.rawValue)
                    .tag(metric)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    /**
     차트 정보 view
     */
    @ViewBuilder
    private var chart: some View {
        let data = viewModel.dataForMetric(selectedMetric)
        
        Chart {
            ForEach(data, id: \.x) { entry in
                LineMark(
                    x: .value("period", entry.x),
                    y: .value("amount", entry.y)
                )
            }
        }
        .chartYAxis {
            AxisMarks(preset: .extended) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel() {
                    if let amount = value.as(Int.self) {
                        Text("\(amount)")
                            .foregroundColor(amount >= 0 ? .red : .blue)
                    }
                }
            }
        }
        .frame(height: 250)
        .padding(.horizontal, 35) // 좌우 여백 추가
    }
}

class CorporationDetailViewModel: ObservableObject {
    @Published var corporation: ListedCorporationInfo

    @Published var listOpeningPrice: Int?
    @Published var listClosingPrice: Int?
    @Published var listPer: Double?
    @Published var listPbr: Double?
    var marketCapitalization: Int?

    init(corporation: ListedCorporationInfo) {
        self.corporation = corporation
        fetchListDateInfo()
    }

    func fetchListDateInfo() {
        Task {
            do {
                // 일별 매매 정보
                async let fetchedDailyTradings = try await GetDailyTradingAPI.shared.fetch(baseDate: corporation.stock.listDate)
                
                // 재무지표 정보
                async let fetchedFinancialAccounts = try await GetFinancialMultipleAccountAPI.shared.fetch(
                    corpCodes: corporation.corporation.corpCode,
                    businessYear: corporation.stock.listDate.extractYear()
                )
                
                let (dailyTradings, financialAccounts) = try await (fetchedDailyTradings, fetchedFinancialAccounts)
                
                let dailyTradingDict = Dictionary.init(grouping: dailyTradings) { trading in
                    trading.issueCode
                }
                
                let accountDict = Dictionary.init(grouping: financialAccounts) { account in
                    account.corpCode
                }
                
                if let dailyTrading = dailyTradingDict[corporation.stock.issueShortCode]?.first {
                    await MainActor.run {
                        self.listOpeningPrice = dailyTrading.todayOpeningPrice
                        self.listClosingPrice = dailyTrading.todayClosingPrice
                        self.marketCapitalization = dailyTrading.marketCapitalization
                    }
                }

                if let reports = accountDict[corporation.corporation.corpCode] {
                    let netProfit = reports.first { $0.accountName == "당기순이익" }?.thisTermAmount
                    let totalAssets = reports.first { $0.accountName == "자산총계" }?.thisTermAmount

                    await MainActor.run {
                        if let netProfit = netProfit, let marketCapitalization = marketCapitalization {
                            self.listPer = Double(marketCapitalization) / Double(netProfit)
                        }
                        
                        if let totalAssets = totalAssets, let marketCapitalization = marketCapitalization {
                            self.listPbr = Double(marketCapitalization) / Double(totalAssets)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }

    /**
     성장률 구하기
     */
    func growthRateForInt(before: Int?, after: Int?) -> Double? {
        guard let before = before else {
            return nil
        }
        guard let after = after else {
            return nil
        }
        return (Double(after) - Double(before)) / Double(before) * 100
    }
    
    func growthRateForDouble(before: Double?, after: Double?) -> Double? {
        guard let before = before else {
            return nil
        }
        guard let after = after else {
            return nil
        }
        return ((after - before) / abs(before)) * 100
    }

    /**
     등락 결과에 따라 색 반환
     */
    func colorByRate(rate: Double?) -> Color {
        guard let rate = rate else {
            return .black
        }
        if rate == 0.0 {
            return .black
        } else {
            return rate > 0 ? .red : .blue
        }
    }

    /**
     차트 옵션 (in picker)
     */
    func amountDataForMetric(_ metric: Metric) -> PeriodicAmount? {
        var corpAmount: PeriodicAmount?
        
        switch metric {
        case .revenue:
            corpAmount = corporation.revenue
        case .operatingProfit:
            corpAmount = corporation.operatingProfit
        case .netProfit:
            corpAmount = corporation.netProfit
        case .totalAssets:
            corpAmount = corporation.totalAssets
        }
        
        return corpAmount
    }
    
    /**
     차트 그리기
     */
    func dataForMetric(_ metric: Metric) -> [ChartData] {
        var chart: [ChartData] = []
        let lastYear = lastYear()

        switch metric {

        // 매출액
        case .revenue:
            if let beforeFormerTermAmount = corporation.revenue?.beforeFormerTermAmount {
                chart.append(ChartData(period: String(lastYear - 2), amount: beforeFormerTermAmount))
            }
            if let formerTermAmount = corporation.revenue?.formerTermAmount {
                chart.append(ChartData(period: String(lastYear - 1), amount: formerTermAmount))
            }
            if let thisTermAmount = corporation.revenue?.thisTermAmount {
                chart.append(ChartData(period: String(lastYear), amount: thisTermAmount))
            }

        // 영업이익
        case .operatingProfit:
            if let beforeFormerTermAmount = corporation.operatingProfit?.beforeFormerTermAmount {
                chart.append(ChartData(period: String(lastYear - 2), amount: beforeFormerTermAmount))
            }
            if let formerTermAmount = corporation.operatingProfit?.formerTermAmount {
                chart.append(ChartData(period: String(lastYear - 1), amount: formerTermAmount))
            }
            if let thisTermAmount = corporation.operatingProfit?.thisTermAmount {
                chart.append(ChartData(period: String(lastYear), amount: thisTermAmount))
            }

        // 당기순이익
        case .netProfit:
            if let beforeFormerTermAmount = corporation.netProfit?.beforeFormerTermAmount {
                chart.append(ChartData(period: String(lastYear - 2), amount: beforeFormerTermAmount))
            }
            if let formerTermAmount = corporation.netProfit?.formerTermAmount {
                chart.append(ChartData(period: String(lastYear - 1), amount: formerTermAmount))
            }
            if let thisTermAmount = corporation.netProfit?.thisTermAmount {
                chart.append(ChartData(period: String(lastYear), amount: thisTermAmount))
            }

        // 자산총계
        case .totalAssets:
            if let beforeFormerTermAmount = corporation.totalAssets?.beforeFormerTermAmount {
                chart.append(ChartData(period: String(lastYear - 2), amount: beforeFormerTermAmount))
            }
            if let formerTermAmount = corporation.totalAssets?.formerTermAmount {
                chart.append(ChartData(period: String(lastYear - 1), amount: formerTermAmount))
            }
            if let thisTermAmount = corporation.totalAssets?.thisTermAmount {
                chart.append(ChartData(period: String(lastYear), amount: thisTermAmount))
            }
        }
        
        return chart
    }
    
    // ROE 구하기
    func roe(pbr: Double?, per: Double?) -> Double? {
        guard let pbr = pbr,
              let per = per else {
            return nil
        }
        return pbr / per
    }
    
    // 작년 값 구하기
    private func lastYear() -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - 1
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let x: String  // 기간(x축)
    let y: Int     // 금액(y축)
    
    init(period: String, amount: Int) {
        self.x = period
        self.y = amount / 10000000 // 만원 단위
    }
}

enum Metric: String, CaseIterable {
    case revenue = "매출액"
    case operatingProfit = "영업이익"
    case netProfit = "당기순이익"
    case totalAssets = "자산총계"
}
