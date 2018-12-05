//
// CollectionType.swift
// MyDeliveries
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 04/12/18
//

import Foundation

enum CollectionType: String {
    case packages = "Packages"
    case deliveryStatus = "DeliveryStatus"
    case none = ""

    static let all = [
        packages, deliveryStatus,
    ]
}
