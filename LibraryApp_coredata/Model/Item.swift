//
//  Item.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
class Item  {
    var  text: String = ""
    var  checked: Bool = false
    
    
    //Constructors//
    init(_text: String) {
        
        self.text = _text
        
    }
    init(_text: String,_checked: Bool = false) {
        
        self.text = _text
        self.checked = _checked
    }
    
    func toggleChecked(){
        /* if (self.checked){
         self.checked = false
         }
         else{
         self.checked = true
         }
         */
        self.checked =  (self.checked ) ?  false : true
        
    }
    
    
}
