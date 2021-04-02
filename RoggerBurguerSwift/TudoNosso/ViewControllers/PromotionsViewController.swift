//
//  CategoryOportunitiesViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 11/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
class PromotionsViewController : UIViewController,UISearchBarDelegate {
	
	//MARK: - Variables
	var additionals = LocalData().additionals
	
	var additionalsPriceDict = LocalData().additionalsPriceDict
	
	var unitsInt = 1
	
	var backgroundQueue: OperationQueue {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 3
		return queue
	}
	
	//MARK: - OUTLETS
	@IBOutlet weak var headerItem: UINavigationItem!
	@IBOutlet weak var imageProduct: UIImageView!
	@IBOutlet weak var buttonBuy: UIButton!
	
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var unitsProduct: UILabel!
	
	//MARK: - ACTIONS
	@IBAction func closeView(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func addMarketPlace(_ sender: Any) {
		
		CoreDataManager().save(
			title: titleHeader,
			units: String(unitsInt),
			adds: "",
			type: "Promo",
			price: String(promotionBlock.price)
		)
		self.dismiss(animated: true, completion: nil)
	}
	
	//MARK: - Aditionals options
	@IBAction func addUnit(_ sender: Any) {
		unitsInt += 1
		unitsProduct.text = String(unitsInt)
		
		priceLabel.text = "R$ " + String(Double(promotionBlock.price) * Double(unitsInt).truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
	}
	
	@IBAction func subUnit(_ sender: Any) {
		if(unitsInt > 1) {
			unitsInt -= 1
			unitsProduct.text = String(unitsInt)
			
			priceLabel.text = "R$ " + String(Double(promotionBlock.price) * Double(unitsInt).truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
		}
	}
	
	//MARK: - PROPERTIES
	var titleHeader: String = ""
	var imageHeader: String = ""
	var promotionBlock = Promotion(
		name: "Bacon Cheddar",
		description: "Bacon Cheddar",
		price: 12,
		imageFile: "Bacon Cheddar.jpg"
	)
	
	//MARK: - SETUPS
	func setupStyle() {
		imageHeader = promotionBlock.imageFile ?? "logo"
		titleHeader = promotionBlock.name
		
		let imageDownloadOperation = BlockOperation {
			PromotionDAO().recoverImage(imageFile: self.imageHeader, imagePlaceholder: "Duplo Salada") { (image, error) in
				guard let image = image else {
					self.imageProduct.image = UIImage(named: "logo")
					return
				}
				OperationQueue.main.addOperation {
					self.imageProduct.image = image
				}
			}
		}
		self.backgroundQueue.addOperation(imageDownloadOperation)
		
		imageProduct.layer.cornerRadius = 30
		imageProduct.layer.masksToBounds = true
		buttonBuy.layer.cornerRadius = 10
	}
	
	func setupPopulate() {
		headerItem.title = titleHeader
		priceLabel.text = "R$ " + String(Double(promotionBlock.price).truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
		descriptionLabel.text = promotionBlock.description
	}
	
	//MARK: - LIFECYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupStyle()
		setupPopulate()
	}
}



