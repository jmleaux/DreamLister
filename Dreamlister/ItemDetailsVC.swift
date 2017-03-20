//
//  ItemDetailsVC.swift
//  Dreamlister
//
//  Created by J. M. Lowe on 3/1/17.
//  Copyright © 2017 JMLeaux LLC. All rights reserved.
//

import UIKit
import CoreData




class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker:UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?   //optional because we won't ALWAYS edit when we enter this view
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem
        {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        generateStores()
        
//        generateItemTypes()

        getStores()
        
        getItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let store = stores[row]
            return store.name
        } else {
            let itemType = itemTypes[row]
            return itemType.type
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        } else {
            return itemTypes.count
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
        }
    }
    
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        if itemToEdit == nil {
            item = Item(context: context)
            
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture

        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
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
            priceField.text = "\(item.price)"
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
