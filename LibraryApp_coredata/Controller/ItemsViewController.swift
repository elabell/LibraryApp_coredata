//
//  ItemsViewController.swift
//  LibraryApp_coredata
//
//  Created by EB on 20/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ItemsViewController: UIViewController,SegueHandlerType,ItemDetailViewDelegate {
    
    func userAddedItem(_ controller: ItemDetailViewController, category: Category, item: ItemCore) {
        
        self.addItem(item: item)
        self.stateAdd = false
        self.dismiss(animated: true, completion: nil)
        
        
    }
    func userUpdatedItem(_ controller: ItemDetailViewController, category: Category, item: ItemCore, rowIndex: IndexPath) {
        
        self.editItem(item: item, indexPath: rowIndex)
        self.stateEdit = false
        self.dismiss(animated: true, completion: nil)
        
    }

    
  
    
    var delegate : ItemsViewDelegate? = nil
     //TODO passer Category  from precedent class/ ecran
    var category: Category? = nil
    var tableItems : [ItemCore] = []
    
    var stateEdit: Bool = false
    var stateAdd: Bool = false
    var editedItemIndex: IndexPath? = nil
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var btnAddItem: UIBarButtonItem!
    
    @IBOutlet weak var btnItemDetails: UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var tableViewItem: UITableView!
    
    
    
    enum SegueIdentifier: String {
        case ShowItemDetails
        case AddItem
        case EditItem
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifierForSegue(for: segue) {
            
        case .ShowItemDetails:
            
            guard let navigationController = segue.destination as?
                UINavigationController
                else {return }
            
            guard  let itemDetailViewController   = navigationController.topViewController as? ItemDetailViewController
                else {return }
            
            
            itemDetailViewController.delegate = self
             self.stateEdit = false
             itemDetailViewController.stateEdit = false
           
            itemDetailViewController.stateAdd = false
            self.stateAdd = false
            
           
            itemDetailViewController.category = category
            
            //var indx: IndexPath  = (tableViewItem.indexPathForSelectedRow)!
            //UIViewController
           // var indx: IndexPath = tableViewItem.indexPathForSelectedRow! //self.currentSelectedIndex
                // tableViewItem.indexPath(for: sender as! UITableViewCell)!
                //    self.tableItems[(tableViewItem.indexPathForSelectedRow?.row)!]
          //  print("indexPathForSelectedRow ==", indx )
            if( self.tableViewItem != nil){
                print("ok")
                
                let   indxPath_Current : IndexPath = self.tableViewItem.indexPath(for: sender as! UITableViewCell)!
                
                itemDetailViewController.indexPathSelected = indxPath_Current
                
                self.editedItemIndex = indxPath_Current
                
        
                
                if  let viewitem = sender as? CellView?{
                    print("item== ", viewitem)
                 itemDetailViewController.itemEdited = viewitem?.item //tableView.indexPath(for: sender)
                     print("ok2*")
                    // On passe la donnée via les propriétés
                }
                
                
           /*     itemDetailViewController.item =  self.tableItems[(self.tableViewItem.indexPathForSelectedRow?.row)!]
                print("ok1")
                // itemDetailViewController.item =  self.tableItems[(indx.row)]
                itemDetailViewController.indexPath = self.tableViewItem.indexPathForSelectedRow
 
             */
              print("ok2")
            }
           print("ok3")
            break
         
         //   print ("category = ", category?.name)
         //   print("indexPathForSelectedRow =",tableViewItem.indexPathForSelectedRow)
           
            
        case .AddItem:
            guard  let navigationController  = segue.destination as? UINavigationController
                else {return }
          
            guard  let itemDetailViewController   = navigationController.topViewController  as? ItemDetailViewController
                else {return }
            
         
            itemDetailViewController.delegate = self
            itemDetailViewController.category = category
            itemDetailViewController.stateEdit = false
            self.stateEdit = false
            itemDetailViewController.stateAdd = true
            self.stateAdd = true
            
            break
            
        case.EditItem:
            guard  let navigationController  = segue.destination as? UINavigationController
                else {return }
            
            guard  let itemDetailViewController   = navigationController.topViewController  as? ItemDetailViewController
                else {return }
            
            
            itemDetailViewController.delegate = self
            
            let   indxPath_Current = tableViewItem.indexPath(for: sender as! UITableViewCell)!
            let   indxPath_Current2 = tableViewItem.indexPathForSelectedRow
            
            itemDetailViewController.stateAdd = false
            self.stateAdd = false
            itemDetailViewController.stateEdit = true
            self.stateEdit = true
            
            itemDetailViewController.indexPathSelected = tableViewItem.indexPathForSelectedRow
            itemDetailViewController.itemEdited = self.tableItems[(tableViewItem.indexPathForSelectedRow?.row)!]
            
            if  let item = sender as? CellView?{
                
                itemDetailViewController.itemToEditWith = item //tableView.indexPath(for: sender)
                // On passe la donnée via les propriétés
            }
            break
          
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded")
        tableViewItem.dataSource = self
        tableViewItem.delegate = self
        
        
       //TODO navigation bar !!
        //navigationBar.
   
        tableItems = CoreDataManager.shared.fetchCoreData_fromContext(category: category!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View appeard")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ItemsViewController: UITableViewDelegate , UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // imageview for section
        let cellSection = tableView.dequeueReusableCell(withIdentifier: "HeaderIdentifier") as! HeaderCell
        
        cellSection.item = category
        //   (image: tableSections[section].image, labe!lText: tableSections[section].name)
        
    
        return cellSection
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! CellView
    
     
        cell.item = tableItems[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        configureCheckmark(for: cell, withItem: tableItems[indexPath.row])
        // Configure the cell...
        return cell
    }
    
  

    
    
    //MARK: section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableItems.count
    }
    
  
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewItem.deselectRow(at: indexPath, animated: false)
   //    performSegue(withIdentifier: "ShowItemDetails", sender: self)
        
        /* selection mark
        if let cell = tableView.cellForRow(at: indexPath){
            let item = tableItems[indexPath.row] as? ItemCore
            configureCheckmark(for: cell, withItem: item! )
            
        }
        tableView.deselectRow(at: (indexPath), animated: true)
        */
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            if(tableItems.count >= indexPath.row + 1){
                
                let _item =  tableItems[indexPath.row] as ItemCore
               
                CoreDataManager.shared.deleteItemCore_fromCategory(item: _item,category: category!)
                tableItems.remove(at: indexPath.row)
                
                tableViewItem.deleteRows(at: [indexPath], with: .automatic)
                tableViewItem.reloadData()
                
            }
        }
        if editingStyle == .insert {
            print("Inserted!")
            
            
        }
        
        
    }
    
    func addItem(item: ItemCore){
        
        tableItems.append(item)
        
        tableViewItem.beginUpdates()
        let indx = IndexPath(row: (tableItems.count - 1), section: 0) //TODO section: 1 ??
        tableViewItem.insertRows(at: [indx], with: UITableViewRowAnimation.middle)
        tableViewItem.endUpdates()
        
        tableViewItem.reloadData()
        
    }
    
    func editItem(item: ItemCore, indexPath: IndexPath){
        // tableItems.insert(<#T##newElement: ItemCore##ItemCore#>, at: <#T##Int#>)
       // tableViewItem.beginUpdates()
        tableItems[indexPath.row].checked  = item.checked
        tableItems[indexPath.row].deadline = item.deadline
        tableItems[indexPath.row].photo    = item.photo
        tableItems[indexPath.row].text     = item.text
        tableItems[indexPath.row].withCat  = item.withCat
       // tableViewItem.endUpdates()
        tableViewItem.reloadData()
    }
    
    func configureCheckmark(for cell: UITableViewCell, withItem item: ItemCore){
        if(item.checked){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
    }
}

protocol ItemsViewDelegate : UIPickerViewDelegate {
    func userAddedItem(name : String, rowIndex: Int)
    func userUpdatedItem(name : String, rowIndex: Int)
    func userDeletedItem(name : String, rowIndex: Int)
}
