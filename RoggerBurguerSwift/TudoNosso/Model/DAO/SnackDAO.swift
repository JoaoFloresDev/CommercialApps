//
//  SnackDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct SnackDAO: GenericsDAO {
    typealias managedEntity = Snack
    typealias managedFields = SnackFields
    let TABLENAME  = "snacks"
    
}

extension SnackDAO: StorageAccessor {
    var storageName: String {TABLENAME}
}
