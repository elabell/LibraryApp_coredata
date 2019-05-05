//
//  ViewController.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData
import Photos

class ListViewController: UIViewController, UINavigationControllerDelegate ,SegueHandlerType, CategoriesViewDelegate{
   
    // Le retour de CategoriesViewDelegate
    func userAddedCategory(name: String, rowIndex: Int) {
       //
        print("Added Cat")
    }
    
    func userUpdatedCategory(name: String, rowIndex: Int) {
       // <#code#>
        print("Updated Cat")
    }
    
    func userDeletedCategory(name: String, rowIndex: Int) {
       // <#code#>
        print("Deleted Cat")
    }
    
    var searchedText: String? = nil
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var btnShowCategory: UIBarButtonItem!
  
    enum SegueIdentifier: String {
        case ShowCategories
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifierForSegue(for: segue) {
        case .ShowCategories:
            
            guard let categoriesViewController = segue.destination as? CategoriesViewController
                
                else {return }
            categoriesViewController.delegate = self
            
            break
        
        }
    }
      

    @IBOutlet weak var navigationBar: UINavigationBar!
   
    var tableSections : [Category] = []
    var tableItems : [ItemCore] = [] //= [ItemCore]()
    var tableImages: [UIImage] = []
    //let img = UIImage(named: "NAME_OF_YOUR_FILE_WITHOUT_EXTENSION")
    
    var shouldShowSearchResults = false
    

   
 
    @IBOutlet weak var searchBar: UISearchBar!
    var searchController = UISearchController() //(searchResultsController: nil)
    
     var textFildInputItem: String = ""
     var textFildInputCat: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
   
   
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {  print("success") } })
        case .restricted: print("User do not have access to photo album.")
        case .denied: print("User has denied the permission.") } }

    

    func getItemsInSection(indexSection: Int )-> [ItemCore] {
        
        
        var tableItems = [ItemCore]()
        var tableItemsfiltered = [ItemCore]()
        
        var cat = tableSections[indexSection]
        tableItems = cat.withItem?.allObjects as! [ItemCore]
    
        
        return tableItems
    }
    
    func getItemsFiltredInSection(indexSection: Int ,searchText: String )-> [ItemCore] {
    
        var tableItems = [ItemCore]()
        var tableItemsfiltered = [ItemCore]()
        
        var cat = tableSections[indexSection]
        tableItems = cat.withItem?.allObjects as! [ItemCore]
        
        for item: Int in 0..<tableItems.count {
            
            if (tableItems[item].text?.lowercased().contains(
                searchText.lowercased()))! {
                tableItemsfiltered.append(tableItems[item])
                shouldShowSearchResults = true
            }
        }
            
        return tableItemsfiltered
    }
    
    func reloadDataView(searchResult: Bool? = false){
        tableSections = CoreDataManager.shared.fetchCoreData_fromContext_Category()
        tableItems = CoreDataManager.shared.fetchCoreData_fromContext() // we don't need this  table in globals  it's just for test
        shouldShowSearchResults = searchResult!
        tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("viewDidLoad ListView")
        
        tableView.dataSource = self
        tableView.delegate = self
       
        //TODO refresh view after back action  ->updateView()
        self.navigation.backBarButtonItem = UIBarButtonItem(title: "TODO List", style: UIBarButtonItemStyle.init(rawValue: 1)!, target: nil, action: nil)
        
        
        //tableItems =  [ItemCore]()
        //tableItemsfiltered = [ItemCore]()
        
        reloadDataView()
       
        configureSearchController()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear ListView")
      //reinit of data
       reloadDataView()
    
    }
    //MARK: View SetUp
    func setupConstraints(){
       navigationBar.translatesAutoresizingMaskIntoConstraints = false
       navigationBar.heightAnchor.constraint(equalToConstant:  44).isActive = true
     //  navigationBar.leftAnchor.constraint(equalToConstant:  44)
        //safe area
    }
}

//=====================================================//
extension ListViewController: UITableViewDelegate , UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate {
    
    
    
