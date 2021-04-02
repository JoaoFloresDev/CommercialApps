//
//  ExploreViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 04/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

//var promotion = Promotion(
//	name: "Rogger Egg",
//	description: "Rogger Egg",
//	price: 12,
//	imageFile: "Rogger Egg.jpg"
//)
//
//print("-------------------------------------")
//print(PromotionDAO().save(element: promotion))
//print("-------------------------------------")

import UIKit
import CoreLocation

import CoreData

class ExploreViewController: UIViewController {

	//MARK: - PROPERTIES
	var selectedItem: String = ""

	var selectedPromotion : Promotion = Promotion(
											name: "Bacon Cheddar",
											description: "Bacon Cheddar",
											price: 12,
											imageFile: "Bacon Cheddar.jpg"
										)

	var selectedJob: Int = 0
	let categories = ["Lanches", "Bebidas", "Destaques"]
	var searchController = UISearchController(searchResultsController: nil)

	var backgroundQueue: OperationQueue {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		return queue
	}

	var promotionList : [Promotion] = []
	var promotions : [Promotion] = [] {
		didSet {
			self.sortPromotions()
		}
	}

	func sortPromotions(){
		promotionList = promotions
		print(promotionList)
	}

	func loadDataPromotions() {
		let promotionDM = PromotionDAO()

		promotionDM.listAll {
			(result, error) in
			guard let result = result else { return }
			self.promotions = result

			self.reloadInputViews()
			self.exploreTableView.reloadData()
		}
		
	}

	//MARK: OUTLETS
	@IBOutlet weak var exploreTableView: UITableView!

	@IBAction func Pedir(_ sender: Any) {
		showMenu()
	}
	@IBOutlet weak var buttonCarrinho: UIButton!

	func showMenu() {
		let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let ResetGame = UIAlertAction(title: "Ligar", style: .default, handler: { (action) -> Void in
			let number = 14998985367
			if let url = URL(string: "tel://\(number)") {
				if #available(iOS 10.0, *) {
					UIApplication.shared.open(url)
				}
			}
		})

		let GoOrdemDasCartas = UIAlertAction(title: "Whatsapp", style: .default, handler: { (action) -> Void in

			var str =

			"Olá, gostaria de realizar um novo pedido!"

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
		})


		let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)

		optionMenu.addAction(ResetGame)
		optionMenu.addAction(GoOrdemDasCartas)
		optionMenu.addAction(cancelAction)

		optionMenu.modalPresentationStyle = .popover
		optionMenu.popoverPresentationController?.sourceView = self.view
		optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 1.2, width: 1.0, height: 1.0)

		self.present(optionMenu, animated: true, completion: nil)
	}

	//MARK: - LIFECYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupJobsTableView()
		setupNavegationBar()

//		buttonCarrinho.isHidden = true

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

		do {
			let itemsProduct = try managedContext.fetch(fetchRequest)
			if(!itemsProduct.isEmpty) {
//				buttonCarrinho.isHidden = false
			}
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		loadDataPromotions()

		self.exploreTableView.reloadData()

//		var promotion = Promotion(
//			name: "Bacon Cheddar",
//			description: "Bacon Cheddar",
//			price: 23,
//			imageFile: "Bacon Cheddar.jpg"
//		)
//x
//		print("-------------------------------------")
//		print(PromotionDAO().save(element: promotion))
//		print("-------------------------------------")
//
//		var promotion2 = Promotion(
//			name: "Rogger Egg",
//			description: "Rogger Egg",
//			price: 19,
//			imageFile: "Rogger Egg.jpg"
//		)
//
//		print("-------------------------------------")
//		print(PromotionDAO().save(element: promotion2))
//		print("-------------------------------------")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.layoutIfNeeded()
	}

	//MARK: - Setups
	func setupNavegationBar() {
		navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xB13424, a: 1)
		navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xB13424, a: 1)
		navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFFFFFF, a: 1)
		navigationController?.navigationBar.barStyle = .black
	}

	func setupJobsTableView() {
		exploreTableView.isHidden = false
		exploreTableView.backgroundColor = .clear

		exploreTableView.delegate = self
		exploreTableView.dataSource = self
	}

	func setupTableView(){
		exploreTableView.backgroundColor = .clear
		exploreTableView.delegate = self
		exploreTableView.dataSource = self
	}

	//MARK: - SEGUES
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is CategoryOportunitiesViewController {
			let vc = segue.destination as? CategoryOportunitiesViewController
			vc?.titleHeader = selectedItem

		}
		else if segue.destination is PromotionsViewController {
			let vc = segue.destination as? PromotionsViewController
//			vc?.titleHeader = selectedCause
			vc?.promotionBlock = selectedPromotion
		}
		else if segue.destination is DrinksViewController {
			let vc = segue.destination as? DrinksViewController
			vc?.titleHeader = selectedItem
		}
	}
}

