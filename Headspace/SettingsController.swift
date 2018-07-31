//
//  SettingsController.swift
//  Headspace
//
//  Created by Justin Wells on 7/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class SettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private let defaultCellIdentifier = "defaultCell"
    private let infoCellIdentifier = "infoCell"
    var settingsView = SettingsView()
    var settingsTitles = ["notifications".localized(), "downloads".localized(), "obstacles".localized(), "support".localized(), "termsAndConditions".localized(), "privacyPolicy".localized()]
    var currentUser: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Navigation Bar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
        
        //Download Data
        self.downloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide NavigationBar
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupNavigationBar(){
        //Setup Navigation Items
        self.navigationItem.title = "settings".localized().uppercased()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: self, action: #selector(backButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup Settings View
        self.setupSettingsView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    func setupSettingsView(){
        self.settingsView.tableView.dataSource = self
        self.settingsView.tableView.delegate = self
        self.settingsView.tableViewFooter.mainButton.addTarget(self, action: #selector(logoutButtonPressed(sender:)), for: .touchUpInside)
        self.settingsView.tableView.register(SettingsCell.self, forCellReuseIdentifier: defaultCellIdentifier)
        self.settingsView.tableView.register(SettingsInfoCell.self, forCellReuseIdentifier: infoCellIdentifier)
        self.settingsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(settingsView)
    }
    
    func setupConstraints(){
        let viewDict = ["settingsView": settingsView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[settingsView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[settingsView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        let usersManager = UsersManager()
        usersManager.loadCurrentUser { (currentUser) in
            self.currentUser = currentUser
            self.settingsView.tableView.reloadData()
        }
    }
    
    //TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTitles.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case _ where indexPath.row == settingsTitles.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! SettingsInfoCell
            cell.configure(user: self.currentUser)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath) as! SettingsCell
            cell.configure(title: settingsTitles[indexPath.row])
            return cell
        }
    }
    
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    //Button Delegates
    func backButtonPressed(sender: UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func logoutButtonPressed(sender: UIButton){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
}
