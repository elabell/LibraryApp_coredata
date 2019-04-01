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

class ListTableViewCell : UITableViewCell {
    
 @IBOutlet weak var LabelItem: UILabel!
    
    var item: ItemCore? {
        
        didSet {
            
            LabelItem.text = item?.text
            
        }
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

