//
//  SettingsView.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 15.08.2023.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")
    let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")
    let coingeckoURL = URL(string: "https://www.coingecko.com")
    let twitterURL = URL(string: "https://twitter.com/_cRevolt")
    let githubURL = URL(string: "https://github.com/c-revolt/CryptoCoins")
    
    var body: some View {
        
        NavigationStack {
            List {
                courseSection
                apiSection
                developerSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    
    private var courseSection: some View {
        Section(header: Text("Completed course")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MAVVM Architecture, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("🖥 Watch the course on YouTube", destination: youtubeURL!)
        }
    }
    
    private var apiSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("🦎 Visit CoinGecko", destination: coingeckoURL!)
        }
    }
    
    private var developerSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("twitterlogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by @cRevolt. It uses SwiftUI and is written 100% in Swift. The project benefits multi-threading, publishers/subsribers, and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("🐦 Follow me on Twitter", destination: twitterURL!)
            Link("🐱 Check my GitHub", destination: githubURL!)
        }
    }
    
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: defaultURL!)
            Link("Privacy Policy", destination: defaultURL!)
            Link("Company Website", destination: defaultURL!)
            Link("Learn More", destination: defaultURL!)
        }
    }
}
