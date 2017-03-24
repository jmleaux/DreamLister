//
//  ItemDetailsVC.swift
//  Dreamlister
//
//  Created by J. M. Lowe on 3/1/17.
//  Copyright © 2017 JMLeaux LLC. All rights reserved.
//

import UIKit
import CoreData


extension String {
    struct xNumberFormatter {
        static let instance = NumberFormatter()
    }

    func removeFormatAmount() -> Double {
        
            let formatter = NumberFormatter()
        
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            formatter.decimalSeparator = ","
        
            return formatter.number(from: self) as Double? ?? 0
    }
    var doubleValue:Double? {
        return xNumberFormatter.instance.number(from: self)?.doubleValue
    }
}

func formatCurrency(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2;
    formatter.locale = Locale(identifier: Locale.current.identifier)
    let result = formatter.string(from: value as NSNumber);
    return result!;
}

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker:UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()          //an array to place all the stores we have saved in CoreData
    var itemTypes = [ItemType]()    //an array to place all the ItemTypes we have saved in CoreData
    
    var itemToEdit: Item?           //optional because we won't ALWAYS edit when we enter this view
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        if let topItem = self.navigationController?.navigationBar.topItem
        {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        getStores()                 //load the Stores from CoreData
        if stores.count == 0 {      //if there are no stores in CoreData...
            generateStores()        //...add some
            getStores()             //...then go load them
        }
        
        getItemTypes()              //load the ItemTypes from CoreData
        if itemTypes.count == 0 {   //if there are no item types in CoreData...
            generateItemTypes()     //...add some
            getItemTypes()          //...then go load them
        }
        
        if itemToEdit != nil {
            loadItemData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {                 //if this is the first column
            let store = stores[row]         //set store variable to the value in the array
            return store.name               //return the name of the store
        } else {
            let itemType = itemTypes[row]   //since component != 0, this must be the second column;
                                            //set itemtype variableto the value in the array
            return itemType.type            //return the name of the ItemType
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count     //if this is the first column, return number of stores
        } else {
            return itemTypes.count  //if this is the second column, return number of ItemTypes
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2    //THIS is where we define there will be TWO columns in the pickerview!
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            stores = stores.sorted(by: { (first: Store, second: Store) -> Bool in first.name! < second.name! })
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
        }
    }
    
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            itemTypes = itemTypes.sorted(by: {(first: ItemType, second: ItemType) -> Bool in first.type! < second.type! })
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        if itemToEdit == nil {                  //if no item was selected to edit from the list (they hit '+' button)
            item = Item(context: context)       //then set the item variable to THIS screen contents
        } else {
            item = itemToEdit                   //otherwise set the item variable to what was selected from the list
        }
        
        item.toImage = picture

        if let title = titleField.text {
            item.title = title                  //if item title is valid string, use it
        }
        
        if let price = priceField.text {                        //if price field exists
            if (price.doubleValue != nil) {                     //if it is already a valid Double value
                item.price = (price as NSString).doubleValue    //store it
            } else {
                item.price = price.removeFormatAmount()         //otherwise strip the formatting (produces Double)
                                                                //and store it
            }
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }

    
    func generateStores() {
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Amazon"
        let store4 = Store(context: context)
        store4.name = "Fry's Electronics"
        let store5 = Store(context: context)
        store5.name = "Target"
        let store6 = Store(context: context)
        store6.name = "Wal Mart"
        let store7 = Store(context: context)
        store7.name = "Apple Store"
        
        ad.saveContext()

    }
    
    func generateItemTypes() {
        let itype = ItemType(context: context)
        itype.type = "Electronics"
        let itype2 = ItemType(context: context)
        itype2.type = "Automobiles"
        let itype3 = ItemType(context: context)
        itype3.type = "Art"
        let itype4 = ItemType(context: context)
        itype4.type = "Clothing"
        let itype5 = ItemType(context: context)
        itype5.type = "Books"
        let itype6 = ItemType(context: context)
        itype6.type = "Music"
        let itype7 = ItemType(context: context)
        itype7.type = "Movies"
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
//            priceField.text = "\(item.price)"
            priceField.text =  formatCurrency(value: item.price)
            detailsField.text = item.details
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index+=1
                } while (index < stores.count)
            }
            
            if let iType = item.toItemType {
                var index = 0
                repeat {
                    let i = itemTypes[index]
                    if i.type == iType.type {
                        storePicker.selectRow(index, inComponent: 1, animated:true)
                        break
                    }
                    index+=1
                } while (index < itemTypes.count)
            }
        }
    }

    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
 
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
