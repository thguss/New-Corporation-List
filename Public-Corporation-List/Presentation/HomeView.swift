//
//  HomeView.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/23/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appModel: AppModel
    
    var body: some View {
        if appModel.isLoading {
            loadingView
        } else {
            content
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 6) {
            ProgressView(value: appModel.progress)
            
            if !appModel.computedCorporations.isEmpty {
                Text("\(appModel.computedCorporations.count)개의 기업 분석 중")
            } else {
                Text("기업 정보 분석을 위해 XML 파일 파싱 중입니다.")
            }
        }
        .padding(.horizontal, 16)
    }

    var content: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    Text("신규 상장 종목 투자 가이드\n(KOSDAQ)")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 20)

                    randomStock
                        .padding(.bottom, 30)

                    Text("어떤 종목을 찾으시나요?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    Text("저평가 종목")
                        .font(.headline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(5)

                    undervalueStocks
                        .padding(.bottom, 20)

                    Text("성장 종목")
                        .font(.headline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(5)
                    
                    growthStocks
                        .padding(.bottom, 20)
                    
                    Text("트렌드 종목")
                        .font(.headline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(5)
                    
                    trendStocks
                        .padding(.bottom, 20)

                    Text("기타 종목")
                        .font(.headline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(5)
                    
                    ectStocks
                    
                    Color.clear.frame(height: 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 16)
            }
        }
    }
    
    var ectStocks: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                CardView(
                    iconName: "arrowtriangle.right.circle.fill",
                    iconColor: .pink,
                    themeType: .turningProfit
                )
                CardView(
                    iconName: "magnifyingglass.circle.fill",
                    iconColor: .orange,
                    themeType: .stability
                )
            }
            
            CardView(
                iconName: "arrow.up.arrow.down.circle",
                iconColor: .green,
                themeType: .all,
                isHorizontal: true
            )
        }
    }

    var trendStocks: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                CardView(
                    iconName: "bolt.fill",
                    iconColor: .yellow,
                    themeType: .hotIssue
                )
                CardView(
                    iconName: "chart.bar.fill",
                    iconColor: .red,
                    themeType: .surge
                )
            }
        }
    }

    var growthStocks: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                CardView(
                    iconName: "flame.fill",
                    iconColor: .pink,
                    themeType: .expectedGrowth
                )
                CardView(
                    iconName: "arrow.up.forward.circle.fill",
                    iconColor: .orange,
                    themeType: .continuousGrowth
                )
            }
        }
    }

    var undervalueStocks: some View {
        VStack(spacing: 16) {
            CardView(
                iconName: "magnifyingglass.circle.fill",
                iconColor: .blue,
                themeType: .hiddenValue,
                isHorizontal: true
            )
            
            HStack(spacing: 16) {
                CardView(
                    iconName: "chart.line.uptrend.xyaxis",
                    iconColor: .pink,
                    themeType: .undervaluedGrowth
                )
                CardView(
                    iconName: "arrow.down.forward.circle.fill",
                    iconColor: .blue,
                    themeType: .undervaluedDecline
                )
            }
        }
    }

    var randomStock: some View {
        VStack {
            HStack(alignment: .top, spacing: 0) {
                Text("오늘의 종목을 랜덤으로 구경해보세요")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 6)
                
                Spacer()
                
                Button(action: {
                    appModel.rerollRandomCorp()
                }) {
                    Image(systemName: "shuffle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }

            if let corp = appModel.randomPickCorp {
                NavigationLink(
                    destination: CorporationDetailView(viewModel: CorporationDetailViewModel(corporation: corp))
                ) {
                    CorporationListItem(
                        corporation: corp,
                        isSmallVersion: true
                    )
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.bottom, 14)
                }
            } else {
                Button(action: {
                    appModel.rerollRandomCorp()
                }) {
                    VStack {
                        Text("오른쪽 위 초록색 랜덤 버튼을 클릭해보세요.")
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }
    }
}

struct CardView: View {
    var iconName: String
    var iconColor: Color
    var themeType: Theme
    var isHorizontal: Bool
    
    init(
        iconName: String,
        iconColor: Color,
        themeType: Theme,
        isHorizontal: Bool = false
    ) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.themeType = themeType
        self.isHorizontal = isHorizontal
    }
    
    var body: some View {
        let screenWithoutPadding = UIScreen.main.bounds.width - 2 * 16
        let size = screenWithoutPadding - 16
        let cardSize = isHorizontal ? screenWithoutPadding : size / 2
        
        NavigationLink(
            destination: CorporationListView(theme: themeType)
        ) {
            VStack(alignment: .leading, spacing: 0) {
                Text(themeType.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                    .padding(.bottom, 8)
                
                Text(themeType.description)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image(systemName: iconName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(iconColor)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(
                width: cardSize,
                height: isHorizontal ? ((cardSize - 80) / 2) : cardSize
            )
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
    }
}
