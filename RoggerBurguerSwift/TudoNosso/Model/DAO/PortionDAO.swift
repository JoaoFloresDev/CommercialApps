//
//  PortionDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

struct PortionDAO: GenericsDAO {
    typealias managedEntity = Portion
    typealias managedFields = PortionFields
    let TABLENAME  = "portions"
    
}

extension PortionDAO: StorageAccessor {
    var storageName: String {TABLENAME}
}
