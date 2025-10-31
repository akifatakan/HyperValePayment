// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public enum HyperValeError: Error, LocalizedError {
    case invalidURL
    case serverError(String)
    case networkError(Error)
    case validationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .serverError(let s): return s
        case .networkError(let e): return e.localizedDescription
        case .validationFailed(let s): return s
        }
    }
}

/// Public client configuration — merchant must provide a server baseURL.
/// IMPORTANT: Do not put provider API keys here.
public struct HyperValeConfig {
    public let merchantServerBaseURL: URL
    public let sandbox: Bool

    public init(merchantServerBaseURL: URL, sandbox: Bool = true) {
        self.merchantServerBaseURL = merchantServerBaseURL
        self.sandbox = sandbox
    }
}

@MainActor
public final class HyperValeClient: ObservableObject {
    public let config: HyperValeConfig
    private let network: NetworkClient

    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var lastError: HyperValeError?
    @Published public private(set) var lastPaymentID: String?

    public init(config: HyperValeConfig, networkClient: NetworkClient? = nil) {
        self.config = config
        self.network = networkClient ?? NetworkClient()
    }

    /// Prepare (create-payment-intent) — calls merchant server
    public func preparePayment(amount: Int, currency: String) async -> Result<CreatePaymentIntentResponse, HyperValeError> {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        let url = config.merchantServerBaseURL.appendingPathComponent("/create-payment-intent")
        let payload = CreatePaymentIntentRequest(amount: amount, currency: currency)
        do {
            let resp: CreatePaymentIntentResponse = try await network.postJSON(to: url, body: payload)
            if let pid = resp.payment_id {
                lastPaymentID = pid
                return .success(resp)
            } else {
                let msg = resp.error ?? "No payment_id returned"
                let err = HyperValeError.serverError(msg)
                lastError = err
                return .failure(err)
            }
        } catch {
            let err = HyperValeError.networkError(error)
            lastError = err
            return .failure(err)
        }
    }

    /// Confirm payment: send card data to merchant server for confirm endpoint
    public func confirmPayment(paymentID: String, card: ConfirmPaymentRequest.Card) async -> Result<ConfirmPaymentResponse, HyperValeError> {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        // Basic client-side validation (not exhaustive)
        if !Validators.isValidCardNumber(card.card_number) {
            let err = HyperValeError.validationFailed("Invalid card number")
            lastError = err
            return .failure(err)
        }

        let url = config.merchantServerBaseURL.appendingPathComponent("/confirm-payment/\(paymentID)")
        let payload = ConfirmPaymentRequest(payment_method: "card", payment_method_data: .init(card: card))

        do {
            let resp: ConfirmPaymentResponse = try await network.postJSON(to: url, body: payload)
            return .success(resp)
        } catch {
            let err = HyperValeError.networkError(error)
            lastError = err
            return .failure(err)
        }
    }
}
