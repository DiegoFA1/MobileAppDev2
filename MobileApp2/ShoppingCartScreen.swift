//
//  ShoppingCartScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

struct ShoppingCartScreen: View {
    
    @State private var productQuantites = [2,1]
    var productNames = ["Product 2", "Product 3"]
    var productPrices = [2.15, 10.55]
    
    var body: some View {
        NavigationView{
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
                ForEach(0..<productNames.count, id: \.self) { index in
                    HStack{
                        Text(productNames[index])
                        Spacer()
                        Text("$\(productPrices[index], specifier: "%.2f")")
                        Spacer()
                        Button(action:{
                            if productQuantites[index] > 0 {
                                productQuantites[index] -= 1
                            }
                        }) {
                            Text("-")
                        }
                        Text("\(productQuantites[index])")
                        Button(action:{
                            productQuantites[index] += 1
                        }) {
                            Text("+")
                        }
                    }
                    .padding([.top, .leading, .trailing], 25.0)
                }
                Button(action: {
                    // Calculate total price
                }) {
                    Text("Calculate")
                }
                .padding()
                Spacer()
                
                var subtotal = productPrices.indices.reduce(0) {
                    $0 + productPrices[$1] * Double(productQuantites[$1])
                }
                var tax = subtotal * 0.13
                var total = subtotal + tax
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
            .padding(-14.0)
            .navigationBarTitle("Shopping Cart")
        } // NavigationView
    }
}

#Preview {
    ShoppingCartScreen()
}
