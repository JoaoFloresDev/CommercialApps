//
//  Additional.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

struct Additional {
    var id: String?
    var name: String
    var price: Float

    init(name: String, price: Float) {
        self.name = name
        self.price = price
    }
    
    init?(snapshot: NSDictionary) {
        guard
            let id: String = Self.snapshotFieldReader(snapshot, .id),
            let name: String = Self.snapshotFieldReader(snapshot, .name),
            let price: Float = Self.snapshotFieldReader(snapshot, .price)
        else { return nil }
        self.id = id
        self.name = name
        self.price = price
    }
}

extension Additional: DatabaseManipulatable {
    typealias fieldEnum = AdditionalFields
    
    var representation: [String : Any] {
        let rep: [fieldEnum: Any] = [
            .id: id!,
            .name: name,
            .price: price
        ]
        
        return Dictionary(uniqueKeysWithValues: rep.map { key, value in (key.rawValue, value) })
    }
    
    static func interpret(data: NSDictionary) -> Self? {
        Additional(snapshot: data)
    }
    
    static func snapshotFieldReader<T>(_ snapshot: NSDictionary, _ field: fieldEnum) -> T? {
        snapshot[field.rawValue] as? T
    }
}

enum AdditionalFields: String, Hashable {
    case id
    case name
    case price
}
