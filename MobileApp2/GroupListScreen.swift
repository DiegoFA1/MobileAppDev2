//
//  GroupListScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

class Group: Identifiable, ObservableObject{
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct GroupListScreen: View {
    @State private var newGroupName = ""
    @State private var groupList: [Group] = [
    
        Group(name: "Groceries"),
        Group(name: "Clothing")
    
    ]
    
    
    
    
    
    
    
    var body: some View {
        NavigationView{
            
            VStack{
                    
                    List{
                        ForEach(groupList){ group in NavigationLink(destination: ProductListScreen(), label: {
                            Text(group.name)
                            Button(action: {deleteGroup(groupType: group)}, label: {
                                Image(systemName: "xmark")
                                    .frame(width:50 ,height: 50)
                            })                        }
                        
                        )}
                            
                        
                        
                    }
                    
                    
                
                
                
                .navigationTitle("Product Groups")
                
                
                VStack(alignment: .leading){
                    
                    Text("Add New Group Below")
                        .padding(.horizontal)
                        
                    HStack(alignment: .top){
                        TextField("",text:$newGroupName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "plus")
                                .padding(.trailing)
                                .font(.system(size: 30))
                        }).padding()
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
    }
    
    func addGroup(groupType: Group){
        
    }
    
    func deleteGroup(groupType: Group){
        if let index = groupList.firstIndex(where: { $0.name == groupType.name}){
            groupList.remove(at: index)
        }
    }
    
    
    
}

#Preview {
    GroupListScreen()
}
