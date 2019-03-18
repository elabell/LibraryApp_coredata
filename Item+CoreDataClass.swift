//
//  Item+CoreDataClass.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//
//

import Foundation
import CoreData


//custom code 
public class ItemCore: NSManagedObject {
   // var  text: String = ""
   // var  checked: Bool = false
    
   /*
    //Constructors//
    init(_text: String) {
        super.init()
       text = _text
        
    }
    init(_text: String,_checked: Bool = false) {
        
        text = _text
        checked = _checked
    }
    */
    func toggleChecked(){
   
        if (self.checked){
         self.checked = false
         }
         else{
         self.checked = true
         }
        
        checked =  (self.checked ) ?  false : true
        
    }
   

}
