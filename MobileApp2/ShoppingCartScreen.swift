//
//  ShoppingCartScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

//struct ShoppingCartScreen: View {
//    //@State private var shouldCalculate = false
//
//    // @State private var productNames = ["Product 2", "Product 3"]
//    //@State private var productPrices = [2.15, 10.55]
//    //@State private var productQuantities: [Int] = [2, 1]
//    @State private var productList: [Product] = []
//    @State private var filteredProduct: [Product] = []
//
//
//    @State private var subtotal: Double = 0
//    @State private var tax: Double = 0
//    @State private var total: Double = 0
//
//    var body: some View {
//        //NavigationView{
//            VStack {
//                //Text("Shopping Cart").font(.largeTitle)
//                    //.padding()
//                HStack(alignment: .top){
//                    Text("Product Name")
//                    Spacer()
//                    Text("Price")
//                    Spacer()
//                    Text("Quatity")
//                }.padding([.top, .leading, .trailing], 25.0)
//                    .fontWeight(.bold)
//                ForEach(filteredProduct.indices, id: \.self) { index in
//                    let product = filteredProduct[index]
//                    HStack{
//                        Text(product.name)
//                        Spacer()
//                        Text("$\(product.price, specifier: "%.2f")")
//                        Spacer()
//                        Button(action:{
//                            if product.quantity > 0 {
//                                product.quantity -= 1
//                            }
//                        }) {
//                            Text("-")
//                        }
//                        Text("\(product.quantity)")
//                        Button(action:{
//                            product.quantity += 1
//                        }) {
//                            Text("+")
//                        }
//                    }
//                    .padding([.top, .leading, .trailing], 25.0)
//                }
//                Button(action: {
//                    calculateTotal()// Trigger calculation
//                }) {
//                    Text("Calculate")
//                }
//                .padding()
//                Spacer()
//                    HStack{
//                        Text("Subtotal: ")
//                        Spacer()
//                        Text("\(subtotal, specifier: "%.2f")")
//
//                    }.padding(.all, 25.0)
//                    HStack{
//                        Text("Tax: ")
//                        Spacer()
//                        Text("\(tax, specifier: "%.2f")")
//                    }.padding([.leading, .bottom, .trailing], 25.0)
//                    HStack{
//                        Text("Total: ")
//                        Spacer()
//                        Text("\(total, specifier: "%.2f")")
//                    }.padding(.horizontal, 25.0)
//
//                Spacer()
//
//            } // VStack
//            .onAppear {
//                self.productList = DBHelper.shared.readProducts()
//
//                for product in productList{
//                    print("ID: \(product.id)")
//                    print("Name: \(product.name)")
//                    print("Price: \(product.price)")
//                    print("Quantity: \(product.quantity)")
//                }
//                self.filteredProduct = self.productList.filter {$0.quantity > 1}
//                calculateTotal()
//                    }
//            .padding(-14.0)
//            .navigationBarTitle("Shopping Cart")
//         // NavigationView
//    }
//
//    func calculateTotal(){
//        //subtotal = productPrices.indices.reduce(0) {
//        //    $0 + productPrices[$1] * Double(productQuantities[$1])
//        //}
//        //tax = subtotal * 0.13
//        //total = subtotal + tax
//        subtotal = filteredProduct.reduce(0) {
//            $0 + $1.price * Double($1.quantity)
//        }
//        tax = subtotal * 0.13
//        total = subtotal + tax
//    }
//
//    func updateQuantity(at index: Int, to newValue: Int) {
//        DBHelper.shared.updateProductQuantity(id: productList[index].id, quantity: newValue)
//        productList[index].quantity = newValue
//    }}
//
//#Preview {
//    ShoppingCartScreen()
//}



struct ShoppingCartScreen: View {
    @ObservedObject var cartManager = CartManager.shared
    @State private var subtotal: Double = 0
    @State private var tax: Double = 0
    @State private var total: Double = 0
    
    var body: some View {
        VStack {
            List {
                HStack {
                    Text("Name").frame(width: 50)
                    Spacer()
                    Text("Price").frame(width: 60)
                    Spacer()
                    Text("Quantity")
                }
                .padding()
                .fontWeight(.bold)
                ForEach(cartManager.cartItems.indices, id: \.self) { index in
                    let product = cartManager.cartItems[index]
                    HStack {
                        Text(product.name).frame(width: 60, alignment: .leading)
                        Spacer()
                        Text("$\(product.price, specifier: "%.2f")").frame(width: 60)
                        Spacer()
                        
                        
                        Text("\(product.quantity)")
                        Stepper(value: Binding<Int>(
                            get: { self.cartManager.cartItems[index].quantity },
                            set: { newValue in
                                updateQuantity(at: index, to: newValue)
                            }), in: 0...100) {
                                
                            }
                    }
                }
            }
            
            Button("Calculate") {
                calculateTotal()
            }
            .padding()
            
            Spacer()
            
            HStack {
                Text("Subtotal: ")
                Spacer()
                Text("\(subtotal, specifier: "%.2f")")
            }
            .padding()
            
            HStack {
                Text("Tax: ")
                Spacer()
                Text("\(tax, specifier: "%.2f")")
            }
            .padding()
            
            HStack {
                Text("Total: ")
                Spacer()
                Text("\(total, specifier: "%.2f")")
            }
            .padding()
        }
        .onAppear {
            calculateTotal()
        }
        .navigationBarTitle("Shopping Cart")
    }
    
    func calculateTotal() {
        subtotal = cartManager.cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
        tax = subtotal * 0.13
        total = subtotal + tax
    }
    
    
    func updateQuantity(at index: Int, to newValue: Int) {
        let product = cartManager.cartItems[index]
        DBHelper.shared.updateProductQuantity(id: product.id, quantity: newValue, group_id: product.group_id)
        cartManager.cartItems[index].quantity = newValue
        calculateTotal()
    }
    
}

#Preview {
    ShoppingCartScreen()
}
