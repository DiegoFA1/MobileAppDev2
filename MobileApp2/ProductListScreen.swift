//
//  ProductListScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

class Product: Identifiable, ObservableObject {
    var id: Int
    var name: String
    var price: Double
    var quantity: Int
    var group_id: Int
    
    init(id: Int, name: String, price: Double, quantity: Int, group_id: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.group_id = group_id
    }
}


struct ProductListScreen: View {
        @State private var newProductName = ""
        @State private var newProductPrice = ""
        @State private var productList: [Product] = []
    
        @State public var group_id: Int
        @State public var selectedGroup: Group?
        
        var body: some View {
            //NavigationView{
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
                            Text("\(product.name)").frame(width: 80, alignment: .leading)
                            Spacer()
                            Text(String(format: "$%.2f", "\(product.price)")).frame(width: 60, alignment: .leading)
                            Spacer()
                            Stepper(value: Binding<Int>(
                                get: { product.quantity },
                                set: { newValue in updateQuantity(product: product, newValue: newValue) }
                            ), in:0...100){
                                Text("\(product.quantity)")
                            }
                        }
                      }
                    }.onAppear {
                        if let selectedGroupName = selectedGroup?.name {
                                self.productList = DBHelper.shared.readProducts(group_name: selectedGroupName)
                            }
                        }
            }
                //View Cart Button
                NavigationLink(destination: ShoppingCartScreen()){
                    Text("Add to Cart")
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
                                addProduct(name: newProductName, price: price, group_id: group_id)
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
            
    
                        
        func addProduct(name: String, price: Double, group_id: Int){
            DBHelper.shared.insertProduct(name: name, price: price, quantity: 0, group_id: group_id)
            self.productList = DBHelper.shared.readProducts(group_name: selectedGroup!.name)
            newProductName = ""
            newProductPrice = ""
        }

    func updateQuantity(product: Product, newValue: Int) {
            DBHelper.shared.updateProductQuantity(id: product.id, quantity: newValue)
            product.quantity = newValue
        }
    
        func addSelectedProducts(){
            //navigate to cart page
        }

                
}
//#Preview {
//    ProductListScreen(group_id: 1, selectedGroup: Group(name: "Grocery"))
//}





