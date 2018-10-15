//
//  Database.swift
//  MiSalud-iOS
//
//  Created by ITMED, Ricardo Alcides Castillo Rogel on 29/6/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import Foundation
import SQLite


class Database {
    static let shared = Database()
    public let connection: Connection?
    public let dataBaseFileName = "misalud.sqlite3"
    
    private init (){
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String?
        do{
            connection = try Connection("\(dbPath!)/(dataBaseFileName)")
            print("Database connected")
        } catch{
            connection = nil
            let nserror = error as NSError
            print("Cannot connect to Database, Error in : \(nserror), \(nserror.userInfo)")
        }
    }
    
}
