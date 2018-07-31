//
//  MinisManager.swift
//  Headspace
//
//  Created by Justin Wells on 7/27/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class MinisManager: NSObject{
    
    var ref: DatabaseReference!
    
    func loadMyMinis(minisIds: [String], completionHandler:@escaping ([NSManagedObject]?) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mini")
        fetchRequest.predicate = NSPredicate(format: "objectId IN %@", minisIds)
        do {
            let minis = try managedContext.fetch(fetchRequest)
            completionHandler(minis)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil)
        }
    }
    
    func loadMinis(completionHandler:@escaping ([NSManagedObject]?) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mini")
        do {
            let minis = try managedContext.fetch(fetchRequest)
            completionHandler(minis)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil)
        }
    }
}

extension MinisManager{
    
    func createDataObservers(){
        //Create Database Observers
        if(Auth.auth().currentUser != nil){
            if (ref == nil){
                self.createObservers()
            }
        }
    }
    
    func createObservers(){
        let ref = Database.database().reference(withPath: minisDatabase)
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
        //Check if mini is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mini")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", rawData["objectId"] as! String)
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            if fetchResults.isEmpty{
                //Create new object
                let entity = NSEntityDescription.entity(forEntityName: "Mini", in: managedContext)!
                let mini = NSManagedObject(entity: entity, insertInto: managedContext)
                mini.setValuesForKeys(rawData)
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
        //Check if mini is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Mini")
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
