//
//  DataManager.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerDelegate {
    func didUpdate()
}

class CoreDataManager {
    
     //add deegate here ?
    
    static let shared = CoreDataManager()
    
    var delegate: CoreDataManagerDelegate?
    
    var context : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // how to recup  he context from here to controler
    //creer 
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "LibraryApp_coredata")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        return CoreDataManager.shared.context
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
    
    
    
    // MARK: - Core
    extension CoreDataManager {
        
        func  createNewItem(txt: String, ischecked: Bool? = true)-> ItemCore {
            
            let context = self.getContext()
            let entity = NSEntityDescription.entity(forEntityName: "ItemCore" , in: context)
            
            //  let item = ItemCore(context: self.getContext())//Item(_text: txt)
            // tableItems =Array<Item>(repeating: Item, count: 9)
            
            let newitem   = ItemCore(entity: entity!, insertInto: context )
            newitem.setValue(txt, forKey: "text")
            
            addItem(item: newitem)
            saveData()
            
           return newitem
            
            
        }
   
        func initTablewithItems(){
        //let task1 = ItemCore(text : "Finir le cours d'IOS")
        // let task2 = ItemCore(text : "Mettre à jour XCode",_checked:true)
        // let task3 = ItemCore(text : "Ma tache perso")
        //  let task4 = ItemCore(text : "Home work Java",_checked:true)
        
        /*   let appDelegate = UIApplication.shared.delegate as! AppDelegate
         
         */
       var tableItems : [ItemCore] = []
        let item = ItemCore(context: self.getContext())
        
        item.checked = true
        
        let context: NSManagedObjectContext = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ItemCore" , in: context)
        
        // let newtask1   = NSManagedObject(entity: entity!, insertInto: context ) as! ItemCore
            let newtask1   = ItemCore(entity: entity!, insertInto: context )
        newtask1.setValue("Finir le cours d'IOS", forKey: "text")
        
            let newtask2   = NSManagedObject(entity: entity!, insertInto: context ) as! ItemCore
        newtask2.setValue("Mettre à jour XCode", forKey: "text")
        newtask2.setValue(true, forKey: "checked")
        
            let newtask3   = NSManagedObject(entity: entity!, insertInto: context )as! ItemCore
        newtask3.setValue("Ma tache perso", forKey: "text")
        
            let newtask4   = NSManagedObject(entity: entity!, insertInto: context ) as! ItemCore
        newtask4.setValue("Home work Java", forKey: "text")
        newtask4.setValue(true, forKey: "checked")
        
        
        //TODO insert into Coredata BBD
        //Recoup of context from CoreDataManager
        //let test = ItemCore(context: NSManagedObjectContext())
        
        tableItems.append(newtask1 )
        tableItems.append(newtask3 )
        tableItems.append(newtask3 )
        tableItems.append(newtask4 )
        
        self.saveData ()
        // nbItems = tableItems.count
        
    }
    //save the context in the Database
    func saveData (){
        do {
            try getContext().save()
        } catch{
            print("Failed saving")
        }
        
        
    }
    
  
    
        
    
    func getItems(predicate: NSPredicate? = nil,
                  sortDescriptors: [NSSortDescriptor]? = nil,
                  limit: Int = 100) -> [ItemCore] {
        
        
        let fetchRequest = NSFetchRequest<ItemCore>()
        
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        return try! getContext().fetch(fetchRequest)
        
    }
    
        func  deleteItem(item: ItemCore){
            getContext().delete(item)
            saveData()
        }
        
        func  addItem(item: ItemCore){
            getContext().insert(item)
            saveData()
        }
        
        
    func checkifCoreDataExists(text : String) -> Bool{
        //predicate // Use NSPredicate to filter articlID in coredata
        
        //let fetchRequest = NSFetchRequest<ItemCore>()
        
        let request = NSFetchRequest<ItemCore>()
        let predicate = NSPredicate(format: "text == %ld", text)
        
        request.predicate = predicate
        //  let fetchResults = self.getContext().fetch(request) as? [ItemCore]
        
        request.fetchLimit = 1
        
        do{
            
            let context =  self.getContext()
            let count = try context.count(for: request)
            if(count == 0){
                // no matching object
                print("no present")
                return false
                
            }
            else{
                // at least one matching object exists
                print("one matching item found")
                return true
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        
        
        
    }
    
    func writeData_toTableItems(entityName: String ,tableItems : [ItemCore] ){
        
        // entityName = "ItemCore"
        
        let context: NSManagedObjectContext = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName , in: context)
        
        let newrecord = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as NSManagedObject
        let timestamp = NSDate()
        
        for item in tableItems{
            
            newrecord.setValue(item.text, forKey: "text") // EBE  comment recup Key generique ??
            newrecord.setValue(item.checked, forKey: "checked")
            newrecord.setValue(item.photo, forKey: "photo")
            
            do{
                try context.save()
                print("Saved successfully")
            } catch _ {
                print("there was issue saving data!")
            }
        }
        
    }
    
    
    func fetchCoreData_fromContext() -> [ItemCore]{
        
        var tableItems : [ItemCore] = []
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCore")
        
      
        
        do {
            let result =  try  self.getContext().fetch(request)  // context contient the same data which  array [ItemCore]
            for data in result as! [NSManagedObject]{
                
                print(data.value(forKey: "text" ) as! String)
                
                
               // let  _txt: String = data.value(forKey: "text" ) as! String
               // let  _checked     = data.value(forKey: "checked" ) as? Bool
               // let  _photo           = data.value(forKey: "photo" ) as? NSData
                
                tableItems.append(data as! ItemCore)
                //newrecord.setValue(_txt, forKey: "text") // EBE  comment recup Key generique ??
                //newrecord.setValue(_checked, forKey: "checked")
                //newrecord.setValue(_photo, forKey: "photo")
                
            }
            
        } catch  {
            print("Fetch Failed")
        }
        
        return tableItems
    }
    
        func fetchfromCoreData2() -> [ItemCore]{
        
        var tableItems : [ItemCore] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCore")
        
        //it's any sql query ?
        //request.predicate = NSPredicate(format: "text = %@","Home work Java")
        let context: NSManagedObjectContext = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ItemCore" , in: context)
        
        
        do {
            let result =  try  self.getContext().fetch(request)
            for data in result as! [NSManagedObject]{
                
                print(data.value(forKey: "text" ) as! String)
                let txt: String = data.value(forKey: "text" ) as! String
                
                if(txt != ""){
                    let newtask  = NSManagedObject(entity: entity!, insertInto: context ) as! ItemCore
                    newtask.setValue(txt, forKey: "text")
                    newtask.setValue(true, forKey: "checked")
                    
                    tableItems.append(newtask)
                    saveData () // Not sure if need it here
                    
                }
                
            }
            
        } catch  {
            print("Fetch Failed")
        }
        return tableItems
        
    }
    
  
    
    
    // MARK: - C
    
    
 
  }

