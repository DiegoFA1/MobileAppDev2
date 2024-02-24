//
//  ProductListScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

class Product: Identifiable {
    var name: String
    var price: Double
    var quantity: Int
    
    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

struct ProductListScreen: View {
        @State private var newProductName = ""
        @State private var newProductPrice = ""
        @State private var productList: [Product] = [
            Product(name: "Grape Tomato", price: 2.49, quantity: 0),
            Product(name: "Pineapple", price: 5.99, quantity: 0),
            Product(name: "Red Pepper", price: 3.49, quantity: 0),
            Product(name: "Mixed Nuts", price: 22.75, quantity: 0)
        ]
        
        var body: some View {
            NavigationView{
            VStack{
                // Display All Products
                List{
                    HStack(alignment: .top){
                        Text("Name").frame(width: 80, alignment: .leading)
                        Spacer()
                        Text("Price").frame(width: 60, alignment: .leading)
                        Spacer()
                        Text("Quatity")
                    }
                    .fontWeight(.bold)
                    ForEach(productList.indices, id: \.self){ index in
                        let product = productList[index]
                        HStack(spacing: 10){
                            Text(product.name).frame(width: 80, alignment: .leading)
                            Spacer()
                            Text(String(format: "$%.2f", product.price)).frame(width: 60, alignment: .leading)
                            Spacer()
                            Stepper(value:$productList[index].quantity, in:0...100){
                                Text("\(productList[index].quantity)")
                            }
                        }
                    }
                }
                
                //View Cart Button
                NavigationLink(destination: ShoppingCartScreen()){
                    Text("View Cart")
                        .font(.system(size: 20))
                }
                .navigationTitle("Product List")
                
                // Add New Product Area
                VStack(alignment: .leading){
                    Text("Add New Product Below")
                        .padding(.horizontal)
                    
                    TextField("Product Name",text:$newProductName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack{
                        Text("$")
                        
                        Spacer()
                        
                        TextField("Price",text:$newProductPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            if let price = Double(newProductPrice){
                                addProduct(name: newProductName, price: price)
                            }
                        }){
                            Image(systemName: "plus")
                                .padding(.trailing)
                                .font(.system(size: 30))
                        }.padding()
                    }
                }
                .padding()
            }
            
        }
    }
                        
        func addProduct(name: String, price: Double){
//            let product = Product(name: name, price: price, quantity: 0);
//            productList.append(product)
//            newProductName = ""
//            newProductPrice = ""
        }
    
        func viewCart(){
            //navigate to cart page
        }
}
                

#Preview {
    ProductListScreen()
}

