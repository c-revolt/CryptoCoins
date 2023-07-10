//
//  CryptoCoinsApp.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 07.07.2023.
//

import SwiftUI

@main
struct CryptoCoinsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
