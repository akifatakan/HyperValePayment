# 💳 HyperVale iOS SDK

**HyperVale** is a lightweight, secure Swift SDK for integrating payments in iOS e-commerce or subscription applications.  
It provides a ready-to-use client for interacting with your **merchant server** (which connects to your payment processor, such as [Hyperswitch](https://hyperswitch.io/)), along with an optional SwiftUI card entry interface.

---

## 🚀 Features

- 🔒 Secure payment creation and confirmation
- 🧩 Easy installation via **Swift Package Manager (SPM)**
- 💳 Built-in SwiftUI card entry form (`CardEntryView`)
- ✅ Basic client-side validation (Luhn check, expiry)
- 🌐 Simple async/await networking
- 🧱 Fully modular — works with any backend that follows `/create-payment-intent` and `/confirm-payment` endpoints

---

## 📦 Installation (Swift Package Manager)

In Xcode:

1. Go to **File ▸ Add Packages…**
2. Enter the package URL: https://github.com/akifatakan/HyperValePayment.git
3. Select **Up to Next Major Version** (recommended) and click **Add Package**.

Or add it directly to your `Package.swift`:

```swift
dependencies: [
 .package(url: "https://github.com/<your-org>/HyperVale.git", from: "1.0.0")
]
