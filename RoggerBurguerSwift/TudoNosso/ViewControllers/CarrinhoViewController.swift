//
//  CarrinhoViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 20/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData

class ProdItem {

	var image = UIImage(named: "logo")
	var title = ""
	var price = ""
	var unit = ""
	var adds = ""
	var type = "Lanche"

	init(
		image: UIImage,
		title: String,
		price: String,
		unit: String,
		adds: String,
		type: String
	) {
		self.image = UIImage(named: "logo")
		self.title = title
		self.price = price
		self.unit = unit
		self.adds = adds
		self.type = type
	}
}

class CarrinhoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

	var dictPrice = LocalData().dictPrice

	var additionalsPriceDict = LocalData().additionalsPriceDict

	var ItemsToPurchase = [CellPurchase]()

	var itemsArray = [ProdItem]()

	private var allCells = Set<UITableViewCell>()

	var backgroundQueue: OperationQueue {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		return queue
	}

	//  MARK: - IBAction
	@IBOutlet weak var buttonSend: UIButton!
	@IBOutlet weak var tableItens: UITableView!
	@IBOutlet weak var paymentTotalLabel: UILabel!

	//  MARK: - IBAction
	func saveInRepeatPurchase() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepeatPurchase")

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		RepeatCoreDataManager().deleteAllRecords()

		let managedContext2 = appDelegate.persistentContainer.viewContext
		let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

		do {
			itemsProduct = try managedContext2.fetch(fetchRequest2)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		for person in itemsProduct {
			RepeatCoreDataManager().save(title: (person.value(forKeyPath: "title") as? String)!, units: (person.value(forKeyPath: "units") as? String)!, adds: (person.value(forKeyPath: "adds") as? String)!, type: (person.value(forKeyPath: "type") as? String)!, price: (person.value(forKeyPath: "price") as? String)!)
		}
	}


	func sendToWhatsApp() {
		updateTextFields()
		saveInRepeatPurchase()

		let name = nameText.text ?? "Não preenchido"
		let payform = payformText.text ?? "Não preenchido"
		let endress = endressText.text ?? "Não preenchido"
		let phone = phoneText.text ?? "Não preenchido"
		let obs = obsText.text
		let troco = returnPaymentText.text
		let deliveryMode = deliveryModeText.text ?? "Não preenchido"
		var productsArray = [String]()
		var totalPrice: Double = 0.0
		if(deliveryMode == "Entregar em casa (taxa R$ 4,00)") {
			totalPrice += 4
		}
		
		if (tableItens.numberOfRows(inSection: 0) > 0) {
			for item in itemsProduct {

				let type = item.value(forKeyPath: "type") as! String
				let title = item.value(forKeyPath: "title") as! String
				let adds = item.value(forKeyPath: "adds") as! String
				let units = item.value(forKeyPath: "units") as! String
				var priceItem: Double = 0

				if(type == "Drinks") {
					priceItem = Double(dictPrice[adds]!) * Double(units)!
				}
				else if (type == "Promo") {
					let price = item.value(forKeyPath: "price") as! String
					priceItem = Double(price)! * Double(units)!
				}
				else { //Snack
					var sumAdditionals: Double = 0

					print(adds)
					if(adds != "Sem adicionais") {
						let additionals = adds.replacingOccurrences(of: "Adicionais: ", with: "")
						let arrayAdd = additionals.components(separatedBy: " • ")

						for add in arrayAdd {
							let teste = additionalsPriceDict[add]
							sumAdditionals += teste!
						}
					}

					priceItem = Double(Double(dictPrice[title]!) + Double(sumAdditionals)) * Double(units)!
				}

				totalPrice += priceItem.truncate(places: 2)

				var product = "*" + units
				product +=	"x " + title + " R$"
				product += String(
					format: "%.2f",
					priceItem.truncate(places: 2)
				).replacingOccurrences(of: ".", with: ",")  + "*"
				if(type != "Promo") {
					product += "\n" + "_" + adds + "_"
				}

				productsArray.append(product)
			}

			paymentTotalLabel.text = "Total: R$ " +
				String(
					format: "%.2f",
					totalPrice.truncate(places: 2)
				).replacingOccurrences(of: ".", with: ",")

		}

		let productsList = productsArray.joined(separator:" \n\n") + "\n\n"

		let price =
			String(
				format: "%.2f",
				totalPrice.truncate(places: 2)
			).replacingOccurrences(of: ".", with: ",")
		var str =
			"*Nome:* " + name +
				"\n*Endereço:* " + endress +
				"\n*Telefone:* " + phone +
				"\n\n*Pedido*\n\n" + productsList

		if let observation = obs {
			if(observation != "") {
				str += "*Observações*\n" + observation + "\n\n"
			}
		}

		str += "*Forma de entrega:* " + deliveryMode + "\n\n"

		str += "*Pagamento:* " + payform

		if let retrunMoney = troco {
			if(retrunMoney != "") {
				str += "\n*Troco:* R$" + retrunMoney
			}
			else if(payform == "Dinheiro"){
				str += " (sem troco)"
			}
		}

		str += "\n\n*Total: R$" + price + "*"

		str = str.addingPercentEncoding(withAllowedCharacters: (NSCharacterSet.urlQueryAllowed))!

		let phoneNumber =  "+5514998985367" // you need to change this number

		let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=\(str)")!
		if UIApplication.shared.canOpenURL(appURL) {
			if #available(iOS 10.0, *) {
				UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
			}
			else {
				UIApplication.shared.openURL(appURL)
			}
		} else {
			print("WhatsApp is not installed")
		}
	}

	@IBAction func sendCarrinho(_ sender: Any) {

		if(tableItens.numberOfRows(inSection: 0) == 0) {
			showAlert(title: "Carrinho Vazio", message: "Volte para o menu e selecione os produtos desejados")
		}
		else if(nameText.text == "" || nameText.text == nil) {
			nameText.becomeFirstResponder()
		}
		else if(endressText.text == "" || endressText.text == nil) {
			endressText.becomeFirstResponder()
		}
		else if(payformText.text == "" || payformText.text == nil) {
			payformText.becomeFirstResponder()
		}
		else {
			sendToWhatsApp()
		}
	}

	@IBAction func closeView(_ sender: Any) {
		updateTextFields()
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func clearList(_ sender: Any) {
		CoreDataManager().deleteAllRecords()
		updateData()
		tableItens.reloadData()
		updateTotalValue()
	}

	//	MARK: - UIALERT
	func showAlert(title: String, message: String) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
			action in
			self.dismiss(animated: true, completion: nil)
		}))

		self.present(alert, animated: true, completion: nil)
	}

	//  MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

		buttonSend.layer.cornerRadius = 10
		setepKeyboard()
		dataTableview()

		let picker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height-320, width: self.view.frame.size.width, height: 320))
		picker.dataSource = self
		picker.delegate = self
		picker.tag = 0

		let picker1 = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height-320, width: self.view.frame.size.width, height: 320))
		picker1.dataSource = self
		picker1.delegate = self

		payformText.inputAccessoryView = inputAccessoryViewPicker
		payformText.inputView = picker
