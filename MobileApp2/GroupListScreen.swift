//
//  GroupListScreen.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-02-22.
//

import SwiftUI

class Group: Identifiable, ObservableObject{
    let id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

let db = DBHelper()

struct GroupListScreen: View {
    
    
    
    
    @State private var newGroupName = ""
    @State private var groupList: [Group] = []
    @State private var showingConfirmation = false
    @State private var selectedGroup: Group? = nil
    
    
    
    
    var body: some View {
        
        
        
        
        //        NavigationView{
        
        VStack{
            
            List{
                ForEach(groupList){ group in
                    HStack{
                        NavigationLink(destination: ProductListScreen(group_id: group.id)){
                            Text(group.name)
                        }
                        Spacer()
                        Button(action: {
                            showingConfirmation = true
                            selectedGroup = group
                            //                                deleteGroup(groupType: group)
                        }, label: {
                            Image(systemName: "trash").foregroundColor(.red)
                            //                                .frame(width:50 ,height: 50)
                            //                                    .foregroundColor(.red)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
            }
            
            
            
            .alert(isPresented: $showingConfirmation) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Do you want to delete \(selectedGroup?.name ?? "")?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let group = selectedGroup {
                            deleteGroup(groupName: group.name)
                        }
                        selectedGroup = nil
                    },
                    secondaryButton: .cancel(){
                        selectedGroup = nil
                        
                    }
                )
            }
            
            
            
            
            
            .navigationTitle("Product Groups")
            
            
            
            
            VStack(alignment: .leading){
                
                Text("Add New Group Below")
                    .padding(.horizontal)
                
                HStack(alignment: .top){
                    TextField("",text:$newGroupName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        addGroup(groupName: newGroupName)
                    }, label: {
                        Image(systemName: "plus")
                            .padding(.trailing)
                            .font(.system(size: 30))
                    }).padding(.bottom)
                    
                }
                
                
            }
            
            
            
        }.onAppear{
            self.groupList = DBHelper.shared.readGroups()
        }
        
        
        
    }
    
    
    
    
    
    func addGroup(groupName: String){
        db.insertGroup1(name: groupName)
        groupList = db.readGroups()
        newGroupName = ""
        
    }
    
    func deleteGroup(groupName: String){
        db.deleteGroup(name: groupName)
        groupList = db.readGroups()
    }
    
    
    
}

//#Preview {
//    GroupListScreen()
//}
