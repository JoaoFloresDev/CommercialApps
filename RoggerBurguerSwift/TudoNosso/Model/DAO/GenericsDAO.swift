//
//  GenericsDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol GenericsDAO {
    associatedtype managedEntity: DatabaseManipulatable
    associatedtype managedFields: RawRepresentable where managedFields.RawValue == String
    
    var db: Firestore {get}
    var TABLENAME: String {get}
    
    /// Saves or updates an element
    /// - Parameter element: Element to be saved or updated
    /// - returns: The copy of the element with right id
    func save(element: managedEntity) -> managedEntity
    
    ///
    /// Deletes an element using its id
    /// - Parameter element: Element to be deleted
    func delete(element: managedEntity)
    
    /// Lists all elements
    /// - Parameter completion: What to do with the list, defines a closure that receives the returned list of elements or an error
    func listAll(completion: @escaping ([managedEntity]?, Error?) -> ())
    
    /// Finds N elements that matches field values given a comparison
    /// - Parameters:
    ///   - field: What  field to compare
    ///   - type: How to compare (e.g: greaterThan, equal)
    ///   - value: What is expected to match
    ///   - completion: What to do with the result, defines a closure that receives the returned list of elements or an error
    func find(inField field: managedFields, comparisonType type: ComparisonType, withValue value: Any, completion: @escaping ([managedEntity]?,Error?) ->())
}


extension GenericsDAO{
    var db: Firestore { Firestore.firestore() }
    
    /// Transforms a firestore query result (list) into a T list, the T cclass needs to implement DatabaseManipulable protocol
    /// - Parameters:
    ///   - querySnapshot: firestore documents list
    ///   - error: firestore error
    ///   - completion: what to do with the result
    private func handleDocuments<T: DatabaseManipulatable>(_ querySnapshot: QuerySnapshot?, _ error: Error?, completion: @escaping ([T]?,Error?) -> ()) {
        if let error = error {
            completion(nil, error)
        } else if let snapshot = querySnapshot {
            let resultList = snapshot.documents.compactMap{ (child) -> T? in
                if let interpreted = T.interpret(data: child.data() as NSDictionary) {
                    return interpreted
                }
                return nil
            }
            completion(resultList, nil)
        } else {
            completion(nil, nil)
        }
    }
    
    /// Transforms a firestore document into a T element, the T class needs to implement DatabaseManipulable protocol
    /// - Parameters:
    ///   - snapshot: firestore document (register, e.g: A line of a firestore table)
    ///   - error: firestore error
    ///   - completion: what to do with the result
    private func handleSingleDocument<T: DatabaseManipulatable>(_ snapshot: DocumentSnapshot?, _ error: Error?, completion: @escaping (T?,Error?) -> ()) {
        
        if let error = error {
            completion(nil, error)
        }
        guard
            let snapshot = snapshot,
            let data = snapshot.data(),
            let interpreted = T.interpret(data: data as NSDictionary)
            else { completion(nil, nil) ; return }
        
        completion(interpreted, nil)
    }
    
    func save(element: managedEntity) -> managedEntity {
        if let id = element.id {//updates
            db.collection(TABLENAME).document(id).setData(element.representation)
            return element
        }else { //saves/creates
            let doc = self.db.collection(self.TABLENAME).document()
            var newElement = element
            newElement.id = doc.documentID
            db.collection(TABLENAME).document(doc.documentID).setData(newElement.representation)
            return newElement
        }
    }
    
    func delete(element: managedEntity) {
        db.collection(TABLENAME).document(element.id!).delete { error in
            if let error = error {
                print("error deleting snackL \(error.localizedDescription)")
            }
        }
    }
    
    func listAll(completion: @escaping ([managedEntity]?, Error?) -> ()) {
        db.collection(TABLENAME).getDocuments { (snapshot, error) in
            self.handleDocuments(snapshot, error, completion: completion)
        }
    }
    
    func find(inField field: managedFields, comparisonType type: ComparisonType, withValue value: Any, completion: @escaping ([managedEntity]?,Error?) ->()) {
        
        switch type {
        case .equal:
            db.collection(TABLENAME).whereField(field.rawValue, isEqualTo: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .lessThan:
            db.collection(TABLENAME).whereField(field.rawValue, isLessThan: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .lessThanOrEqual:
            db.collection(TABLENAME).whereField(field.rawValue, isLessThanOrEqualTo: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .greaterThan:
            db.collection(TABLENAME).whereField(field.rawValue, isGreaterThan:  value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .greaterThanOrEqual:
            db.collection(TABLENAME).whereField(field.rawValue, isGreaterThanOrEqualTo:  value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .arrayContains:
            db.collection(TABLENAME).whereField(field.rawValue, arrayContains: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .inArray:
            guard let array = value as? Array<Any> else {fatalError("not an array")}
            db.collection(TABLENAME).whereField(field.rawValue, in: array).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        }
    }
    
}

enum ComparisonType{
    case equal
    case lessThan
    case lessThanOrEqual
    case greaterThan
    case greaterThanOrEqual
    case arrayContains
    case inArray
}


