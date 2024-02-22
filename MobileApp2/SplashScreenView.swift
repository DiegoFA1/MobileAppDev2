//
//  SplashScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    
    var body: some View {
        
        if isActive{
            ContentView()
        } else{
            VStack{
                VStack{
                    Image(systemName:  "cart.fill")
                        .font(.system(size:80))
                        .foregroundColor(.blue)
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear{
                            withAnimation(.easeIn(duration: 1.5)){
                                self.size = 1.2
                                self.opacity = 1.0
                            }
                        }
                        
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7){
                        withAnimation{
                            self.isActive = true
                        }
                        
                    }
                }
                
            }
        }
        
        
    }
}

#Preview {
    SplashScreenView()
}
