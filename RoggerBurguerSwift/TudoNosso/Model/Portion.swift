//
//  Portion.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

struct Portion {
    var id: String?
    var name: String
    var description: String?
    var price: Float
    var imageFile: String?

    init(name: String, description: String? = nil, price: Float, imageFile: String? = nil) {
        self.name = name
        self.description = description
        self.price = price
        self.imageFile = imageFile
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
        self.description = Self.snapshotFieldReader(snapshot, .description)
        self.imageFile = Self.snapshotFieldReader(snapshot, .imageFile)
    }
}

extension Portion: DatabaseManipulatable {
    typealias fieldEnum = PortionFields
    
    var representation: [String : Any] {
        var rep: [fieldEnum: Any] = [
            .id: id!,
            .name: name,
            .price: price
        ]
        
        if let description = self.description {
            rep[.description] = description
        }
        if let imageFile = self.imageFile {
            rep[.imageFile] = imageFile
        }
        
        return Dictionary(uniqueKeysWithValues: rep.map { key, value in (key.rawValue, value) })
    }
    
    static func interpret(data: NSDictionary) -> Self? {
        Portion(snapshot: data)
    }
    
    static func snapshotFieldReader<T>(_ snapshot: NSDictionary, _ field: fieldEnum) -> T? {
        snapshot[field.rawValue] as? T
    }
}

enum PortionFields: String, Hashable {
    case id
    case name
    case description = "desc"
    case price
    case imageFile
}
