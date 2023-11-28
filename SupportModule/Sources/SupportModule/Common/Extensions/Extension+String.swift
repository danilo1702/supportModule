//
//  Extension+String.swift
//
//
//  Created by Danilo Hernandez on 17/11/23.
//

import Foundation

extension String {
    func parseToCGFloat() -> CGFloat {
        if let number = NumberFormatter().number(from: self) {
            let numberCgFloat = CGFloat(truncating: number)
            return numberCgFloat
        } else {
            return 0
        }
    }
}

