//
//  UsersManager.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class UsersManager: NSObject{
    
    var ref: DatabaseReference!
    
    func signInAsTestUser(){
        Auth.auth().signIn(withEmail: testUserEmail, password: testUserPassword) { (user, error) in
            if(error == nil){
                //Setup PageViewController - automatically triggered by user state observer in App Delegate
            }
            else{
                //Show Error Message
                let alert = UIAlertController(title: "sorry".localized(), message: "signInError".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
            }
        }
    }
    
    func loadCurrentUser(completionHandler:@escaping (NSManagedObject?) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        let userId = Auth.auth().currentUser?.uid ?? ""
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", userId)
        do {
            let users = try managedContext.fetch(fetchRequest)
            completionHandler(users.first)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil)
        }
    }
}

extension UsersManager{
    
    func createDataObservers(){
        //Create Database Observers
        if(Auth.auth().currentUser != nil){
            if (ref == nil){
                self.createObservers()
            }
        }
    }
    
    func createObservers(){
        let userId = Auth.auth().currentUser?.uid
        ref = Database.database().reference(withPath: usersDatabase).child(userId!)
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
        //Check if user is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", rawData["objectId"] as! String)
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            if fetchResults.isEmpty{
                //Create new object
                let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
                let user = NSManagedObject(entity: entity, insertInto: managedContext)
                user.setValuesForKeys(rawData)
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
        //Check if user is already in database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
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
