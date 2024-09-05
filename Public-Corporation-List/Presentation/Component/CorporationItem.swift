//
//  CorporationItemView.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/23/24.
//

import SwiftUI

struct CorporationListItem: View {
    let corporation: ListedCorporationInfo
    let isSmallVersion: Bool
    
    init(corporation: ListedCorporationInfo, isSmallVersion: Bool = false) {
        self.corporation = corporation
        self.isSmallVersion = isSmallVersion
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 0) {
                // image 추가
                AsyncImage(url: URL(string: "https://downloadcdn.nhqv.com/mts/ci/ss_img_ci_\(corporation.corporation.stockCode).png")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .cornerRadius(8)
                            .padding(.trailing, 8) // 오른쪽 패딩 추가
                    } else if phase.error != nil {
                        Image(systemName: "building.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .padding(5)
                            .background(Circle().fill().foregroundColor(Color.gray.opacity(0.2)))
                            .cornerRadius(100)
                            .padding(.trailing, 8) // 오류 시 기본 이미지와 오른쪽 패딩 추가

                    } else {
                        ProgressView()
                            .frame(width: 48, height: 48)
                            .padding(.trailing, 8) // 로딩 중에도 오른쪽 패딩 추가
                    }
                }
                
                /**
                 기업 정보: 종목명, 기업명(정식명칭)
                 */
                VStack(alignment: .leading, spacing: 4) {
                    Text(corporation.stock.issueName)
                        .font(isSmallVersion ? .headline : .title2)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                    
                    Text(corporation.corporation.corpName)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.bottom, 2)

            /**
             배지
             */
            if !corporation.badges.isEmpty {
                HFlow(alignment: .center, itemSpacing: 4, rowSpacing: 4) {
                    ForEach(corporation.badges, id: \.self) { badge in
                        Text(badge.title)
                            .font(.system(size: isSmallVersion ? 12 : 14, weight: .semibold))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(badge.colors.background)
                            .foregroundColor(badge.colors.text)
                            .cornerRadius(100)
                    }
                }
                .padding(.bottom, 4)
            }

            HStack {
                Spacer()
                
                /**
                 종가
                 */
                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text(corporation.dailyTrading.fluctuationRate?.toStringWithPercent() ?? "-")
                        .font(isSmallVersion ? .body : .headline)
                        .foregroundColor(corporation.dailyTrading.fluctuationRate.color())
                    
                    Text(corporation.dailyTrading.todayClosingPrice?.toWonString() ?? "-")
                        .font(isSmallVersion ? .body : .title3)
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
        .background(Color(UIColor.white))
    }
}
