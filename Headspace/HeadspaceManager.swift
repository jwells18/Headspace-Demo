//
//  HeadspaceManager.swift
//  Headspace
//
//  Created by Justin Wells on 7/28/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class HeadspaceManager: NSObject{
    
    var ref: DatabaseReference!
    
    func loadHeadspaceData(completionHandler:@escaping (NSManagedObject?) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Headspace")
        do {
            let headspace = try managedContext.fetch(fetchRequest)
            completionHandler(headspace.first)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil)
        }
    }
    
    func downloadPlans(completionHandler:@escaping ([Plan]) -> Void){
        var plans = [Plan]()
        ref = Database.database().reference().child(plansDatabase)
        var query = DatabaseQuery()
        
        query = ref.queryOrdered(byChild: "priority")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                completionHandler(plans)
                return
            }
            
            for child in snapshot.children{
                //Create Plan
                let childSnapshot = child as? DataSnapshot
                let rawData = childSnapshot?.value as! [String: Any]
                let plan = self.createPlan(rawData: rawData)
                plans.insert(plan, at: 0)
            }
            plans = plans.sorted(by: {$0.priority < $1.priority})
            completionHandler(plans)
        })
    }
    
    func createPlan(rawData: [String: Any]) -> Plan{
        let plan = Plan()
        plan.objectId = rawData["objectId"] as? String
        plan.createdAt = rawData["createdAt"] as! Double
        plan.updatedAt = rawData["updatedAt"] as! Double
        plan.name = rawData["name"] as? String
        plan.price = rawData["price"] as! Double
        plan.promotionalDetail = rawData["promotionalDetail"] as? String
        plan.period = rawData["period"] as? Int
        plan.periodName = rawData["periodName"] as? String
        plan.priority = rawData["priority"] as? Int
        
        return plan
    }
}

extension HeadspaceManager{
    
    func createDataObservers(){
        //Create Database Observers
        if(Auth.auth().currentUser != nil){
            if (ref == nil){
                self.createObservers()
            }
        }
    }
    
    func createObservers(){
        let ref = Database.database().reference(withPath: headspaceDatabase)
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! [String: Any]
            self.updateCoreData(rawData: rawData)
        })
        
        ref.observe(.childChanged, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! [String: Any]
            self.updateCoreData(rawData: rawData)
        })
        
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! [String: Any]
            self.updateCoreData(rawData: rawData)
        })
    }
    
    func updateCoreData(rawData: [String: Any]){
        //Check if headspace is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Headspace")
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            if fetchResults.isEmpty{
                //Create new object
                let entity = NSEntityDescription.entity(forEntityName: "Headspace", in: managedContext)!
                let headspace = NSManagedObject(entity: entity, insertInto: managedContext)
                headspace.setValuesForKeys(rawData)
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
        //Check if headspace is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Headspace")
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
