//
//  ListTableViewCell.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 18/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class CellView : UITableViewCell {
    
    @IBOutlet weak var DateItem: UILabel!
    @IBOutlet weak var LabelItem: UILabel!
   // @IBOutlet weak var ImageItem: UIImageView!
  
    @IBOutlet weak var ImageItem: UIImageView!
    
    
    
    var item: ItemCore? {
        
        
        didSet {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.locale = NSLocale.current
            if (item?.deadline != nil){
                let date = formatter.string(from: (item?.deadline)!)
            DateItem?.text = date
            }
            LabelItem.text = item?.text
           // let data : Data = UIImagePNGRepresentation(item?.photo)
            // data : Data = UIImagePNGRepresentation(item.photo)
            if (item?.photo != nil) {
               let image : UIImage =  UIImage(data:(item?.photo)!)! //UIImage(data:(item?.photo)!,scale:1.0)!
                ImageItem?.image = image
            }else {
 
                // ImageItem.image = UIImage(named: "education-1545578_1280")
            }
            
        }
    }
 
    
    public func setValues(text: String? = "", checked: Bool? = false, photo: UIImage? = nil, deadline: Date? = nil){
        LabelItem.setValue(text, forKey:"text")
        ImageItem.setValue(photo, forKey:"photo")
       // LabelItem.setValue(checked, forKey:"checked")
    }
    
   // @IBOutlet weak var CheckLabel: UILabel!
    
    /*
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     
     super.init(style: style, reuseIdentifier: reuseIdentifier)
     addSubview(LabelItem)
     addSubview(CheckLabel)
     
     }
     */
    /*
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }
     */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
 }

}

