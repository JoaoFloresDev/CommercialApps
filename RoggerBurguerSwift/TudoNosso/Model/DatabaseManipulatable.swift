//
//  DatabaseRepresentable.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

protocol DatabaseManipulatable {
    associatedtype fieldEnum
    var id: String? {get set}

    var representation: [String: Any] { get }
    static func interpret(data: NSDictionary) -> Self?
    static func snapshotFieldReader<T>(_ snapshot: NSDictionary,_ field: fieldEnum) -> T?
}
