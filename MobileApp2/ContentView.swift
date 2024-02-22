//
//  ContentView.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Welcome to my app")
                NavigationLink(destination: SplashScreen(), label: {
                    Text("Go to calculator")
                })
                
            }
        }
        

    }
}





#Preview {
    ContentView()
}
