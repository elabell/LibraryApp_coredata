//
//  ViewController.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
   
    
    //TODO modifier Item on ItemCore
   // var tableItems = [Item]()
   // var tableItems = [ItemCore]()
    
 // var tableItems : [NSManagedObject] = []
    var tableItems : [ItemCore] = [] //= [ItemCore]()
    var tableItemsfiltered = [ItemCore]()
    
    var shouldShowSearchResults = false
    
    //let coreDataManager = UIApplication.shared.delegate as! CoreDataManager
    // let coreDataManager2 : CoreDataManagerDelegate
   
    
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchController = UISearchController() //(searchResultsController: nil)
    
    var textFildInput: String = ""
    @IBOutlet weak var tableView: UITableView!
    
   
    

    
    //MARK: Actions
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Doing", message: "New item?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {
        (action) in
            
                
         let firstTextField = alertController.textFields![0] as UITextField
            
            self.textFildInput = firstTextField.text ?? "0"
         
            self.loadNewData(textFildInput: firstTextField.text ?? "")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Name of Item "
           
        })
        
        self.present(alertController, animated: true, completion: nil)
      
      //  tableView.reloadData()
        
      /*  let item = Item(_text: "Item Test")
        tableItems.append(item)
        tableView.reloadData()
        */
    }
    
    func loadNewData(textFildInput: String){
        
        var txt = "Empty name"
        if (textFildInput != ""){
            txt = textFildInput
        }
        let item = ItemCore(context: self.getContext())//Item(_text: txt)
       // tableItems =Array<Item>(repeating: Item, count: 9)
        tableItems.append(item)
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableItems =  [ItemCore]()
        tableItemsfiltered = [ItemCore]()
        
        shouldShowSearchResults = false
        initTablewithItems()
        
        
        configureSearchController()
        
     //   setupConstraints()
    // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK: View SetUp
    func setupConstraints(){
       navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
       navigationBar.heightAnchor.constraint(equalToConstant:  44).isActive = true
     //  navigationBar.leftAnchor.constraint(equalToConstant:  44)
       
        //safe area 
        
    }
    

}

extension ListViewController: UITableViewDelegate , UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate {
    
    
    
   ////MARK: Functions SearchResults Bar
    func updateSearchResults(for searchController: UISearchController) {
      
        
        guard let searchText = searchController.searchBar.text,
             searchText.count > 0
        else {
          //  self.shouldShowSearchResults = false
            tableItemsfiltered = tableItems
            tableView.reloadData()
            return
        }
        
    
        print(searchText)
        //ici function de tri
        
        self.tableItemsfiltered.removeAll()
        
        for item: Int in 0..<tableItems.count {
            if tableItems[item].text!.lowercased().contains(
                searchText.lowercased()) {
                self.tableItemsfiltered.append(tableItems[item])
              shouldShowSearchResults = true
            }
     // shouldShowSearchResults = false
     // shouldShowSearchResults = true
    
    }
    tableView.reloadData()
    }
    
   
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self as UISearchBarDelegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        // Place the search bar view to the tableview headerview.
       // tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Private instance methods
    //RW
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.tableItemsfiltered = tableItems.filter({( item : ItemCore) -> Bool in
            return item.text!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
    
    
    
     //MARK: Functions tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults{
            return tableItemsfiltered.count
        }
        else{
            return tableItems.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! ListTableViewCell
        //indexPath.row
        cell.LabelItem.text = shouldShowSearchResults ? tableItemsfiltered[indexPath.row].text : tableItems[indexPath.row].text
        let item = shouldShowSearchResults ? tableItemsfiltered[indexPath.row] : tableItems[indexPath.row]
        configureCheckmark(for: cell, withItem: item)
        
        if !shouldShowSearchResults {
           tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
           //  tableItemsfiltered.reloadInputViews()
        }
        
        
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = tableItems[indexPath.row]
            
        
          //  item.toggleChecked()
            
            configureCheckmark(for: cell, withItem: item as! ItemCore)
            // tableView.reloadRows(at: [indexPath], with:  UITableView.RowAnimation.none)
            tableView.reloadRows(at: [indexPath], with:  UITableView.RowAnimation.automatic)
            
        }
        tableView.deselectRow(at: (indexPath), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            
            if(tableItems.count >= indexPath.row + 1){
                tableItems.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
       
    }
    
    
    func configureCheckmark(for cell: UITableViewCell, withItem item: ItemCore){
        if(item.checked){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
    }
    
    func initTablewithItems(){
        //let task1 = ItemCore(text : "Finir le cours d'IOS")
       // let task2 = ItemCore(text : "Mettre à jour XCode",_checked:true)
       // let task3 = ItemCore(text : "Ma tache perso")
      //  let task4 = ItemCore(text : "Home work Java",_checked:true)
        
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ItemCore" , in: context)
        
        let newtask1   = NSManagedObject(entity: entity!, insertInto: context )
        newtask1.setValue("Finir le cours d'IOS", forKey: "text")
        
        let newtask2   = NSManagedObject(entity: entity!, insertInto: context )
        newtask2.setValue("Mettre à jour XCode", forKey: "text")
        newtask2.setValue(true, forKey: "checked")
        
        let newtask3   = NSManagedObject(entity: entity!, insertInto: context )
        newtask3.setValue("Ma tache perso", forKey: "text")
        
        let newtask4   = NSManagedObject(entity: entity!, insertInto: context )
        newtask4.setValue("Home work Java", forKey: "text")
        newtask4.setValue(true, forKey: "checked")
        
        
        //TODO insert into Coredata BBD
        //Recoup of context from CoreDataManager 
        //let test = ItemCore(context: NSManagedObjectContext())
        
        tableItems.append(newtask1 as! ItemCore)
        tableItems.append(newtask3 as! ItemCore)
        tableItems.append(newtask3 as! ItemCore)
        tableItems.append(newtask4 as! ItemCore)
        
        saveData ()
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
    
    func fetchfromCoreData(){
    
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCore")
        
        //it's any sql query ?
        //request.predicate = NSPredicate(format: "text = %@","Home work Java")
        
        
        do {
          let result =  try  getContext().fetch(request)
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "text" ) as! String)
            }
            
        } catch  {
            print("Fetch Failed")
        }
        
        
    }
    
    func getContext() -> NSManagedObjectContext {
        return CoreDataManager.shared.context
    }
    
    
}

