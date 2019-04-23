//
//  HeaderCell.swift
//  LibraryApp_coredata
//
//  Created by EB on 10/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class HeaderCell:  UITableViewCell {

    @IBOutlet weak var HeaderImage: UIImageView!
    @IBOutlet weak var HeaderLabel: UILabel!
    
    func setupCellSec(image: UIImage , labelText: String){
        
        
        self.backgroundColor = UIColor.orange
       // HeaderImage.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        HeaderImage.image = image
        
      
        //HeaderLabel.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        HeaderLabel.text = labelText
        
        
    }
    func setupCellSecData(image: Data , labelText: String){
        
        
        self.backgroundColor = UIColor.orange
        // HeaderImage.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        let _image : UIImage =  UIImage(data:(image))! //UIImage(data:(item?.photo)!,scale:1.0)!
        HeaderImage.image = _image
     
        
        
        //HeaderLabel.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        HeaderLabel.text = labelText
        
        
    }
    
    var item: Category? {
        
        
        didSet {
            
 
            HeaderLabel.text = item?.name
            // let data : Data = UIImagePNGRepresentation(item?.photo)
            // data : Data = UIImagePNGRepresentation(item.photo)
            if (item?.image != nil) {
                let _image : UIImage =  UIImage(data:(item?.image)!)! //UIImage(data:(item?.photo)!,scale:1.0)!
                HeaderImage.image = _image
                
            }else {
                
                // ImageItem.image = UIImage(named: "education-1545578_1280")
            }
            
        }
    }
    
    
}
