//
//  cellPurchase.swift
//  TudoNosso
//
//  Created by Joao Flores on 31/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData

protocol CellPurchaseDelegate: NSObjectProtocol {

	func close(cell: CellPurchase )

	func addUnit(cell: CellPurchase )

	func subUnit(cell: CellPurchase )
}

class CellPurchase: UITableViewCell {

	weak var delegate: CellPurchaseDelegate?

	var dictPrice = LocalData().dictPrice

	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var subButton: UIButton!

	@IBOutlet weak var unitsItem: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var additionalsLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!

	@IBOutlet weak var imageItem: UIImageView!
	@IBOutlet weak var viewItem: UIView!


	var priceUnit = 0

	@IBAction func closeButton(_ sender: Any) {

		if let delegate = self.delegate {
			delegate.close(cell: self)
		}
	}

	@IBAction func AddButton(_ sender: Any) {

		if let delegate = self.delegate {
			delegate.addUnit(cell: self)
		}
	}

	@IBAction func subButton(_ sender: Any) {

		if let delegate = self.delegate {
			delegate.subUnit(cell: self)
		}
	}

	override func prepareForReuse() {
		unitsItem.text = "1"
		titleLabel.text = ""
		additionalsLabel.text = ""
		priceLabel.text = ""
		imageItem.image = UIImage(named: "logo")
	}
}
