//
//  DataManager.swift
//  TudoNosso
//
//  Created by Joao Flores on 31/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

//Tradicional
//Bacon
//Frangrill
//Costela Premium Quality
//Especial Duplo
//My House
//Kids

//Rogger Egg
//RoggerOnion
//Bacon Cheddar
//Rogger Pepperoni



import UIKit
import Foundation
import CoreData

class CoreDataManager {

	func save(title: String,
			  units: String,
			  adds: String,
			  type: String,
			  price: String) {

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "CurrentPurchase", in: managedContext)!
		let person = NSManagedObject(entity: entity, insertInto: managedContext)
		person.setValue(title, forKeyPath: "title")
		person.setValue(units, forKeyPath: "units")
		person.setValue(adds, forKeyPath: "adds")
		person.setValue(type, forKeyPath: "type")
		person.setValue(price, forKeyPath: "price")

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}

	func deleteAllRecords() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")
		if let result = try? managedContext.fetch(fetchRequest) {
			for object in result {
				managedContext.delete(object)
			}
		}

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
}

class RepeatCoreDataManager {

	func save(title: String,
			  units: String,
			  adds: String,
			  type: String,
			  price: String) {

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "RepeatPurchase", in: managedContext)!
		let person = NSManagedObject(entity: entity, insertInto: managedContext)
		person.setValue(title, forKeyPath: "title")
		person.setValue(units, forKeyPath: "units")
		person.setValue(adds, forKeyPath: "adds")
		person.setValue(type, forKeyPath: "type")
		person.setValue(price, forKeyPath: "price")

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}

	func deleteAllRecords() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepeatPurchase")
		if let result = try? managedContext.fetch(fetchRequest) {
			for object in result {
				managedContext.delete(object)
			}
		}

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
}
