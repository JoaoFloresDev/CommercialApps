//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

protocol CategoryCollectionViewDelegate: NSObjectProtocol {
    func causeSelected(_ view: CategoryCollectionView, causeTitle: String?, OrganizationEmail: String?, tagCollection: Int )
}

class CategoryCollectionView : UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - PROPERTIES
	var drinkList = LocalData().drinkList
    
    var categorysList = LocalData().categorysList
	
    weak var delegate: CategoryCollectionViewDelegate!
    
    var backgroundQueue: OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        return queue
    }
}

//MARK: - EXTENSION
extension CategoryCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numElem = drinkList.count
        if(collectionView.tag == 1) {
            numElem = categorysList.count
        }
        
        return numElem
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCasesOrganizations", for: indexPath) as! CellCasesOrganizations
        
        cell.shadowView.layer.shadowRadius = 3
        cell.shadowView.layer.shadowOffset = CGSize.zero
        cell.shadowView.layer.shadowOpacity = 0.5
        cell.shadowView.layer.cornerRadius = 20
        
        cell.imageView.tag = indexPath.row
        cell.delegate = self
        
        cell.email = String(collectionView.tag)
        if(collectionView.tag == 0) {
            cell.titleLabel.text = drinkList[indexPath.row]
            let image =  UIImage(named: drinkList[indexPath.row]) ?? UIImage(named: "ong-img_job")!
            cell.imageView.image = image
            
        } else {
            cell.titleLabel.text = categorysList[indexPath.row]
            let image =  UIImage(named: categorysList[indexPath.row]) ?? UIImage(named: "logo")!
            cell.imageView.image = image
        }
        
        cell.imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width - 20, height: cell.frame.height - 20)
        cell.imageView.clipsToBounds = true
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.layer.cornerRadius = 20
        
        cell.titleLabel.font = UIFont(name:"Nunito-Bold", size: 14.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemHeight = collectionView.bounds.height - 10
        
        return CGSize(width: itemHeight, height: itemHeight)
    }

}


extension CategoryCollectionView : CellCasesOrganizationsDelegate {
    func causeSelected(_ cell: CellCasesOrganizations) {
        
        if let delegate = self.delegate {
            delegate.causeSelected(self, causeTitle: cell.titleLabel.text, OrganizationEmail: cell.email, tagCollection: self.tag)
        }
    }
    
    
}
