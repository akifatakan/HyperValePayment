//
//  NetworkClient.swift
//  HyperValePayment
//
//  Created by Akif Atakan Yılmaz on 31.10.2025.
//

import Foundation

public final class NetworkClient {
    public init() {}

    public func postJSON<T: Encodable, U: Decodable>(to url: URL, body: T) async throws -> U {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        req.timeoutInterval = 30

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        if (200...299).contains(http.statusCode) {
            return try JSONDecoder().decode(U.self, from: data)
        } else {
            // Attempt to decode error envelope
            if let decoded = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                throw HyperValeNetworkError.serverSide(decoded)
            } else {
                throw URLError(.badServerResponse)
            }
        }
    }
}

public struct ServerErrorResponse: Decodable {
    public let error: String?
}

public enum HyperValeNetworkError: Error {
    case serverSide(ServerErrorResponse)
}
