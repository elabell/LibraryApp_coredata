//
//  ItemDetailViewController.swift
//  Check_Lists_swift
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
//UINavigationControllerDelegate
    
    
    var delegate : ItemDetailViewDelegate? = nil
   
    var category: Category? = nil
    var itemSelected: ItemCore? = nil
    var itemEdited: ItemCore? = nil
    var itemToEditWith: CellView? = nil
    var indexPathSelected: IndexPath? = nil
    
    
    var stateEdit: Bool = false
    var stateAdd: Bool = false
    
    var photo: UIImage? = nil
    var date: Date? = nil
    
    @IBOutlet var tableViewItemDetails: UITableView!
    // @IBOutlet var tableViewItemDetails: UITableView!
    //@IBOutlet var tableViewItemDetail: UITableView!
    //  @IBOutlet var tableViewItem: UITableView!
    //@IBOutlet var tableViewItem: UITableView!
    @IBOutlet weak var textEdit: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate = nil
    }
   
    
  
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    @IBAction func isDone(_ sender: UIBarButtonItem) {
        if (self.stateAdd && !((textEdit.text?.isEmpty)!)){
            itemEdited = CoreDataManager.shared.createNewItem(txt: textEdit.text!, ischecked: false, cat: category!)
            
            delegate?.userAddedItem(self, category: category!, item: itemEdited!)
        }
            
        else if(self.stateEdit){
            delegate?.userUpdatedItem(self, category: category!, item: itemEdited!, rowIndex: indexPathSelected!)
            
        }
        
    }

   
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        print("View loaded Details ")
     
   //     tableViewItem.dataSource = self
   //     tableViewItem.delegate = self
        
        if(!stateAdd && !stateEdit){
            print("ViewDEtails loaded")
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWill ItemDetail appeard")
        
        
        textEdit.becomeFirstResponder()
        /*
         if  ((textEdit.text?.isEmpty)!) {
         btnDone.isEnabled = false
         }
         */
        
        if(stateAdd){
            navigationBar.title = "Add item"
            if  ((textEdit.text?.isEmpty)!) {
                //  btnDone.isEnabled = false
            }
        }else if (stateEdit) {
            navigationBar.title = "Edit item"
            if  ((textEdit.text?.isEmpty)!) {
                btnDone.isEnabled = false
            }
        }else {
            btnDone.isEnabled = false
            var txt = itemEdited?.text
            textEdit.insertText(txt!)
            textEdit.isUserInteractionEnabled = false
            
           // textEdit.pasteDelegate?
            
            navigationBar.title = "Details of item"
        }

    }
  /*
 override func viewDidAppear(_ animated: Bool) {
        print("View ItemDetail appeard")
        
            
            textEdit.becomeFirstResponder()
        /*
          if  ((textEdit.text?.isEmpty)!) {
                btnDone.isEnabled = false
            }
        */
        
           if(stateAdd){
               navigationBar.title = "Add item"
                if  ((textEdit.text?.isEmpty)!) {
                  //  btnDone.isEnabled = false
                }
            }else if (stateEdit) {
                navigationBar.title = "Edit item"
                if  ((textEdit.text?.isEmpty)!) {
                    btnDone.isEnabled = false
                }
            }else {
                btnDone.isEnabled = false
                navigationBar.title = "Details of item"
            }

    }
 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//extension ItemDetailViewController: UITableViewDelegate , UITableViewDataSource {
    
    // MARK: - Table view data source
    
/*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
  */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.cellForRow(at: indexPath) //tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! CellView
        
        
      //  cell.item = tableItems[indexPath.row]
        
      //  configureCheckmark(for: cell, withItem: tableItems[indexPath.row])
        // Configure the cell...
        return cell!
    }
    
    
    
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //   let dataSource = dataSources[section]
        // #warning Incomplete implementation, return the number of rows
      return  1 //dataSource.tableView(tableView, numberOfRowsInSection: 0)
        
    }
    
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  /*
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
    */
        
    }
//}



protocol ItemDetailViewDelegate : UIPickerViewDelegate {
    func userAddedItem(_ controller: ItemDetailViewController, category: Category ,item: ItemCore)
    func userUpdatedItem(_ controller: ItemDetailViewController, category: Category ,item: ItemCore, rowIndex: IndexPath)
    
   
}
