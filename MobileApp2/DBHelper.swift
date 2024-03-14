//
//  DBHelper.swift
//  MobileApp2
//
//  Created by Diego Fuentes on 2024-03-13.
//

import Foundation
import SQLite3

class DBHelper{
    var db: OpaquePointer?
    var path: String = "shoppingDb.sqlite"
    
    init(){
        self.db = create_db()
        self.dropGroupTable()
        self.createGroupTable()
        
    }
    
    func create_db() -> OpaquePointer? {
        let filepath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
            .appendingPathExtension(path)
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filepath.path, &db) != SQLITE_OK{
            print("Error during Database Creation")
            return nil
        }else {
            print("Database Created with path \(path)")
            return db
        }
    }
    
    
    func createGroupTable(){
        // Add if not exists if needed
        
        let createQuery = "CREATE TABLE IF NOT EXISTS groups (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);"
        var createTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createQuery, -1, &createTable, nil) == SQLITE_OK{
            if sqlite3_step(createTable) == SQLITE_DONE{
                print("Table Group Created")
            }
            
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error droping group table: \(errmsg)")
        }
        
    }
    
    func dropGroupTable(){
        let dropTableQuery = "DROP TABLE IF EXISTS groups;"
        
        if sqlite3_exec(self.db, dropTableQuery, nil, nil, nil) == SQLITE_OK{
            print("Table Group Deleted")

        } else {
            print("Table Group Deletion Error ")
        }
    }
    
    func insertGroup1(name: String){
        let query = "INSERT INTO groups (id,name) VALUES (?,?)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil ) == SQLITE_OK{
            sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE{
                print ("Inserted \(name)")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error inserting: \(errmsg)")
            }
            
        } else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error inserting: \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    
    func readGroups() -> [Group]{
        var groupList = [Group]()
        print("Here")
        
        let query = "SELECT * FROM groups;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil ) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let namedb = String(describing: String(cString: sqlite3_column_text(statement,1)))
                print(namedb)
                let group = Group(name: namedb)
                groupList.append(group)
            }
            
        }
        
        sqlite3_finalize(statement)
        return groupList;
    }
    
    
    
    
    
    
}
