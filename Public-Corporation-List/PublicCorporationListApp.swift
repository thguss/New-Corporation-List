//
//  PublicCorporationListApp.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/22/24.
//

import SwiftUI

@main
struct PublicCorporationListApp: App {
    let appModel = AppModel()
    
    init() {
        appModel.fetch()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appModel)
        }
    }
}