   ////MARK: Functions SearchResults Bar
    func updateSearchResults(for searchController: UISearchController) {
      
        self.searchedText = searchController.searchBar.text
        guard let searchText = searchController.searchBar.text,
             searchText.count > 0
        else {
         
            reloadDataView(searchResult: false)
            return
        }
        
        print(searchText)
        //ici function de tri
        
         reloadDataView(searchResult: true)
        
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
    
    // MARK: - Private instance methods UISearchBarDelegate
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
   
    
    //MARK: section
    func numberOfSections(in tableView: UITableView) -> Int {
           print("tableSections count=", tableSections.count)
        
        return tableSections.count
    }
    
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let cellSection = tableView.dequeueReusableCell(withIdentifier: "HeaderIdentifier") as! HeaderCell
   
    cellSection.item = tableSections[section]
    //   (image: tableSections[section].image, labe!lText: tableSections[section].name)
   
   return cellSection
    
    }
  
 
 func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 35
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }

    
     //MARK: Functions tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
   
       //TODO to correct
        if shouldShowSearchResults{
            
            var tableItemsfiltered = self.getItemsFiltredInSection(indexSection: section ,searchText: self.searchedText!)
            return tableItemsfiltered.count
            
        }
        else{
            print("section=", section)
            let _countItems  = tableSections[section].withItem?.count
            return _countItems! //tableItems.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        print("----> indexPath: ", indexPath, " row: ",indexPath.row, " section: ", indexPath.section)
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! CellView
    
        print("--> cell: ",cell)
  
        var tableItemsfiltered = [ItemCore]()
        if(!searchBarIsEmpty()){
            tableItemsfiltered = self.getItemsFiltredInSection(indexSection: indexPath.section, searchText: self.searchedText!)}
      
        let item = shouldShowSearchResults ? tableItemsfiltered[indexPath.row] as? ItemCore
            : tableSections[indexPath.section].withItem?.allObjects[indexPath.row] as? ItemCore
        
        
        cell.item = item
         cell.accessoryType = UITableViewCellAccessoryType.checkmark
        configureCheckmark(for: cell, withItem: item!)
      
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("----> ROW Selected indexPath: ", indexPath, " row: ",indexPath.row, " section: ", indexPath.section)
        
        if let cell = tableView.cellForRow(at: indexPath){
     
            var tableItemsfiltered = [ItemCore]()
            if(!searchBarIsEmpty()){
                tableItemsfiltered = self.getItemsFiltredInSection(indexSection: indexPath.section, searchText: self.searchedText!)}
     
            let item = shouldShowSearchResults ? tableItemsfiltered[indexPath.row] as? ItemCore
                : tableSections[indexPath.section].withItem?.allObjects[indexPath.row] as? ItemCore
          
            configureCheckmark(for: cell, withItem: item! )
            
        }
        tableView.deselectRow(at: (indexPath), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            
           var testcount = tableItems.count
            print("*===> testcount=", testcount)
            var items: [ItemCore] = tableSections[indexPath.section].withItem?.allObjects as! [ItemCore]
            
            var itemsCount = tableSections[indexPath.section].withItem?.count
            print("*===> itemsCount =", itemsCount)
            var itemsCount2 = items.count
            print("*===> itemsCount2 =", itemsCount2)
           // if(tableItems.count >= indexPath.row + 1){
  
            
            
            if (itemsCount! >= indexPath.row + 1 ){
            
                var tableItemsfiltered = [ItemCore]()
                if(!searchBarIsEmpty()){
                    tableItemsfiltered = self.getItemsFiltredInSection(indexSection: indexPath.section, searchText: self.searchedText!)}
                
                let item = shouldShowSearchResults ? tableItemsfiltered[indexPath.row] as? ItemCore
                    : tableSections[indexPath.section].withItem?.allObjects[indexPath.row] as? ItemCore
                
                // let _item =  tableSections[indexPath.section].withItem?.allObjects[indexPath.row] as? ItemCore
                
        
                CoreDataManager.shared.deleteItemCore_fromCategory(item: item!, category: tableSections[indexPath.section])
               
              //TODO test  tableItems.remove(at: indexPath.row)
                
               
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
           
        }
        if editingStyle == .insert {
            print("Inserted!")
          
            
       
            
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
    
    
}

