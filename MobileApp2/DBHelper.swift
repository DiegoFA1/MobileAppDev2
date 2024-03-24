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
        self.dropGroupTable()
        self.createGroupTable()
        self.createProductTable()
        
        
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
            print("path is: \(filepath)")
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
            insertGroup1(name: "Grocery");
            insertGroup1(name: "Electronics");
            insertGroup1(name: "Home");
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
                print ("Group \(name) added to database")
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
   
        let query = "SELECT * FROM groups;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil ) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let namedb = String(describing: String(cString: sqlite3_column_text(statement,1)))
                let group = Group(name: namedb)
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
    
    func getGroupByName(name:String) -> Int {
        let getNameQuery = "SELECT * FROM groups WHERE name = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(self.db, getNameQuery, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                return Int(id)
            } else{
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Error in getting group name: \(errmsg)")
                return 0
            }
        }
        return 0
    }
    
    
    
    func createProductTable(){
        let createProductTableQuery = "CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, quantity INTEGER, group_id INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createProductTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Product table created.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error creating product table: \(errmsg)")
            }
        }
        sqlite3_finalize(createTableStatement)
        insertProduct(name: "Carrot", price: 2.99, quantity: 0, group_id:1)
        insertProduct(name: "Tomato", price: 3.99, quantity: 0, group_id:1)
        insertProduct(name: "Beef", price: 8.49, quantity: 0, group_id:1)
        insertProduct(name: "Kids Tablet", price: 128.49, quantity: 0, group_id:2)
        insertProduct(name: "4K TV", price: 899.99, quantity: 0, group_id:2)
        insertProduct(name: "Pillow", price: 35.79, quantity: 0, group_id:3)
        insertProduct(name: "Bowl Set", price: 36.49, quantity: 0, group_id:3)
        
    }
    
    
    func insertProduct(name: String, price: Double, quantity: Int, group_id: Int) {
        let insertQuery = "INSERT INTO products (name, price, quantity, group_id) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 2, price)
            sqlite3_bind_int(insertStatement, 3, Int32(quantity))
            sqlite3_bind_int(insertStatement, 4, Int32(group_id))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted product.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("failure inserting product: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure preparing insert: \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }

    
    
    func readProducts(group_name: String) -> [Product] {
        let query = "SELECT * FROM products WHERE group_name = ?;"
        var queryStatement: OpaquePointer? = nil
        var productList = [Product]()
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                //let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let price = sqlite3_column_double(queryStatement, 2)
                let quantity = Int(sqlite3_column_int(queryStatement, 3))
                let group_id = Int(sqlite3_column_int(queryStatement, 4))
                let product = Product(id: 0, name: name, price: price, quantity: Int(quantity), group_id: Int(group_id))
                productList.append(product)
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure reading products: \(errmsg)")
        }
        sqlite3_finalize(queryStatement)
        return productList
    }

    
    func deleteProduct(id: Int) {
        let deleteQuery = "DELETE FROM products WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted product.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("failure deleting product: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure preparing delete: \(errmsg)")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func updateProductQuantity(id: Int, quantity: Int) {
        let updateQuery = "UPDATE products SET quantity = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(quantity))
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated product quantity.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure updating product quantity: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure preparing update: \(errmsg)")
        }
        sqlite3_finalize(updateStatement)
    }




    
    
    
    
}
