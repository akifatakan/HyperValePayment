//
//  File.swift
//  HyperValePayment
//
//  Created by Akif Atakan Yılmaz on 31.10.2025.
//

import Foundation

// Create payment intent
public struct CreatePaymentIntentRequest: Encodable {
    public let amount: Int
    public let currency: String
}

public struct CreatePaymentIntentResponse: Decodable {
    public let client_secret: String?
    public let payment_id: String?
    public let error: String?
}

// Confirm
public struct ConfirmPaymentRequest: Encodable {
    public let payment_method: String
    public let payment_method_data: PaymentMethodData

    public struct PaymentMethodData: Encodable {
        public let card: Card
    }

    public struct Card: Encodable {
        public let card_number: String
        public let card_exp_month: String
        public let card_exp_year: String
        public let card_cvc: String
        public let card_holder_name: String?
    }
}

public struct ConfirmPaymentResponse: Decodable {
    public let payment_status: String?
    public let error: String?
}
