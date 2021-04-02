//
//  CategoryOportunitiesViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 11/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
class CategoryOportunitiesViewController : UIViewController,UISearchBarDelegate {

	//MARK: - Variables
	var dictPrice = LocalData().dictPrice

	var dictDescription = LocalData().dictDescription

	var additionals = LocalData().additionals

	var additionalsPriceDict = LocalData().additionalsPriceDict
	
	var unitsInt = 1

	//MARK: - OUTLETS
	@IBOutlet weak var headerItem: UINavigationItem!
	@IBOutlet weak var imageProduct: UIImageView!
	@IBOutlet weak var buttonBuy: UIButton!

	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	@IBOutlet weak var unitsProduct: UILabel!
	@IBOutlet weak var aditionalDescriptionView: UIView!

	//MARK: - ACTIONS
	@IBAction func closeView(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func addMarketPlace(_ sender: Any) {

		let adds = getAditionals()
		CoreDataManager().save(
			title: titleHeader,
			units: String(unitsInt),
			adds: adds,
			type: "Lanches",
			price: getPrice()
		)
		self.dismiss(animated: true, completion: nil)
	}

	func getPrice() -> String{ //Snack
		var price = ""

		var addsVet = [Double]()

		for add in additionalLabels {
			if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
				print(additionals[add.tag])
				print(additionalsPriceDict[additionals[add.tag]]!)
				addsVet.append(additionalsPriceDict[additionals[add.tag]]!)
			}
		}

		let sum = addsVet.reduce(0, +)
		price = String(Double(dictPrice[titleHeader]!) + Double(sum))

		return price
	}

	func getAditionals() -> String{
		var addsVet = [String]()

		for add in additionalLabels {
			if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
				let adds = add.text!
				let separateAdd = adds.components(separatedBy: " R$")
				print(separateAdd[0])
				addsVet.append(separateAdd[0])
			}
		}

		let stringRepresentation = addsVet.joined(separator:" • ")

		var adds = ""
		if(!addsVet.isEmpty) {
			adds = stringRepresentation
		}
		else {
			adds = "Sem adicionais"
		}
		return adds
	}

	//MARK: - Aditionals options
	@IBAction func addUnit(_ sender: Any) {
		unitsInt += 1
		unitsProduct.text = String(unitsInt)

		var addsVet = [Double]()

		for add in additionalLabels {
			if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
				print(additionals[add.tag])
				print(additionalsPriceDict[additionals[add.tag]]!)
				addsVet.append(additionalsPriceDict[additionals[add.tag]]!)
			}
		}

		let sum = addsVet.reduce(0, +)
		priceLabel.text = "R$ " + String((Double(dictPrice[titleHeader]! * Double(unitsInt))) + (Double(sum) * Double(unitsInt)).truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
	}

	@IBAction func subUnit(_ sender: Any) {
		if(unitsInt > 1) {
			unitsInt -= 1
			unitsProduct.text = String(unitsInt)

			var addsVet = [Double]()

			for add in additionalLabels {
				if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
					print(additionals[add.tag])
					print(additionalsPriceDict[additionals[add.tag]]!)
					addsVet.append(additionalsPriceDict[additionals[add.tag]]!)
				}
			}

			let sum = addsVet.reduce(0, +)
			priceLabel.text = "R$ " + String(Double((Double(dictPrice[titleHeader]! * Double(unitsInt))) + (Double(sum) * Double(unitsInt))).truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
		}
	}

	@IBOutlet var additionalImages: [UIImageView]!
	@IBOutlet var additionalLabels: [UILabel]!

	@IBAction func additionalPressed(_ sender: UIButton) {
		print(sender.tag)
		if(additionalLabels[sender.tag].textColor == UIColor.init(rgb: 0x33BE00)) {
			additionalImages[sender.tag].image = UIImage(named: "circle")
			additionalLabels[sender.tag].textColor  = UIColor.black
		}
		else {
			additionalImages[sender.tag].image = UIImage(named: "circleSelected")
			additionalLabels[sender.tag].textColor  = UIColor.init(rgb: 0x33BE00)
		}

		var addsVet = [Double]()

		for add in additionalLabels {
			if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
				addsVet.append(additionalsPriceDict[additionals[add.tag]]!)
			}
		}

		let sum = addsVet.reduce(0, +)
		priceLabel.text = "R$ " + String( Double(Double(dictPrice[titleHeader]! * Double(unitsInt)) + (Double(sum) * Double(unitsInt))).truncate(places: 2) ).replacingOccurrences(of: ".", with: ",")
	}

	func populateAdditionals() {
		for x in 0...25 {
			additionalLabels[x].text = additionals[x] + " R$" + String(additionalsPriceDict[additionals[x]]!)
		}
	}


	//MARK: - PROPERTIES
	var titleHeader: String = ""

	//MARK: - SETUPS
	func setupStyle() {
		imageProduct.image = UIImage(named: titleHeader)!
		imageProduct.layer.cornerRadius = 30
		imageProduct.layer.masksToBounds = true
		buttonBuy.layer.cornerRadius = 10
	}

	func setupPopulate() {
		headerItem.title = titleHeader
		priceLabel.text = "R$ " + String(dictPrice[titleHeader]!.truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
		descriptionLabel.text = dictDescription[titleHeader]
	}

	//MARK: - LIFECYCLE
	override func viewDidLoad() {
		super.viewDidLoad()

		setupStyle()
		setupPopulate()
		populateAdditionals()
	}
}



