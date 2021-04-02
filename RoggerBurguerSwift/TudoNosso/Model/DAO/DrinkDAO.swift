
//
//  DrinkDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct DrinkDAO: GenericsDAO {
    typealias managedEntity = Drink
    typealias managedFields = DrinkFields
    let TABLENAME  = "drinks"
    
}

extension DrinkDAO: StorageAccessor {
    var storageName: String {TABLENAME}
}
