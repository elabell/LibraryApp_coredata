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
   
 // var tableItems : [NSManagedObject] = []
    var tableSections : [Category] = []
   
    var sectionData: [Int: [ItemCore]] = [:]
    
    var sectionDatafiltered: [Int: [ItemCore]] = [:]
    
    var tableItems : [ItemCore] = [] //= [ItemCore]()
    var tableItemsfiltered = [ItemCore]()
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

    
    
    
  
    // Mark: initItemsInSection
    
    func initItemsInSection() {
        // fetch  data from context  to one table Itemcore
        // what to do in case of many tables  , is separete context for every table-> NO => we recup entity from chaque table from context , different request depends of entity
        
        
        //init of sections and their rows
        var counter : Int = 0
        for section in tableSections {
            counter = tableSections.index(of: section)!
            
            sectionData[counter] = tableItems
            //  sectionData.updateValue(tableItems, forKey: counter)
        }
        
        counter = 0
        for section in tableSections {
            counter = tableSections.index(of: section)! //counter + 1
            
            sectionDatafiltered[counter] = tableItemsfiltered
            //  sectionData.updateValue(tableItems, forKey: counter)
        }
    }
    
    func updateItemsInSection(index:Int ) {
        // fetch  data from context  to one table Itemcore
        // what to do in case of many tables  , is separete context for every table-> NO => we recup entity from chaque table from context , different request depends of entity
        
      
            
            sectionData[index] = tableItems
            //  sectionData.updateValue(tableItems, forKey: counter)
     
            sectionDatafiltered[index] = tableItemsfiltered
            //  sectionData.updateValue(tableItems, forKey: counter)
    
    }
    
    func reloadDataView(){
        tableSections = CoreDataManager.shared.fetchCoreData_fromContext_Category()
        tableItems = CoreDataManager.shared.fetchCoreData_fromContext()
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("viewDidLoad ListView")
        
        tableView.dataSource = self
        tableView.delegate = self
       
        //TODO refresh view after back action  ->updateView()
        self.navigation.backBarButtonItem = UIBarButtonItem(title: "TODO List", style: UIBarButtonItemStyle.init(rawValue: 1)!, target: nil, action: nil)
        
        
        tableItems =  [ItemCore]()
        tableItemsfiltered = [ItemCore]()
        
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
      
        
        guard let searchText = searchController.searchBar.text,
             searchText.count > 0
        else {
          //  self.shouldShowSearchResults = false
            tableItemsfiltered = tableItems
            //sectionDatafiltered = tableSections
           
            tableView.reloadData()
            return
        }
        
    
        print(searchText)
        //ici function de tri
        
        //reinit of tables filtred
        self.tableItemsfiltered.removeAll()
       
        var copyDatafiltered = sectionDatafiltered
        
      /*
       for section in copyDatafiltered {
          //  var tabl: [ItemCore] =  sectionDatafiltered[section.key]!
          sectionDatafiltered.updateValue(self.tableItemsfiltered, forKey: section.key)
            
        }
       */
        for item: Int in 0..<tableItems.count {
            if (tableItems[item].text?.lowercased().contains(
                searchText.lowercased()))! {
                self.tableItemsfiltered.append(tableItems[item])
              shouldShowSearchResults = true
            }
            
         /*   for section in copyDatafiltered {
                //  var tabl: [ItemCore] =  sectionDatafiltered[section.key]!
                sectionDatafiltered.updateValue(self.tableItemsfiltered, forKey: section.key)
                
            }
        */
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
       //TODO to verify on the level of sections
      
      
      //var copyData = sectionData
      
        var copyData = tableSections
        
        for section in copyData {
            var table: [ItemCore] = section.withItem?.allObjects as! [ItemCore]
            
                self.tableItemsfiltered = table.filter({( item : ItemCore) -> Bool in return item.text!.lowercased().contains(searchText.lowercased()) })
                
            /* self.tableItemsfiltered =     = tableItems.filter({( item : ItemCore) -> Bool in return item.text!.lowercased().contains(searchText.lowercased()) })
           */
 }
     
        /*
         self.tableItemsfiltered = tableItems.filter({( item : ItemCore) -> Bool in
            return item.text!.lowercased().contains(searchText.lowercased())
        })
        */
        tableView.reloadData()
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
             print("items filtr count=", tableItemsfiltered.count)
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
  
    
        
        let item = shouldShowSearchResults ? sectionDatafiltered[indexPath.section]![indexPath.row] as? ItemCore : tableSections[indexPath.section].withItem?.allObjects[indexPath.row] as? ItemCore
        
        
        
        cell.item = item
        
        
         print("-->shouldShowSearchResults : ",shouldShowSearchResults)
      //   print("-->Text:",cell.LabelItem?.text)
        // print("-->textCellcountdata: ",sectionData[indexPath.section]!)
         //print("-->textCell: ",sectionData[indexPath.section]![indexPath.row].value(forKey: "text") )
      
        print("!!! test1-->")
    
        
        configureCheckmark(for: cell, withItem: item!)
      
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("----> ROW Selected indexPath: ", indexPath, " row: ",indexPath.row, " section: ", indexPath.section)
        
        if let cell = tableView.cellForRow(at: indexPath){
           //let item = tableItems[indexPath.row]
            //TODO to correct item indexes
        //  let item = sectionData[indexPath.section]![indexPath.row]
         let item = tableSections[indexPath.section].withItem?.allObjects[indexPath.row] as? ItemCore
          
            
            configureCheckmark(for: cell, withItem: item! )
            
        }
        tableView.deselectRow(at: (indexPath), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            
            if(tableItems.count >= indexPath.row + 1){
  
              let _item =  tableSections[indexPath.section].withItem?.allObjects[indexPath.row] as? ItemCore
             
                print("count1 =", tableSections[indexPath.section].withItem?.allObjects.count)
                
                CoreDataManager.shared.deleteItemCore_fromCategory(item: _item!, category: tableSections[indexPath.section])
               
                tableItems.remove(at: indexPath.row)
                
               print("count2 =", tableSections[indexPath.section].withItem?.allObjects.count)
                
               // tableSections[indexPath.section].withItem?.allObjects.remove(at:indexPath.row)
                //sectionData[indexPath.section]!.remove(at: indexPath.row)
               
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