//		payformText.tag = 0

		deliveryModeText.inputAccessoryView = inputAccessoryViewPicker1
		deliveryModeText.inputView = picker1
		picker1.tag = 1
//		payformText.tag = 1
	}

	var inputAccessoryViewPicker: UIView? {

		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(title: "Próximo", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneDatePicker))
		toolbar.setItems([spaceButton, doneButton], animated: false)

		return toolbar
	}

	var inputAccessoryViewPicker1: UIView? {

		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(title: "Próximo", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneDatePicker1))
		toolbar.setItems([spaceButton, doneButton], animated: false)

		return toolbar
	}

	@objc func doneDatePicker() {
		deliveryModeText.becomeFirstResponder()
	}

	@objc func doneDatePicker1() {
		obsText.becomeFirstResponder()
		updateTotalValue()
	}

	override func viewWillAppear(_ animated: Bool) {
		setupTextFields()
		updateTotalValue()
	}

	//  MARK: - PickerView
	var data =  ["Cartão","Dinheiro"]
	var deliveryData =  ["Entregar em casa (taxa R$ 4,00)","Retirar no local"]

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		return data.count
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if(pickerView.tag == 0) {
			payformText.text = data[row]
		}
		else {
			deliveryModeText.text = deliveryData[row]
			updateTotalValue()
		}
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if(pickerView.tag == 0) {
			return data[row]
		}
		else {
			updateTotalValue()
			return deliveryData[row]
		}
	}

	//  MARK: - TableView
	let cellIdentifier = "CellIdentifier"


	func dataTableview() {

		tableItens.delegate = self
		tableItens.dataSource = self

		guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
			return
		}

		updateData()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CellPurchase

		let viewProd = cell.viewItem!
		viewProd.layer.cornerRadius = 10
		viewProd.layer.shadowOpacity = 0.5
		viewProd.layer.shadowRadius = 3
		viewProd.layer.shadowOffset = CGSize.zero

		let item = itemsProduct[indexPath.row]

		let title = cell.titleLabel!
		title.text = item.value(forKeyPath: "title") as? String

		let adds = cell.additionalsLabel!
		adds.text = item.value(forKeyPath: "adds") as? String

		let units = cell.unitsItem!
		units.text = item.value(forKeyPath: "units") as? String

		let image = cell.imageItem!
		image.image = UIImage(named: (item.value(forKeyPath: "title") as? String)!)
		image.layer.cornerRadius = 5

		cell.delegate = self

		let type = item.value(forKeyPath: "type") as? String

		if(adds.text != "Sem adicionais" && type == "Lanches" ) {
			print("---- 1 -----")
			var sumAdditionals: Double = 0
			let additionalsString = item.value(forKeyPath: "adds") as? String
			let additionals = additionalsString?.replacingOccurrences(of: "Adicionais: ", with: "")
			let arrayAdd = additionals!.components(separatedBy: " • ")

			for add in  arrayAdd {
				let teste = additionalsPriceDict[add]
				sumAdditionals += teste!
			}

			let price = cell.priceLabel!
			price.text = "R$ " + String(
				format: "%.2f",
				Double((dictPrice[title.text!]! + sumAdditionals) * Double(units.text!)!).truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
			price.sizeToFit()
			price.adjustsFontSizeToFitWidth = true
		}
		else if(type == "Drinks" ) {

			let price = cell.priceLabel!
			price.text = "R$ " + String(
				format: "%.2f",
				Double(dictPrice[item.value(forKeyPath: "adds")! as! String]!) * Double(units.text!)!.truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
			price.sizeToFit()
			price.adjustsFontSizeToFitWidth = true
		}
		else if(type == "Promo" ){

			let price = cell.priceLabel!
			price.text = "R$ " +
				String(
				format: "%.2f",
				Double(item.value(forKeyPath: "price")! as! String)! * Double(units.text!)!).replacingOccurrences(of: ".", with: ",")
			price.sizeToFit()
			price.adjustsFontSizeToFitWidth = true

			self.updateTotalValue()

			PromotionDAO().find(inField: PromotionDAO.managedFields(rawValue: "name")!, comparisonType: .equal, withValue: title.text!) { (image, error) in

				guard let image = image else {
					print ("---- erro ----")
					return
				}
				OperationQueue.main.addOperation {

					if(image.count == 0) {
						cell.titleLabel.text = "Indisponível"
						let price = cell.priceLabel!
						price.text = "R$ 0,00"
						price.sizeToFit()
						price.adjustsFontSizeToFitWidth = true

						return
					}

					let item = image[0]

					let imageDownloadOperation = BlockOperation {
						PromotionDAO().recoverImage(imageFile: item.imageFile, imagePlaceholder: "logo") { (image, error) in
							guard let image = image else {
								let image = cell.imageItem
								image!.image = UIImage(named: "logo")
								image!.layer.cornerRadius = 5
								return
							}
							OperationQueue.main.addOperation {
								let imageCell = cell.imageItem
								imageCell!.image = image
								imageCell!.layer.cornerRadius = 5
							}
						}
					}

					self.backgroundQueue.addOperation(imageDownloadOperation)
				}
			}
		}
		else {
			let price = cell.priceLabel!
			price.text = "R$ " +
				String(
					format: "%.2f",
					Double(Double(dictPrice[title.text!]!) * Double(units.text!)!).truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
			price.sizeToFit()
			price.adjustsFontSizeToFitWidth = true
		}

		return cell
	}

	func updateTotalValue() {

		var totalPrice: Double = 0.0
		if (deliveryModeText.text == "Entregar em casa (taxa R$ 4,00)") {
			totalPrice += 4
		}

		if (tableItens.numberOfRows(inSection: 0) > 0) {

			var i = 0
			for item in itemsProduct {
				i += 1
				print(i)

				let type = item.value(forKeyPath: "type") as! String
				let title = item.value(forKeyPath: "title") as! String
				let adds = item.value(forKeyPath: "adds") as! String
				let units = item.value(forKeyPath: "units") as! String

				print("---")
				print(type)
				print(title)
				if(type == "Drinks") {
					print("Drinks")
					totalPrice += Double(dictPrice[adds]!) * Double(units)!
				}
				else if (type == "Promo") {
					let price = item.value(forKeyPath: "price") as! String
					if (price != "0") {
						print("--- promoção ----")
						totalPrice += Double(price)! * Double(units)!
						print(Double(price)!, Double(units)!)
					}
				}
				else { //Snack
					print("Snack")
					var sumAdditionals: Double = 0

					if(adds != "Sem adicionais") {
						let additionals = adds.replacingOccurrences(of: "Adicionais: ", with: "")
						let arrayAdd = additionals.components(separatedBy: " • ")

						for add in arrayAdd {
							let teste = additionalsPriceDict[add]
							print(teste)
							sumAdditionals += teste!
						}
					}

					totalPrice += (Double(dictPrice[title]!) + Double(sumAdditionals)) * Double(units)!
				}
			}
			let price = String(
				format: "%.2f",
				totalPrice.truncate(places: 2)).replacingOccurrences(of: ".", with: ",")

			paymentTotalLabel.text = "Total: R$ " + price
		}

		else {
			let price = String(
				format: "%.2f",
				totalPrice.truncate(places: 2)).replacingOccurrences(of: ".", with: ",")
			paymentTotalLabel.text = "Total: R$ " + price
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = itemsProduct.count
		return numberOfRows
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemsProduct.count
	}

	//	MARK: - Textfield
	//IBOutlet
	@IBOutlet weak var nameText: UITextField!
	@IBOutlet weak var endressText: UITextField!
	@IBOutlet weak var payformText: UITextField!
	@IBOutlet weak var obsText: UITextField!
	@IBOutlet weak var returnPaymentText: UITextField!
	@IBOutlet weak var phoneText: UITextField!
	@IBOutlet weak var deliveryModeText: UITextField!


	func setupTextFields() {
		nameText.text = UserDefaults.standard.string(forKey: "nameText")
		endressText.text = UserDefaults.standard.string(forKey: "endressText")
		payformText.text = "Cartão"
		deliveryModeText.text = "Entregar em casa (taxa R$ 4,00)"
		obsText.text = UserDefaults.standard.string(forKey: "obsText")
		phoneText.text = UserDefaults.standard.string(forKey: "phoneText")
	}

	func updateTextFields() {
		UserDefaults.standard.set(nameText.text, forKey: "nameText")
		UserDefaults.standard.set(endressText.text, forKey: "endressText")
		UserDefaults.standard.set(payformText.text, forKey: "payformText")
		UserDefaults.standard.set(obsText.text, forKey: "obsText")
		UserDefaults.standard.set(phoneText.text, forKey: "phoneText")
	}

	//	MARK:  - Keyboard

	func setepKeyboard() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tap)

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

		nameText.delegate = self
		endressText.delegate = self
		payformText.delegate = self
		obsText.delegate = self
		returnPaymentText.delegate = self
		phoneText.delegate = self

		nameText.autocapitalizationType = .words
		endressText.autocapitalizationType = .words
		payformText.autocapitalizationType = .words
		obsText.autocapitalizationType = .sentences
		phoneText.autocapitalizationType = .words
	}

	@objc func dismissKeyboard() {
		view.endEditing(true)
		updateTotalValue()
	}

	@objc func keyboardWillShow(sender: NSNotification) {
		let info = sender.userInfo
		let keyboardSize: CGRect = (info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

		tableItens.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
		tableItens.scrollIndicatorInsets = tableItens.contentInset
	}

	@objc func keyboardWillHide(sender: NSNotification) {
		print("keyboard will be hidden")
		tableItens.contentInset = UIEdgeInsets.zero
		tableItens.scrollIndicatorInsets = UIEdgeInsets.zero
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let nextTag = textField.tag + 1

		if let nextResponder = textField.superview?.viewWithTag(nextTag) {
			nextResponder.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}

		return true
	}

	//	MARK: - COREDATA
	var itemsProduct: [NSManagedObject] = []

	func updateData() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)
			
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		tableItens.reloadData()
		updateTotalValue()
	}

	func populateData() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)

		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}


		for item in itemsProduct {
			let type = item.value(forKeyPath: "type") as! String
			let title = item.value(forKeyPath: "title") as! String
			let adds = item.value(forKeyPath: "adds") as! String
			let units = item.value(forKeyPath: "units") as! String
			var priceItem: Double = 0
			var image = UIImage(named: "logo")!

			if(type == "Drinks") {
				priceItem = Double(dictPrice[adds]!) * Double(units)!
				image = UIImage(named: title)!
			}
			else if (type == "Promo") {
				let price = item.value(forKeyPath: "price") as! String
				if (price != "0") {
					priceItem = Double(price)! * Double(units)!
				}
			}
			else { //Snack
				var sumAdditionals: Double = 0

				if(adds != "Sem adicionais") {
					let additionals = adds.replacingOccurrences(of: "Adicionais: ", with: "")
					let arrayAdd = additionals.components(separatedBy: " • ")

					for add in arrayAdd {
						let teste = additionalsPriceDict[add]
						sumAdditionals += teste!
					}
				}

				priceItem = (Double(dictPrice[title]!) + Double(sumAdditionals)) * Double(units)!

				image = UIImage(named: title)!
			}

			var newItem = ProdItem(image: image, title: title, price: String(priceItem), unit: units, adds: adds, type: type)
			itemsArray.append(newItem)
		}

		tableItens.reloadData()
		updateTotalValue()
	}
}

