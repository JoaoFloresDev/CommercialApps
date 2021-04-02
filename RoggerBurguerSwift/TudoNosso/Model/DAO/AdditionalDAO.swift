//
//  AdditionalDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation


struct AdditionalDAO: GenericsDAO {
    typealias managedEntity = Additional
    typealias managedFields = AdditionalFields
    let TABLENAME  = "additionals"
    
}

extension AdditionalDAO: StorageAccessor {
    var storageName: String {TABLENAME}
}
