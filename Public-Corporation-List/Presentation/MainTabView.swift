//
//  MainTabView.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/24/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appModel: AppModel
    @State var currentTab = 0
    
    var body: some View {
        content
            .background(.white)
    }
    
    @ViewBuilder
    private var content: some View {
        if appModel.isLoading {
            loadingView
        } else {
            mainView
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
    
    private var mainView: some View {
        TabView(selection: $currentTab) {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(0)
            
            FavoritesView()
                .tabItem {
                    Label("관심 종목", systemImage: "heart.fill")
                }
                .tag(1)
            }
        }
}
