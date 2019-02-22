//
//  ViewController.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
 
    
    var tableItems = [Item]()
    
    var tableItemsfiltered = [Item]()
    var shouldShowSearchResults = false
    
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
        let item = Item(_text: txt)
       // tableItems =Array<Item>(repeating: Item, count: 9)
        tableItems.append(item)
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableItems =  [Item]()
        tableItemsfiltered = [Item]()
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
      
        
        guard let searchText = searchController.searchBar.text else {
          //  self.shouldShowSearchResults = false
            return }
        print(searchText)
        //ici function de tri
        
        self.tableItemsfiltered.removeAll()
        
        for item: Int in 0..<tableItems.count {
            if tableItems[item].text.lowercased().contains(
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
        self.tableItemsfiltered = tableItems.filter({( item : Item) -> Bool in
            return item.text.lowercased().contains(searchText.lowercased())
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        //indexPath.row
        cell.textLabel?.text = shouldShowSearchResults ? tableItemsfiltered[indexPath.row].text : tableItems[indexPath.row].text
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
            item.toggleChecked()
            
            configureCheckmark(for: cell, withItem: item)
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
    
    
    func configureCheckmark(for cell: UITableViewCell, withItem item: Item){
        if(item.checked){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
    }
    
    func initTablewithItems(){
        let task1 = Item(_text: "Finir le cours d'IOS")
        let task2 = Item(_text: "Mettre à jour XCode",_checked:true)
        let task3 = Item(_text: "Ma tache perso")
        let task4 = Item(_text: "Home work Java",_checked:true)
        tableItems.append(task1)
        tableItems.append(task2)
        tableItems.append(task3)
        tableItems.append(task4)
        
        // nbItems = tableItems.count
        
    }
    
    
}

