//
//  ShoppingCartScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

struct ShoppingCartScreen: View {
    //@State private var shouldCalculate = false
    
    @State private var productNames = ["Product 2", "Product 3"]
    @State private var productPrices = [2.15, 10.55]
    @State private var productQuantities: [Int] = [2, 1]
    
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
                ForEach(0..<productNames.count, id: \.self) { index in
                    HStack{
                        Text(productNames[index])
                        Spacer()
                        Text("$\(productPrices[index], specifier: "%.2f")")
                        Spacer()
                        Button(action:{
                            if productQuantities[index] > 0 {
                                productQuantities[index] -= 1
                            }
                        }) {
                            Text("-")
                        }
                        Text("\(productQuantities[index])")
                        Button(action:{
                            productQuantities[index] += 1
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
                        // Calculate initial values when the view appears
                        //subtotal = productPrices.indices.reduce(0) {
                        //    $0 + productPrices[$1] * Double(productQuantities[$1])
                       // }
                        //tax = subtotal * 0.13
                        //total = subtotal + tax
                calculateTotal()
                    }
            .padding(-14.0)
            .navigationBarTitle("Shopping Cart")
         // NavigationView
    }
    
    func calculateTotal(){
        subtotal = productPrices.indices.reduce(0) {
            $0 + productPrices[$1] * Double(productQuantities[$1])
        }
        tax = subtotal * 0.13
        total = subtotal + tax
    }
}

#Preview {
    ShoppingCartScreen()
}
