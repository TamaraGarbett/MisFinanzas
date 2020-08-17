//
//  LoggedUserSingleton.swift
//  MisFinanzas
//
//  Created by Admin on 14/8/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import CoreData

class LoggedUserSingleton:User{
    private static let LOGGEDUSER = User()
    
    private init(){
        let container : NSPersistentContainer!
        container = NSPersistentContainer(name: "MisFinanzas")
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                return
            }
        }
        super.init(context:container.viewContext)
    }
    
    static func getLoggedUser() -> User {
        return LOGGEDUSER
    }
        
        
}
