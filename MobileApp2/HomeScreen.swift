//
//  ContentView.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

struct HomeScreen: View {
    
    
    var body: some View {
        NavigationView{
            
            VStack(){
                HStack{
                    Spacer()
                    NavigationLink(destination: ShoppingCartScreen(), label: {
                        Image(systemName:  "cart")
                            .font(.system(size:20))
                    })
                    
                    
                }.padding(.top,40)
                .padding(.horizontal,15)
                
                VStack{
                    Text("Tax Shopping Cart")
                        .fontWeight(.bold)
                        .font(.system(size:25))
                }
                
                VStack{
                    
                    NavigationLink(destination: GroupListScreen(), label: {
                        Text("Product Groups")
                            .frame(width: 200, height: 75)
                            .border(.blue)
                            .padding(10)
                            
                    })
                    
                    NavigationLink(destination: ShoppingCartScreen(), label: {
                        Text("Shopping Cart")
                            .frame(width: 200, height: 75)
                            .border(.blue)
                            .padding(10)
                            
                    })
                    
                }.padding(100)
                
                HStack(){
                    VStack(alignment: .leading){
                        
                            Text("Members:")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        
                            Text("Hiu Wai Lau")
                                .font(.system(size:20))
                                  
                            Text("Diego Fuentes")
                            .font(.system(size:20))
                        
                            Text("Yang Hai")
                            .font(.system(size:20))
                                  
                            Text("Chloe Zeng")
                            .font(.system(size:20))
                        
                    }
                    .padding(.horizontal,50)
                    Spacer()
                }
                
                
                Spacer()
               
                
                
                    
                    
            }
        }
        

    }
}





//#Preview {
//    HomeScreen()
//}
