//
//  HomeViewModel.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 12.07.2023.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
    
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filteringCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // update portfolio coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filteringCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolionCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCup = StatisticModel(
            title: "Market Cup",
            value: data.marketCup,
            percentageChange: data.marketCapChangePercentage24HUsd
        )
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previosValue = portfolionCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let persentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previosValue = currentValue / (1 + persentChange)
                return previosValue
            }
            .reduce(0, +)
        
        let percentegeChange = ((portfolioValue - previosValue) / previosValue) * 100
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentegeChange
        )
        
        stats.append(contentsOf: [
            marketCup,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
        
    }
}
