//
//  ProductListScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

class Product: Identifiable, ObservableObject {
    let group_id: Int
    let id: Int
    @Published var name: String
    @Published var price: Double
    @Published var quantity: Int
    
    init(id: Int, group_id: Int, name: String, price: Double, quantity: Int) {
        
        self.id = id
        self.group_id = group_id
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

struct ProductListScreen: View {
    
    let group_id: Int
    @ObservedObject var cartManager = CartManager.shared
    @State private var newProductName = ""
    @State private var newProductPrice = ""
    @State private var productList: [Product] = []
    @State private var showingDeletionAlert = false
    @State private var productToDelete: Product?
    
    
    var body: some View {
        //NavigationView{
        VStack{
            // Display All Products
            List{
                HStack(alignment: .top){
                    Text("Name").frame(width: 50)
                        .padding(.trailing, 10.0)
                    Text("Price").frame(width: 60)
                    Text("Qty")
                        .padding(.trailing, 35.0)
                    Text("Actions")
                }
                .fontWeight(.bold)
                ForEach(productList.indices, id: \.self){ index in
                    let product = productList[index]
                    
                    HStack(spacing: 10){
                        Text(product.name).frame(width: 60, alignment: .leading)
                        
                        Text(String(format: "$%.2f", product.price)).frame(width: 60, alignment: .leading)
                        
                        Text("\(product.quantity)")
                        Stepper(value: Binding<Int>(
                            get: { productList[index].quantity },
                            set: { newValue in
                                let clampedValue = min(max(newValue, 0), 100)
                                let updatedProduct = product
                                updatedProduct.quantity = clampedValue
                                DBHelper.shared.updateProductQuantity(id: updatedProduct.id, quantity: clampedValue, group_id: updatedProduct.group_id)
                                cartManager.addOrUpdateProduct(updatedProduct)
                                productList[index] = updatedProduct
                            }), in: 0...100) {
                                
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            showingDeletionAlert = true
                            productToDelete = productList[index]
                        }) {
                            Image(systemName: "trash").foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .alert(isPresented: $showingDeletionAlert) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete \(productToDelete?.name ?? "this product")?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let product = productToDelete {
                            DBHelper.shared.deleteProduct(id: product.id, group_id: product.group_id)
                            loadProducts() // Reload the product list after deletion
                        }
                    },
                    secondaryButton: .cancel()
                )
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
        .onAppear {
            self.loadProducts()
        }
        
    }
    
    private func loadProducts() {
        let dbProducts = DBHelper.shared.readProducts(for: group_id)
        print("Fetched products: \(dbProducts)")
        
        // Ensure we're getting the correct products
        for product in dbProducts {
            print("Product: \(product.name), Group ID: \(product.group_id)")
        }
        
        productList = dbProducts
    }
    
    
    func addProduct(name: String, price: Double) {
        print("Adding product: \(name) with price: \(price)")
        DBHelper.shared.insertProduct(name: name, price: price, quantity: 1, group_id: group_id)
        loadProducts() // Refresh the product list
        newProductName = ""
        newProductPrice = ""
    }
    
    
    func updateQuantity(at index: Int, to newValue: Int) {
        productList[index].quantity = newValue
        cartManager.addOrUpdateProduct(productList[index])
    }
    
    func deleteProduct(product: Product) {
        DBHelper.shared.deleteProduct(id: product.id, group_id: product.group_id)
        loadProducts() // Refresh the product list after deletion
    }
    
    
    func viewCart(){
        //navigate to cart page
    }
}


//#Preview {
//    ProductListScreen(group_id: 1)
//}
