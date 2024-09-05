//
//  ContentView.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/11/24.
//

import SwiftUI

struct CorporationListView: View {
    @EnvironmentObject var appModel: AppModel
    @StateObject var viewModel: CorporationListViewModel
    @State private var isExpanded = false

    init(theme: Theme?) {
        self._viewModel = StateObject(wrappedValue: .init(theme: theme))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.selectedTheme != nil && viewModel.selectedTheme != .all {
                themeCriteria
                    .padding()
            }
            
            HStack(spacing: 0) {
                filterDropdown
                Spacer()
                Text("\(viewModel.baseDate ?? "-") / \(viewModel.displayedCorporations.count)개 종목")
                    .padding(.trailing, 20)
            }
            
            Divider()
                .padding(.horizontal, 16)
            
            list
        }
        .onAppear() {
            viewModel.onAppear(
                corporations: appModel.computedCorporations,
                yesterday: appModel.yesterday()
            )
        }
        .background(.white)
    }
    
    private var themeCriteria: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Text("\(viewModel.selectedTheme?.description ?? "")")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                .padding(.top, 2)
                .padding(.bottom, 2)
            
            Text("\(viewModel.selectedTheme?.criteria ?? "")")
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 2)
        } label: {
            if isExpanded {
                return Text("닫기")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
                    .frame(height: 20)
            } else {
                return Text("💬 테마 설명 보기")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
                    .frame(height: 20)
            }
        }
        .padding(12)
        .background(.green.opacity(0.2))
        .cornerRadius(12)
    }

    private var filterDropdown: some View {
        Menu {
            ForEach(FilterOption.allCases) { option in
                Button(action: {
                    viewModel.dropdownButtonTapped(option: option)
                }) {
                    Text(option.displayName)
                }
            }
        } label: {
            Label(viewModel.selectedOption?.displayName ?? "정렬 선택하기", systemImage: "line.horizontal.3.decrease.circle")
                .padding()
        }
    }

    private var list: some View {
        return List(viewModel.displayedCorporations) { corporation in
            NavigationLink(
                destination: CorporationDetailView(viewModel: CorporationDetailViewModel(corporation: corporation))
            ) {
                CorporationListItem(corporation: corporation)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(viewModel.selectedTheme == .all ? "신규 상장 기업 리스트" : viewModel.selectedTheme?.title ?? "신규 상장 기업 리스트")
    }
}

class CorporationListViewModel: ObservableObject {
    @Published var displayedCorporations: [ListedCorporationInfo] = []

    var totalCorporations: [ListedCorporationInfo] = []
    var baseDate: String?
    let selectedTheme: Theme?
    var selectedOption: FilterOption?

    init(theme: Theme?) {
        self.selectedTheme = theme
    }

    func onAppear(corporations: [ListedCorporationInfo], yesterday: Date) {
        guard totalCorporations.isEmpty, !corporations.isEmpty else { return }
        self.totalCorporations = corporations
        self.displayedCorporations = selectedTheme?.corporations(corporations: corporations) ?? totalCorporations
        self.baseDate = yesterday.toStringWithPoint()
    }

    func dropdownButtonTapped(option: FilterOption) {
        self.selectedOption = option
        
        switch option {
        case .listDesc:
            displayedCorporations = displayedCorporations.sorted {
                $0.stock.listDate > $1.stock.listDate
            }
        case .listAsc:
            displayedCorporations = displayedCorporations.sorted {
                $0.stock.listDate < $1.stock.listDate
            }
        case .rateDesc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.fluctuationRate ?? 0 > $1.dailyTrading.fluctuationRate ?? 0
            }
        case .rateAsc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.fluctuationRate ?? 0 < $1.dailyTrading.fluctuationRate ?? 0
            }
        case .marketCapitalismDesc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.marketCapitalization ?? 0 > $1.dailyTrading.marketCapitalization ?? 0
            }
        case .marketCapitalismAsc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.marketCapitalization ?? 0 < $1.dailyTrading.marketCapitalization ?? 0
            }
        case .priceDesc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.todayClosingPrice ?? 0 > $1.dailyTrading.todayClosingPrice ?? 0
            }
        case .priceAsc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.todayClosingPrice ?? 0 < $1.dailyTrading.todayClosingPrice ?? 0
            }
        case .tradingVolumeDesc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.accumulatedTradingVolume ?? 0 > $1.dailyTrading.accumulatedTradingVolume ?? 0
            }
        case .tradingVolumeAsc:
            displayedCorporations = displayedCorporations.sorted {
                $0.dailyTrading.accumulatedTradingVolume ?? 0 < $1.dailyTrading.accumulatedTradingVolume ?? 0
            }
        }
    }
}

enum FilterOption: String, CaseIterable, Identifiable {
    case listDesc = "상장일 최신순"
    case listAsc = "상장일 오래된 순"
    case rateDesc = "등락률 높은 순"
    case rateAsc = "등락률 낮은 순"
    case marketCapitalismDesc = "시가총액 높은 순"
    case marketCapitalismAsc = "시가총액 낮은 순"
    case priceDesc = "종가 높은 순"
    case priceAsc = "종가 낮은 순"
    case tradingVolumeDesc = "거래량 높은 순"
    case tradingVolumeAsc = "거래량 낮은 순"

    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .listDesc:
            return "상장일 최신순"
        case .listAsc:
            return "상장일 오래된 순"
        case .rateDesc:
            return "등락률 높은 순"
        case .rateAsc:
            return "등락률 낮은 순"
        case .marketCapitalismDesc:
            return "시가총액 높은 순"
        case .marketCapitalismAsc:
            return "시가총액 낮은 순"
        case .priceDesc:
            return "종가 높은 순"
        case .priceAsc:
            return "종가 낮은 순"
        case .tradingVolumeDesc:
            return "거래량 높은 순"
        case .tradingVolumeAsc:
            return "거래량 낮은 순"
        }
    }
}
