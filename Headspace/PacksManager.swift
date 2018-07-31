//
//  PacksManager.swift
//  Headspace
//
//  Created by Justin Wells on 7/27/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class PacksManager: NSObject{
    
    var ref: DatabaseReference!
    
    func loadPacks(packIds: [String], completionHandler:@escaping ([NSManagedObject]?) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pack")
        fetchRequest.predicate = NSPredicate(format: "objectId IN %@", packIds)
        do {
            let packs = try managedContext.fetch(fetchRequest)
            completionHandler(packs)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil)
        }
    }
    
    func loadPacks(completionHandler:@escaping ([String: [NSManagedObject]]?) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pack")
        do {
            let packs = try managedContext.fetch(fetchRequest)
            var packDict = [String: [NSManagedObject]]()
            for pack in packs{
                var currentDict = packDict[pack.value(forKey: "category") as! String]
                if currentDict != nil{
                    currentDict!.append(pack)
                    packDict[pack.value(forKey: "category") as! String] = currentDict
                }
                else{
                    packDict[pack.value(forKey: "category") as! String] = [pack]
                }
            }
            completionHandler(packDict)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil)
        }
    }
}

extension PacksManager{
    
    func createDataObservers(){
        //Create Database Observers
        if(Auth.auth().currentUser != nil){
            if (ref == nil){
                self.createObservers()
            }
        }
    }
    
    func createObservers(){
        let ref = Database.database().reference(withPath: packsDatabase)
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! [String: Any]
            if(rawData["updatedAt"] != nil){
                self.updateCoreData(rawData: rawData)
            }
        })
        
        ref.observe(.childChanged, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! [String: Any]
            if(rawData["updatedAt"] != nil){
                self.updateCoreData(rawData: rawData)
            }
        })
        
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! [String: Any]
            if(rawData["updatedAt"] != nil){
                self.deleteInCoreData(rawData: rawData)
            }
        })
    }
    
    func updateCoreData(rawData: [String: Any]){
        //Check if pack is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pack")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", rawData["objectId"] as! String)
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            if fetchResults.isEmpty{
                //Create new object
                let entity = NSEntityDescription.entity(forEntityName: "Pack", in: managedContext)!
                let pack = NSManagedObject(entity: entity, insertInto: managedContext)
                pack.setValuesForKeys(rawData)
            }
            else{
                //Update existing object
                fetchResults.first?.setValuesForKeys(rawData)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //Save Changes in Core Data
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteInCoreData(rawData: [String: Any]){
        //Check if pack is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pack")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", rawData["objectId"] as! String)
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            for result in fetchResults {
                managedContext.delete(result)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
