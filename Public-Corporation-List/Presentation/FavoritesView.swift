//
//  FavoritesView.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/24/24.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        NavigationView {
            if appModel.favorites.isEmpty {
                Text("관심 종목을 등록해보세요")
            } else {
                list
            }
        }
        .onAppear() {
            appModel.loadFavorites()
        }
    }
    
    private var list: some View {
        return List(appModel.favorites) { corporation in
            NavigationLink(
                destination: CorporationDetailView(viewModel: CorporationDetailViewModel(corporation: corporation))
            ) {
                CorporationListItem(corporation: corporation)
            }
        }
        .listStyle(PlainListStyle())
    }
}
