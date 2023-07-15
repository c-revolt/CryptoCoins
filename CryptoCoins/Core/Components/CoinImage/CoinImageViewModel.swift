//
//  CoinImageViewModel.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 15.07.2023.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coinModel: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinModel = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSuscribers()
        self.isLoading = true
    }
    
    private func addSuscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
