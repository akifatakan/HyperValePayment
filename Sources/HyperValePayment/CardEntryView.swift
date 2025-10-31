//
//  CardEntryView.swift
//  HyperValePayment
//
//  Created by Akif Atakan Yılmaz on 31.10.2025.
//

import SwiftUI

public struct CardEntryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject public var client: HyperValeClient
    public let paymentID: String
    public var onComplete: ((ConfirmPaymentResponse) -> Void)?

    @State private var holder = ""
    @State private var number = ""
    @State private var month = ""
    @State private var year = ""
    @State private var cvc = ""
    @State private var localError: String?

    public init(client: HyperValeClient, paymentID: String, onComplete: ((ConfirmPaymentResponse) -> Void)? = nil) {
        self.client = client
        self.paymentID = paymentID
        self.onComplete = onComplete
    }

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card")) {
                    TextField("Name on card", text: $holder)
                    TextField("Card number", text: $number)
                        .keyboardType(.numberPad)
                    HStack {
                        TextField("MM", text: $month).keyboardType(.numberPad)
                        TextField("YY", text: $year).keyboardType(.numberPad)
                        TextField("CVC", text: $cvc).keyboardType(.numberPad)
                    }
                }

                Section {
                    Button {
                        Task {
                            await confirm()
                        }
                    } label: {
                        if client.isLoading {
                            ProgressView()
                        } else {
                            Text("Confirm Payment").bold()
                        }
                    }.disabled(client.isLoading)
                }

                if let e = localError {
                    Section { Text(e).foregroundColor(.red) }
                } else if let e = client.lastError {
                    Section { Text(e.localizedDescription).foregroundColor(.red) }
                }
            }
            .navigationTitle("Enter Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    func confirm() async {
        localError = nil
        guard !number.isEmpty, !month.isEmpty, !year.isEmpty, !cvc.isEmpty else {
            localError = "Please fill all fields"
            return
        }

        let card = ConfirmPaymentRequest.Card(
            card_number: number,
            card_exp_month: month,
            card_exp_year: year,
            card_cvc: cvc,
            card_holder_name: holder.isEmpty ? nil : holder
        )

        let result = await client.confirmPayment(paymentID: paymentID, card: card)
        switch result {
        case .success(let resp):
            onComplete?(resp)
            dismiss()
        case .failure:
            // client.lastError will be updated
            break
        }
    }
}

