//
//  ShoppingCartScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

struct ShoppingCartScreen: View {
    //@State private var shouldCalculate = false
    
    // @State private var productNames = ["Product 2", "Product 3"]
    //@State private var productPrices = [2.15, 10.55]
    //@State private var productQuantities: [Int] = [2, 1]
    @State private var productList: [Product] = []
    @State private var filteredProduct: [Product] = []
 
    
    @State private var subtotal: Double = 0
    @State private var tax: Double = 0
    @State private var total: Double = 0
    
    var body: some View {
        //NavigationView{
            VStack {
                //Text("Shopping Cart").font(.largeTitle)
                    //.padding()
                HStack(alignment: .top){
                    Text("Product Name")
                    Spacer()
                    Text("Price")
                    Spacer()
                    Text("Quatity")
                }.padding([.top, .leading, .trailing], 25.0)
                    .fontWeight(.bold)
                ForEach(filteredProduct.indices, id: \.self) { index in
                    let product = filteredProduct[index]
                    HStack{
                        Text(product.name)
                        Spacer()
                        Text("$\(product.price, specifier: "%.2f")")
                        Spacer()
                        Button(action:{
                            if product.quantity > 0 {
                                product.quantity -= 1
                            }
                        }) {
                            Text("-")
                        }
                        Text("\(product.quantity)")
                        Button(action:{
                            product.quantity += 1
                        }) {
                            Text("+")
                        }
                    }
                    .padding([.top, .leading, .trailing], 25.0)
                }
                Button(action: {
                    calculateTotal()// Trigger calculation
                }) {
                    Text("Calculate")
                }
                .padding()
                Spacer()
                    HStack{
                        Text("Subtotal: ")
                        Spacer()
                        Text("\(subtotal, specifier: "%.2f")")
                        
                    }.padding(.all, 25.0)
                    HStack{
                        Text("Tax: ")
                        Spacer()
                        Text("\(tax, specifier: "%.2f")")
                    }.padding([.leading, .bottom, .trailing], 25.0)
                    HStack{
                        Text("Total: ")
                        Spacer()
                        Text("\(total, specifier: "%.2f")")
                    }.padding(.horizontal, 25.0)
                
                Spacer()

            } // VStack
            .onAppear {
                self.productList = DBHelper.shared.readProducts()
                
                for product in productList{
                    print("ID: \(product.id)")
                    print("Name: \(product.name)")
                    print("Price: \(product.price)")
                    print("Quantity: \(product.quantity)")
                }
                self.filteredProduct = self.productList.filter {$0.quantity > 1}
                calculateTotal()
                    }
            .padding(-14.0)
            .navigationBarTitle("Shopping Cart")
         // NavigationView
    }
    
    func calculateTotal(){
        //subtotal = productPrices.indices.reduce(0) {
        //    $0 + productPrices[$1] * Double(productQuantities[$1])
        //}
        //tax = subtotal * 0.13
        //total = subtotal + tax
        subtotal = filteredProduct.reduce(0) {
            $0 + $1.price * Double($1.quantity)
        }
        tax = subtotal * 0.13
        total = subtotal + tax
    }
    
    func updateQuantity(at index: Int, to newValue: Int) {
        DBHelper.shared.updateProductQuantity(id: productList[index].id, quantity: newValue)
        productList[index].quantity = newValue
    }}

#Preview {
    ShoppingCartScreen()
}