// MARK: - UITableViewDelegate
extension ExploreViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {

		self.selectedPromotion = self.promotionList[indexPath.row]
//		self.selectedCause = self.organizationsList[indexPath.row].name
//		self.selectedCauseImage = self.organizationsList[indexPath.row].imageFile ?? "logo.png"

		self.performSegue(withIdentifier: "showPromotions", sender: self)

//		buttonCarrinho.isHidden = false

		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - UITableViewDataSource
extension ExploreViewController: UITableViewDataSource  {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let myLabel = UILabel()

		if (section == 0) {
			myLabel.frame = CGRect(x: 10, y: 20, width: 320, height: 40)
			myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
			myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

		} else if (section == 1) {
			myLabel.frame = CGRect(x: 10, y: 0, width: 320, height: 40)
			myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
			myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
		} else {
			myLabel.frame = CGRect(x: 10, y: -5, width: 320, height: 40)
			myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
			myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
		}

		let headerView = UIView()
		headerView.addSubview(myLabel)

		return headerView
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section < 2 {
			return 1
		} else {
			return promotionList.count
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if(indexPath.section < 2) {
			return 200
		}
		else {
			return 400
		}
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		if(indexPath.section < 2) {
			return 200
		}
		else {
			return 400
		}
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return categories[section]
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return categories.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let typeCell = indexPath.section


		switch typeCell {
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier:  "cell") as! CategoryCollectionView
				cell.tag = 0
				cell.delegate = self
				return cell

			case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier:  "cell2") as! CategoryCollectionView
				cell.tag = 1
				cell.delegate = self
				return cell

			case 2:
				let cell = tableView.dequeueReusableCell(withIdentifier:  "cell3")!

				let viewDemo = cell.viewWithTag(100)!
				viewDemo.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
				viewDemo.layer.cornerRadius = 20

				let imageView = cell.viewWithTag(10) as! UIImageView
				imageView.layer.cornerRadius = 20


				let imageDownloadOperation = BlockOperation {
					PromotionDAO().recoverImage(imageFile: self.promotionList[indexPath.row].imageFile, imagePlaceholder: "Duplo Salada") { (image, error) in
						guard let image = image else {
							imageView.image = UIImage(named: "logo")
							return
						}
						OperationQueue.main.addOperation {
							imageView.image = image
						}
					}
				}

				self.backgroundQueue.addOperation(imageDownloadOperation)

				return cell

			default:
				return UITableViewCell()
		}
	}
}

// MARK: - CategoryCollectionViewDelegate
extension ExploreViewController: CategoryCollectionViewDelegate {
	func causeSelected(_ view: CategoryCollectionView, causeTitle: String?, OrganizationEmail: String?,tagCollection: Int) {

		if let title = causeTitle {
			self.selectedItem = title
		}

		if(OrganizationEmail == "0") {
			self.performSegue(withIdentifier: "showCauses", sender: self)
//			buttonCarrinho.isHidden = false
		}
		else {
			self.performSegue(withIdentifier: "showDrinks", sender: self)
//			buttonCarrinho.isHidden = false
		}
	}
}

class CustomCell: UITableViewCell {

	weak var coverView: UIImageView!
	weak var titleLabel: UILabel!

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.initialize()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self.initialize()
	}

	func initialize() {
		let coverView = UIImageView(frame: .zero)
		coverView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(coverView)
		self.coverView = coverView

		let titleLabel = UILabel(frame: .zero)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(titleLabel)
		self.titleLabel = titleLabel

		NSLayoutConstraint.activate([
			self.contentView.topAnchor.constraint(equalTo: self.coverView.topAnchor),
			self.contentView.bottomAnchor.constraint(equalTo: self.coverView.bottomAnchor),
			self.contentView.leadingAnchor.constraint(equalTo: self.coverView.leadingAnchor),
			self.contentView.trailingAnchor.constraint(equalTo: self.coverView.trailingAnchor),

			self.contentView.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
			self.contentView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
		])

		self.titleLabel.font = UIFont.systemFont(ofSize: 64)
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		self.coverView.image = nil
	}
}
