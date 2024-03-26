//
//  CartManager.swift
//  MobileApp2
//
//  Created by Chloe Zeng on 2024-03-25.
//

import SwiftUI

class CartManager: ObservableObject {
    static let shared = CartManager()
    @Published var cartItems: [Product] = []
    
    func addOrUpdateProduct(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
            cartItems[index].quantity = product.quantity
        } else {
            let newProduct = Product(id: product.id, group_id: product.group_id, name: product.name, price: product.price, quantity: product.quantity)
            cartItems.append(newProduct)
        }
    }
}
