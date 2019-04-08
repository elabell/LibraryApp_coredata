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

class ListViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
      
    @IBOutlet weak var navigationBar: UINavigationBar!
   
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
    
   
    
    var photoImageView: UIImageView! = nil
    let imagePickerController = UIImagePickerController()
   // var alertController: UIAlertController! = nil
    
    //MARK: Actions
    @IBAction func addItems(_ sender: UIBarButtonItem) {
      
        let  alertController = UIAlertController(title: "Doing", message: "New item?", preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "Ok", style: .default) {
        (action) in
            
                
            let firstTextField = alertController.textFields![0] as UITextField
            
            self.textFildInput = firstTextField.text ?? "0"
         
            self.loadNewData(textFildInput: firstTextField.text ?? "")
        }
        
      
        
        
        //picker photo view
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin+10.0, width: 50, height: 30)
        
        
       photoImageView = UIImageView(frame: rect)  //UIView(frame: rect)
       // photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.backgroundColor = .red //UIImage(named: "monitor-1307227_1920")
        

        
    /*
        let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        let pickerViewSelectedValue: UIImagePickerController.Index = (column: 0, row: frameSizes.index(of: 216) ?? 0)
        
        alertController.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    vc.preferredContentSize.height = frameSizes[index.row]
                }
            }
        }
        alertController.addAction("Done")
        alertController.show(imagePickerController, sender: Any?.self)
      */
        
    //    imagePickerController.isEditing = false
        
     
       
        
        
        let libBtn = UIAlertAction(title: "Select photo" , style:.default){
            (libSelected) in print("Library Selected")
           // self.imagePickerController = UIImagePickerController()
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            // Make sure ViewController is notified when the user picks an image.
             self.photoImageView.setNeedsDisplay()
                self.checkPermission()
            self.imagePickerController.delegate = self
            //alertController.show(self.imagePickerController, sender: Any?.self)
            
        self.present(self.imagePickerController, animated: true, completion: nil)
         // self.presentedViewController?.present(self.imagePickerController, animated: true, completion: nil)
         
               print("hello")
             // self.imagePickerController.dismiss(animated: true, completion: nil)
        }
        let cameraBtn = UIAlertAction(title: "Take picture" , style:.default){
            (camSelected) in print("Camera Selected")
            
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .camera
                // Make sure ViewController is notified when the user picks an image.
                self.imagePickerController.delegate = self
                
              //  self.present(self.imagePickerController, animated: true, completion: nil)
               // alertController.dismiss(animated: true, completion: nil)
              self.present(self.imagePickerController, animated: true, completion: nil)
               print("hello")
               }
        }
        
        
        
        //================
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
      
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Name of Item "
           
        })
        alertController.view.addSubview(photoImageView)
        
        
        alertController.addAction(libBtn)
        alertController.addAction(cameraBtn)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
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
       
        // TODO have to initial context and entity in funtion or in global
       // let context2 : NSManagedObjectContext = getContext()
        //let context = self.getContext()
       // let entity = NSEntityDescription.entity(forEntityName: "ItemCore" , in: context)
        
      //  let item = ItemCore(context: self.getContext())//Item(_text: txt)
       // tableItems =Array<Item>(repeating: Item, count: 9)
        
       // let newitem   = ItemCore(entity: entity!, insertInto: context )
       // newitem.setValue(txt, forKey: "text")
  
        let newitem = CoreDataManager.shared.createNewItem(txt: txt, ischecked: true)
        tableItems.append(newitem)
        tableView.reloadData()
        
    }
    
    
    
    
      // Mark: Image picker
/* @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
       // nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
       // let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.

    imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePickerController, animated: true, completion: nil)
    }
 */
 
  @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
    }
    
  
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
      /*  picker.dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let cropController:  ViewController = CropViewController(croppingStyle: .circular, image: pickedImage)
                cropController.delegate = self
                self.present(cropController, animated: true, completion: nil)
            }
        }
 */
       dismiss(animated: true, completion: nil)
       // if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
    //    checkPermission()
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        /* if let finalImage = handleImage(originalImage: self.selectedImage!, maskImage: self.maskImage!) {
                 photoImageView.contentMode = .topLeft
                self.photoImageView.image = finalImage
            }
 */
            
           photoImageView.contentMode = .scaleAspectFit
           photoImageView.image = selectedImage
         //   myAlertView show
            
            
         print( selectedImage.debugDescription)
            
            //.imageAsset
        }
        
        viewDidLoad()
            
            
                
            //    [myAlertView show];
                
        
    
       
            //self.alertController.view.addSubview(photoImageView)
     //   alertController.beginAppearanceTransition( true, animated: true)
       // alertController.viewWillAppear(true)
        // Dismiss the picker.
     //   dismiss(animated: true, completion: nil)
        
      //  self.imagePickerController.allowsEditing = false
        // Set photoImageView to display the selected image.
        //  photoImageView.image = selectedImage
        
        
        
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {  print("success") } })
        case .restricted: print("User do not have access to photo album.")
        case .denied: print("User has denied the permission.") } }

    
    
    
  
    // Mark:
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    
        tableItems =  [ItemCore]()
        tableItemsfiltered = [ItemCore]()
        
        shouldShowSearchResults = false
        
        // here check if core data exist
    
        //    initTablewithItems()  //OK but unchecked during  tests fetchCoreData_fromContext
        
       tableItems = CoreDataManager.shared.fetchCoreData_fromContext() // fetch  data from context  to one table Itemcore
                        // what to do in case of many tables  , is separete context for every table-> NO => we recup entity from chaque table from context , different request depends of entity
        
        
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
//=====================================================//
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
    
    
    //MARK: section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
  /*  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return
    }
   */
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
        
        //old  TODO to delete ?
        cell.LabelItem?.text = shouldShowSearchResults ? tableItemsfiltered[indexPath.row].text : tableItems[indexPath.row].text
        
        //new
        cell.LabelItem?.text = shouldShowSearchResults ? tableItemsfiltered[indexPath.row].value(forKey: "text") as? String :
            tableItems[indexPath.row].value(forKey: "text") as? String
        
        
        let item = shouldShowSearchResults ? tableItemsfiltered[indexPath.row] : tableItems[indexPath.row]
        configureCheckmark(for: cell, withItem: item)
        
        if !shouldShowSearchResults {
         // tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
           //  tableItemsfiltered.reloadInputViews()
        }
        
        
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = tableItems[indexPath.row]
            
        
          //  item.toggleChecked()
            
            configureCheckmark(for: cell, withItem: item )
            // tableView.reloadRows(at: [indexPath], with:  UITableView.RowAnimation.none)
   //         tableView.reloadRows(at: [indexPath], with:  UITableViewRowAnimation.automatic)
            
        }
        tableView.deselectRow(at: (indexPath), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            
            if(tableItems.count >= indexPath.row + 1){
                
                let  _item = tableItems[indexPath.row]
                
                CoreDataManager.shared.deleteItem(item: _item)
                tableItems.remove(at: indexPath.row)
               
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
           
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

