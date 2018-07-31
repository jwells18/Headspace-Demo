//
//  AppDelegate.swift
//  Headspace
//
//  Created by Justin Wells on 7/20/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = Reachability()!
    var reachabilityView = HSReachabilityView()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Setup Firebase
        FirebaseApp.configure()
        
        //Set Launch Controller
        let blankVC = UIViewController()
        blankVC.view.backgroundColor = .white
        self.setInitialController(viewController: blankVC)
        
        //Setup Employee State Observer
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                //Setup Data Observers
                self.setupDataObservers()
                
                //User is signed in. Set Initial View Controller
                // Set Initial View Controller
                self.setInitialController(viewController: self.setupInitialController())
            }
            else{
                //User is not signed in.
                //For demo purposes, user will be signed in with a test account. In production, it would go to a welcome screen.
                let usersManager = UsersManager()
                usersManager.signInAsTestUser()
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //Stop listening for Reachability
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Start listening for Reachability
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK - Setup Initial Controller
    func setupInitialController() -> UIViewController{
        //Setup NavigationControllers for each tab
        let homeVC = HomeController()
        let homeNavVC = HSNavigationController.init(rootViewController: homeVC)
        
        let discoverVC = DiscoverController()
        let discoverNavVC = HSNavigationController.init(rootViewController: discoverVC)
        
        let profileVC = ProfileController()
        let profileNavVC = HSNavigationController.init(rootViewController: profileVC)
        
        //Setup TabBarController
        let tabVC = HSTabBarController()
        tabVC.viewControllers = [homeNavVC, discoverNavVC, profileNavVC]
        
        return tabVC
    }
    
    func setInitialController(viewController: UIViewController){
        //Set TabBarController as Window
        window?.rootViewController = viewController
        
        //Setup ReachabilityView
        self.reachabilityView.frame = CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: 64)
        self.window?.addSubview(self.reachabilityView)
    }
    
    func setupDataObservers(){
        //Setup Data Observers
        let usersManager = UsersManager()
        usersManager.createDataObservers()
        let headspaceManager = HeadspaceManager()
        headspaceManager.createObservers()
        let packsManager = PacksManager()
        packsManager.createDataObservers()
        let singlesManager = SinglesManager()
        singlesManager.createDataObservers()
        let minisManager = MinisManager()
        minisManager.createDataObservers()
        let animationsManager = AnimationsManager()
        animationsManager.createDataObservers()
    }
    
    //Reachability
    func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            //Show notification that network is not reachable
            UIView.animate(withDuration: 0.3, animations: {
                self.reachabilityView.frame.origin.y = 0
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.3, delay: 3.0, options: UIViewAnimationOptions.init(rawValue: 0), animations: { 
                    self.reachabilityView.frame.origin.y = -64
                }, completion: nil)
            })
        }
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Headspace")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

