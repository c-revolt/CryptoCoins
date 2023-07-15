//
//  CoinImageService.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 15.07.2023.
//

import SwiftUI
import Combine

final class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coinModel: CoinModel
    
    init(coin: CoinModel) {
        self.coinModel = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coinModel.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage)  in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
}