extension UITableView {
	func reloadData(completion:@escaping ()->()) {
		UIView.animate(withDuration: 0, animations: { self.reloadData() })
		{ _ in completion() }
	}
}

extension UITableViewDataSource where Self: UITableView {
	/**
	* Returns all cells in a table
	* ## Examples:
	* tableView.cells // array of cells in a tableview
	*/
	public var cells: [UITableViewCell] {
		(0..<self.numberOfSections).indices.map { (sectionIndex: Int) -> [UITableViewCell] in
			(0..<self.numberOfRows(inSection: sectionIndex)).indices.compactMap { (rowIndex: Int) -> UITableViewCell? in
				self.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex))
			}
		}.flatMap { $0 }
	}
}

extension CarrinhoViewController: CellPurchaseDelegate {
	func close(cell: CellPurchase) {
		let index = tableItens.indexPath(for: cell)!

		print("---- delete -----")
		print(index.row)

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")
		if let result = try? managedContext.fetch(fetchRequest) {
			managedContext.delete(result[index.row])
		}

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		updateData()
	}

	func addUnit(cell: CellPurchase) {
		let index = tableItens.indexPath(for: cell)!

		print("---- add -----")
		print(index.row)

		let units = Int(itemsProduct[index.row].value(forKeyPath: "units") as! String)!

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

		do {
			try managedContext.fetch(fetchRequest)[index.row].setValue(String(units + 1), forKeyPath: "units")
			try managedContext.save()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		updateData()
	}

	func subUnit(cell: CellPurchase) {
		let index = tableItens.indexPath(for: cell)!

		print("---- sub -----")
		print(index.row)

		let units = Int(itemsProduct[index.row].value(forKeyPath: "units") as! String)!

		if(units > 1) {
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
				return
			}

			let managedContext = appDelegate.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

			do {
				try managedContext.fetch(fetchRequest)[index.row].setValue(String(units - 1), forKeyPath: "units")
				try managedContext.save()
			} catch let error as NSError {
				print("Could not fetch. \(error), \(error.userInfo)")
			}

			updateData()
		}
	}
}

extension Double
{
	func truncate(places : Int)-> Double
	{
		return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
	}
}
