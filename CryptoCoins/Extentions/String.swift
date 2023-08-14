//
//  String.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 14.08.2023.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
