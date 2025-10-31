//
//  File.swift
//  HyperValePayment
//
//  Created by Akif Atakan Yılmaz on 31.10.2025.
//

import Foundation

public enum Validators {
    public static func isValidCardNumber(_ s: String) -> Bool {
        let digits = s.compactMap { $0.wholeNumberValue }.map(String.init).joined()
        guard digits.count >= 12 && digits.count <= 19 else { return false }
        return luhnCheck(digits)
    }

    private static func luhnCheck(_ digits: String) -> Bool {
        let reversed = digits.reversed().map { Int(String($0)) ?? 0 }
        var sum = 0
        for (i, v) in reversed.enumerated() {
            if i % 2 == 1 {
                let doubled = v * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += v
            }
        }
        return sum % 10 == 0
    }
}
