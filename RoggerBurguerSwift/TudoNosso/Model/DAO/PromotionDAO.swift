//
//  PromotionDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

struct PromotionDAO: GenericsDAO {
    typealias managedEntity = Promotion
    typealias managedFields = PromotionFields
    let TABLENAME  = "promotions"
    
}

extension PromotionDAO: StorageAccessor {
    var storageName: String {TABLENAME}
}
