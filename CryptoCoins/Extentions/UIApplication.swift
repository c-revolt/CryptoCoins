//
//  UIApplication.swift
//  CryptoCoins
//
//  Created by Александр Прайд on 17.07.2023.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
