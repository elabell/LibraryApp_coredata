//
//  CategoriesViewController.swift
//  LibraryApp_coredata
//
//  Created by EB on 20/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Photos


class CategoriesViewController: UIViewController,SegueHandlerType,ItemsViewDelegate {
    func userAddedItem(name: String, rowIndex: Int) {
       // <#code#>
    }
    
    func userUpdatedItem(name: String, rowIndex: Int) {
       // <#code#>
    }
    
    func userDeletedItem(name: String, rowIndex: Int) {
       // <#code#>
    }
    
    
    var tableSections : [Category] = []
    var sectionData: [Int: [ItemCore]] = [:]
    var tableItems : [ItemCore] = []
    var currentSelectedIndex : Int = 0
    
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    
    
  //let manager = CategoryDataManager()
    
    
    @IBAction func btnShowItems(_ sender: UIButton) {
        
            guard let cellbrut = sender.superview?.superview else {
                return
            }
            let cell: HeaderCell = cellbrut as! HeaderCell
            let indxPath: IndexPath = tableView.indexPath(for: cell)!

        performSegue(withIdentifier: "SelectItems", sender: sender) // change sender for current sender 
    }
    /*
    @IBAction func btnShowItems(_ sender: Any) {
         performSegue(withIdentifier: "SelectItems", sender: self)
    }
    */
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    // @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var tableView: UITableView!
     //MARK: addCat
     var textFildInputCat: String = ""
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
       
         let  alertController = UIAlertController(title: "Add ", message: "New Category?", preferredStyle: .alert)
         
         let okAction = UIAlertAction(title: "Ok", style: .default) {
         (action) in
        
        // let firstTextFieldItem = alertController.textFields![0] as UITextField
        // self.textFildInputItem = firstTextFieldItem.text ?? "0"
         
         let secondTextFieldCat = alertController.textFields![0] as UITextField
         self.textFildInputCat = secondTextFieldCat.text ?? "0"
         
         self.loadNewData(textFildInput: "", secondTextFieldCat: secondTextFieldCat.text ?? "")
         }
       
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
         
         
         alertController.addTextField(configurationHandler: { (textField) in
        // textField.backgroundColor   = UIColor.lightGray
         textField.placeholder = "Enter Name of Category "
         
         })
         
       
        
         alertController.addAction(okAction)
         alertController.addAction(cancelAction)
         
         self.present(alertController, animated: true, completion: nil)
        
        
    }
    //Mark: loadNewData
    func loadNewData(textFildInput: String, secondTextFieldCat: String){
        
        var txt = "Empty name"
        var txtCat = "Empty name"
        
        if (textFildInput != ""){
            txt = textFildInput
        }
        
        if (secondTextFieldCat != ""){
            txtCat = secondTextFieldCat
            
            let newCat = CoreDataManager.shared.createNewSection(txt: txtCat)
            tableSections.append(newCat)
          
            
            tableView.beginUpdates()
            let indx = IndexPath(row: (tableSections.count - 1), section: 0)
            tableView.insertRows(at: [indx], with: UITableViewRowAnimation.middle)
            tableView.endUpdates()
            
          //  tableView.reloadData() //update
            
            
        }
        /*else
        {
            showToast(message: "Please specify the cathegory")
        }
        */
        
        
    }
 
    
    var delegate : CategoriesViewDelegate? = nil
    
    enum SegueIdentifier: String {
      // case ShowCategories
        case SelectItems
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifierForSegue(for: segue) {
        case .SelectItems:
            
            guard let itemsViewController = segue.destination as? ItemsViewController
                
                else {return }
            itemsViewController.delegate = self
            //itemsViewController.category = self.tableSections[self.currentSelectedIndex]
           
            if (tableView.indexPathForSelectedRow != nil){
             itemsViewController.category = self.tableSections[(tableView.indexPathForSelectedRow?.row)!]
              }else {
              
                let deburdescr = sender.debugDescription
                guard let _sender: UIButton = sender as? UIButton else{
                    return
                }
                guard let cellbrut = _sender.superview?.superview else {
                     return
                }
                
                let cell: HeaderCell = cellbrut as! HeaderCell
                let indxPath: IndexPath = tableView.indexPath(for: cell)!
                var item = cell.item
                itemsViewController.category = self.tableSections[(indxPath.row)]
                
            }
        
            
            break
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded")
        tableView.dataSource = self
        tableView.delegate = self
        self.navigation.backBarButtonItem = UIBarButtonItem(title: "Categories", style: UIBarButtonItemStyle.bordered, target: nil, action: nil)
        
        tableSections = CoreDataManager.shared.fetchCoreData_fromContext_Category()
        tableItems = CoreDataManager.shared.fetchCoreData_fromContext()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View appeard")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
}
extension CategoriesViewController : UITableViewDelegate , UITableViewDataSource {
    
    // MARK: - Table view data source
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return manager.numberOfItems()  =>TODO ici we do check from manager , request coredata directly
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderIdentifier", for: indexPath) as? HeaderCell else { return UITableViewCell()}
       // let category: Category = manager.categoryItem(at: indexPath)
       // cell.HeaderImage.image = category.image //add Cast
      //  cell.HeaderLabel.text = category.name
        
         cell.item = tableSections[indexPath.row]
        // Configure the cell...
        return cell
        
        
        
 
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //TODO test
        currentSelectedIndex = indexPath.row
        print( "currentSelectedIndex =", indexPath.row)
   //      performSegue(withIdentifier: "SelectItems", sender: self)
    
  
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            if(tableSections.count >= indexPath.row + 1){
                
                let category =  tableSections[indexPath.row] as Category
                
                
                var ret: Bool = CoreDataManager.shared.deleteCategoryIfHasNoItems(category: category)
                if (ret){
                    tableSections.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
             
                    tableView.reloadData()
                }else {
                    
                    showToast(message : "This Category was not deleted as contain  items ")
                    
                }
               
                
            }
        }
        
        
        
    }
    
 
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/4 - 75, y: self.view.frame.size.height-100, width: 300, height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 6.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 2
        toastLabel.adjustsFontSizeToFitWidth = true
         toastLabel.isHighlighted = true
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}


protocol CategoriesViewDelegate : UIPickerViewDelegate {
    func userAddedCategory(name : String, rowIndex: Int)
    func userUpdatedCategory(name : String, rowIndex: Int)
    func userDeletedCategory(name : String, rowIndex: Int)
}
