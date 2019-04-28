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
    @IBOutlet weak var textEdit: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var btnEdit: UIToolbar!
    @IBOutlet weak var btnCamera: UIToolbar!
    
    
    
    @IBOutlet weak var catEdit: UITextField!
    @IBOutlet weak var imageEdit: UIImageView!
    
    
    @IBOutlet weak var dateEdit: UITextField!
     let datePicker = UIDatePicker()
    
   /*
     @IBOutlet var datePicker: UITableView!
    
    @IBAction func onPickDate(_ sender: UIDatePicker) {
    dateEdit.text = "\(sender.date)"
    }
    */
    /*  dateEdit.text = "\(sender.date)"
 @IBAction func onPickDate(_ sender: Any) {
        dateEdit.text =  sender
    }
 */
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate = nil
    }
   
    @IBAction func EditItem(_ sender: UIBarButtonItem) {
         self.stateEdit = true
         self.stateAdd = false
          
        navigationBar.title = "Edition of item"
          textEdit.isUserInteractionEnabled = true
          dateEdit.isUserInteractionEnabled = true
          btnEdit.isUserInteractionEnabled = false
        //if  ((textEdit.text?.isEmpty)!) {
             btnDone.isEnabled = true
       // }
        
        
    }
    @IBAction func ShowCamera(_ sender: Any) {
    }
    
  
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    @IBAction func isDone(_ sender: UIBarButtonItem) {
        print("text",textEdit.text)
        
        if (self.stateAdd && !((textEdit.text?.isEmpty)!)){
            print("text",textEdit.text)
            itemEdited = CoreDataManager.shared.createNewItem(txt: textEdit.text!, ischecked: false, cat: category!)
             //----------TODO to refactor------------------------
            var dateReal = dateEdit.text
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat =
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = NSLocale.current
            //dateFormatter.dateStyle = .short
            //var myDate = myDateString.toDateTime()
            let date: NSDate? = dateFormatter.date(from: dateReal!) as! NSDate
            print("Date =" , date)
            itemEdited?.deadline = date! as Date
            //--------------------------------------------------
            
            delegate?.userAddedItem(self, category: category!, item: itemEdited!)
        }
        else if(self.stateEdit){
            print("edit item = ",textEdit.text)
            var image : UIImage? = nil
            
            image = imageEdit.image
            
            if (image != nil) {
                // let _image : UIImage =  UIImage(data:(image)!)!
                let dataimage : Data = UIImagePNGRepresentation(image!)!
                 itemEdited?.photo = dataimage
                
            }else {
                
                let _image = UIImage(named: "internet")
                let dataimage : Data = UIImagePNGRepresentation(_image!)!
                 itemEdited?.photo  = dataimage
            }
            
             //----------TODO to refactor----------------------
            var dateReal = dateEdit.text
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat =
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = NSLocale.current
            //dateFormatter.dateStyle = .short
            //var myDate = myDateString.toDateTime()
            let date: NSDate? = dateFormatter.date(from: dateReal!) as! NSDate
           
            print("Date =" , date)
            itemEdited?.deadline = date! as Date
            itemEdited?.text = textEdit.text
          //--------------------------------------------------
            
           // CoreDataManager.shared.saveData();
            
            var ret : Bool = CoreDataManager.shared.updateItemFromCategory(category: category!, itemEdited: itemEdited!)
            
            delegate?.userUpdatedItem(self, category: category!, item: itemEdited!, rowIndex: indexPathSelected!)
            
        }
        
    }

    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        if (dateEdit.text != ""){
            print("dateEdit=", dateEdit.text as Any)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = NSLocale.current
            let date: Date? = dateFormatter.date(from: dateEdit.text!)
            
            datePicker.date = date!
            
        }
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(getdatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateEdit.inputAccessoryView = toolbar
        dateEdit.inputView = datePicker
        
    }
    
    @objc func getdatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = NSLocale.current
        dateEdit.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded Details ")
        showDatePicker()
        
    //  let datePicker = UIDatePicker()
     //   datePicker.datePickerMode = UIDatePickerMode.date
     //   dateEdit.inputView = datePicker
        
       // datePicker.addTarget(self, action: #selector(tableViewItemDetails.
            //(sender:)), for: UIControlEvents.valueChanged)
        
        
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
            btnEdit.isHidden = true
            var txtcat = category?.name
            catEdit.insertText(txtcat!)
            catEdit.isUserInteractionEnabled = false
            
            if  ((textEdit.text?.isEmpty)!) {
                //  btnDone.isEnabled = false
            }
        }else if (stateEdit) {
            navigationBar.title = "Edit item"
            if  ((textEdit.text?.isEmpty)!) {
                btnDone.isEnabled = false
            }else{
                btnDone.isEnabled = true
            }
            
        }else {
            btnDone.isEnabled = false
            btnEdit.isHidden = false
            var txt = itemEdited?.text
            var txtcat = category?.name
            textEdit.insertText(txt!)
            catEdit.insertText(txtcat!)
            textEdit.isUserInteractionEnabled = false
            catEdit.isUserInteractionEnabled = false
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.locale = NSLocale.current
            if (itemEdited?.deadline != nil){
                let date = formatter.string(from: (itemEdited?.deadline)!)
               print("datesaved= ", itemEdited?.deadline)
                print("date output =", date)
                dateEdit.insertText(date)
            }
       
            
            
            dateEdit.isUserInteractionEnabled = false
            
           // textEdit.pasteDelegate?
            
            navigationBar.title = "Details of item"
        }

    }

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
