//
//  CryptoCoinsApp.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 07.07.2023.
//

import SwiftUI

@main
struct CryptoCoinsApp: App {
    
    @StateObject private var viewmodel = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(viewmodel)
        }
    }
}
