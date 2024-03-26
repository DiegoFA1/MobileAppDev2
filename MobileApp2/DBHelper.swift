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
    static let shared = DBHelper()
    init(){
        self.db = create_db()
        //        self.dropGroupTable()
        self.createGroupTable()
        
        // Create product tables for all existing groups
        let groups = readGroups()
        groups.forEach { group in
            createProductTableIfNeeded(groupId: group.id)
        }
        
        
    }
    
    //    func create_db() -> OpaquePointer? {
    //        let filepath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
    //            .appendingPathExtension(path)
    //        var db: OpaquePointer? = nil
    //
    //        if sqlite3_open(filepath.path, &db) != SQLITE_OK{
    //            print("Error during Database Creation")
    //            return nil
    //        }else {
    //            print("Database Created with path \(path)")
    //            return db
    //        }
    //    }
    
    func create_db() -> OpaquePointer? {
        // Get the directory where the database should be stored
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
            .appendingPathComponent(path)
        
        var db: OpaquePointer? = nil
        
        // Attempt to open the database at the specified file path
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error during Database Creation")
            return nil
        } else {
            print("Database Created with path \(fileURL.path)")
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
    
    //    func insertGroup1(name: String){
    //        let query = "INSERT INTO groups (id,name) VALUES (?,?)"
    //        var statement: OpaquePointer? = nil
    //
    //        if sqlite3_prepare_v2(db, query, -1, &statement, nil ) == SQLITE_OK{
    //            sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
    //
    //            if sqlite3_step(statement) == SQLITE_DONE{
    //                print ("Group \(name) added to database")
    //            }else{
    //                let errmsg = String(cString: sqlite3_errmsg(db))
    //                print("error inserting: \(errmsg)")
    //            }
    //
    //        } else{
    //            let errmsg = String(cString: sqlite3_errmsg(db))
    //            print("error inserting: \(errmsg)")
    //        }
    //        sqlite3_finalize(statement)
    //    }
    
    
    func insertGroup1(name: String){
        let insertGroupQuery = "INSERT INTO groups (name) VALUES (?);"  // Removed id from VALUES, as it's auto-increment
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertGroupQuery, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Group \(name) added to database")
                let groupId = Int(sqlite3_last_insert_rowid(db))
                createProductTableIfNeeded(groupId: groupId)
            } else {
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
        
        let query = "SELECT * FROM groups;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil ) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = Int(sqlite3_column_int(statement, 0))
                let namedb = String(describing: String(cString: sqlite3_column_text(statement,1)))
                let group = Group(id: id, name: namedb)
                groupList.append(group)
            }
            
        }
        
        sqlite3_finalize(statement)
        return groupList;
    }
    
    func deleteGroup(name:String){
        let deleteQuery = "DELETE FROM groups WHERE name = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(self.db, deleteQuery, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error deleting group: \(errmsg)")
            } else{
                print("Group \(name) deteled")
            }
            
            
        }
    }
    
    
    
    
    
    func createProductTableIfNeeded(groupId: Int) {
        let createProductTableQuery = "CREATE TABLE IF NOT EXISTS products_\(groupId) " +
        "(id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "name TEXT, " +
        "price REAL, " +
        "quantity INTEGER, " +
        "group_id INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createProductTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Product table for Group \(groupId) created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Error creating product table: \(errmsg)")
            }
            sqlite3_finalize(createTableStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure preparing to create product table: \(errmsg)")
        }
    }
    
    
    
    
    
    
    
    func insertProduct(name: String, price: Double, quantity: Int, group_id: Int) {
        let tableName = "products_\(group_id)"
        let insertQuery = "INSERT INTO \(tableName) (name, price, quantity, group_id) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 2, price)
            sqlite3_bind_int(insertStatement, 3, Int32(quantity))
            sqlite3_bind_int(insertStatement, 4, Int32(group_id))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted product \(name) into Group \(group_id).")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure inserting product: \(errmsg)")
            }
            sqlite3_finalize(insertStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure preparing insert: \(errmsg)")
        }
    }
    
    
    
    
    
    
    
    
    func readProducts(for groupId: Int) -> [Product] {
        var productList: [Product] = []
        let tableName = "products_\(groupId)"
        let query = "SELECT id, group_id, name, price, quantity FROM \(tableName) WHERE group_id = ?;"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(groupId))
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let group_id = Int(sqlite3_column_int(queryStatement, 1))
                guard let nameCStr = sqlite3_column_text(queryStatement, 2) else {
                    print("Name column was null")
                    continue
                }
                let name = String(cString: nameCStr)
                let price = sqlite3_column_double(queryStatement, 3)
                let quantity = Int(sqlite3_column_int(queryStatement, 4))
                
                let product = Product(id: id, group_id: group_id, name: name, price: price, quantity: quantity)
                productList.append(product)
            }
            sqlite3_finalize(queryStatement)
        }
        return productList
    }
    
    
    
    
    func deleteProduct(id: Int, group_id: Int) {
        let tableName = "products_\(group_id)"
        let deleteQuery = "DELETE FROM \(tableName) WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted product.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure deleting product: \(errmsg)")
            }
            sqlite3_finalize(deleteStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure preparing delete: \(errmsg)")
        }
    }
    
    
    
    func updateProductQuantity(id: Int, quantity: Int, group_id: Int) {
        let tableName = "products_\(group_id)"
        let updateQuery = "UPDATE \(tableName) SET quantity = ? WHERE id = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(quantity))
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Product quantity updated successfully.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Error updating product quantity: \(errmsg)")
            }
            sqlite3_finalize(updateStatement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing update: \(errmsg)")
        }
    }
    
    
    
}

