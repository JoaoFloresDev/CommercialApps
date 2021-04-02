//
//  Ndrink.swift
//  TudoNosso
//
//  Created by Joao Flores on 11/09/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData

class DrinksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
	
	var dictPrice = LocalData().dictPrice
	var titleHeader: String = ""
	var additionalsPriceDict = LocalData().additionalsPriceDict
	
	//  MARK: - IBAction
	@IBOutlet weak var buttonSend: UIButton!
	@IBOutlet weak var tableItens: UITableView!
	@IBOutlet weak var paymentTotalLabel: UILabel!
	@IBOutlet weak var headerItem: UINavigationItem!
	@IBOutlet weak var imageProduct: UIImageView!
	
	//  MARK: - IBAction
	func saveInRepeatPurchase() {
		
		if (tableItens.numberOfRows(inSection: 0) > 0) {
			for x in 0...(tableItens.numberOfRows(inSection: 0)-1) {
				if (tableItens.cellForRow(at: IndexPath(row: x, section: 0)) as? CellDrink) != nil {
					let cell = tableItens.cellForRow(at: IndexPath(row: x, section: 0)) as! CellDrink
					
					var price = cell.priceLabel.text!
					price = price.replacingOccurrences(of: "R$ ", with: "")
					
					if let addValue = Double(price) {
						if(addValue * Double(cell.unitsItem.text!)! > 0) {
							let title = cell.viewWithTag(titleTag) as! UILabel
							addingProductsToCart(adds: title.text!, unitsInt: Int(cell.unitsItem.text!)!)
						}
					}
				}
			}
		}
		self.dismiss(animated: true, completion: nil)
	}
	
	func addingProductsToCart(adds: String, unitsInt: Int)  {
		CoreDataManager().save(
			title: titleHeader,
			units: String(unitsInt),
			adds: adds,
			type: "Drinks",
			price: String(dictPrice[adds]!)
		)
	}
	
	@IBAction func sendCarrinho(_ sender: Any) {
		saveInRepeatPurchase()
	}
	
	@IBAction func closeView(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	//  MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		headerItem.title = titleHeader
		setupStyle()
		dataTableview()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		updateTotalValue()
	}
	
	@IBAction func addButtonPressed(_ sender: Any) {
		updateTotalValue()
	}
	
	@IBAction func subButtonPressed(_ sender: Any) {
		updateTotalValue()
	}
	
	//  MARK: - TableView
	let cellIdentifier = "CellIdentifier"
	
	//tags
	let titleTag = 1000
	let addsTag = 1001
	let priceTag = 1003
	let unitsTag = 1004
	let viewTag = 100
	let imageTag = 10
	let deleteTag = 1
	
	func dataTableview() {
		
		tableItens.delegate = self
		tableItens.dataSource = self
		
		guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
			return
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CellDrink
		
		let viewProd = cell.viewWithTag(viewTag)!
		viewProd.layer.cornerRadius = 10
		viewProd.layer.shadowOpacity = 0.3
		viewProd.layer.shadowRadius = 2
		viewProd.layer.shadowOffset = CGSize.zero
		
		let title = cell.viewWithTag(titleTag) as! UILabel
		title.text = LocalData().dictDescription2[titleHeader]![indexPath.row]
		
		let units = cell.viewWithTag(unitsTag) as! UILabel
		units.text = "0"
		units.sizeToFit()
		units.adjustsFontSizeToFitWidth = true

		
		let price = cell.viewWithTag(priceTag) as! UILabel
		price.text = "R$ " + String(dictPrice[title.text!]!)
		
		cell.selectionStyle = UITableViewCell.SelectionStyle.none
		
		return cell
	}
	
	func updateTotalValue() {
		var totalPrice: Double = 0.0
		
		if (tableItens.numberOfRows(inSection: 0) > 0) {
			for x in 0...(tableItens.numberOfRows(inSection: 0)-1) {
				if (tableItens.cellForRow(at: IndexPath(row: x, section: 0)) as? CellDrink) != nil {
					let cell = tableItens.cellForRow(at: IndexPath(row: x, section: 0)) as! CellDrink
					
					var price = cell.priceLabel.text!
					price = price.replacingOccurrences(of: "R$ ", with: "")
					
					if let addValue = Double(price) {
						totalPrice += addValue * Double(cell.unitsItem.text!)!
					}
				}
			}
			let price = String(totalPrice.truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
			
			paymentTotalLabel.text = "R$ " + price
		}
		else {
			paymentTotalLabel.text = "R$ 0,00"
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = LocalData().dictDescription2[titleHeader]!.count
		return numberOfRows
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func setupStyle() {
		imageProduct.image = UIImage(named: titleHeader)!
		imageProduct.layer.cornerRadius = 30
		imageProduct.layer.masksToBounds = true
		buttonSend.layer.cornerRadius = 10
		
	}
}
