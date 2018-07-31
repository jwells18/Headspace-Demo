//
//  ProfileController.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import HMSegmentedControl
import CoreData

class ProfileController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProfileMyStatsCellDelegate, ProfileMyJourneyCellDelegate{
    
    private let myStatsCellIdentifier = "myStatsCell"
    private let myJourneyCellIdentifier = "myJourneyCell"
    private var profileView = ProfileView()
    private var currentUser: NSManagedObject!
    private var myCompletedPacks = [NSManagedObject]()
    private var myCompletedSingles = [NSManagedObject]()
    private var myCompletedMinis = [NSManagedObject]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "profile".localized()
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: HSColor.secondary], for: .normal)
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: HSColor.primary], for: .selected)
        self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5)
        self.tabBarItem.image = UIImage(named: "profile")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup View
        self.setupView()
        
        //Download Data
        self.downloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide NavigationBar
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Setup Profile View
        self.setupProfileView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    func setupProfileView(){
        self.profileView.headerView.mainButton.addTarget( self, action: #selector(self.settingsButtonPressed(sender:)), for: .touchUpInside)
        self.profileView.segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        self.profileView.collectionView.dataSource = self
        self.profileView.collectionView.delegate = self
        self.profileView.collectionView.register(ProfileMyStatsCell.self, forCellWithReuseIdentifier: myStatsCellIdentifier)
        self.profileView.collectionView.register(ProfileMyJourneyCell.self, forCellWithReuseIdentifier: myJourneyCellIdentifier)
        self.profileView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(profileView)
    }
    
    func setupConstraints(){
        let viewDict = ["profileView": profileView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[profileView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[profileView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        let usersManager = UsersManager()
        usersManager.loadCurrentUser { (currentUser) in
            self.currentUser = currentUser
            if self.currentUser != nil{
                self.profileView.headerView.configure(user: self.currentUser)
                //TODO: Add CurrentUser Data
                let packsManager = PacksManager()
                packsManager.loadPacks(packIds: []) { (myCompletedPacks) in
                    if myCompletedPacks != nil{
                        self.myCompletedPacks = myCompletedPacks!
                        self.profileView.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                    }
                }
                let singlesManager = SinglesManager()
                singlesManager.loadSingles(singleIds: []) { (myCompletedSingles) in
                    if myCompletedSingles != nil{
                        self.myCompletedSingles = myCompletedSingles!
                        self.profileView.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                    }
                }
                let minisManager = MinisManager()
                minisManager.loadMyMinis(minisIds: []) { (myCompletedMinis) in
                    if myCompletedMinis != nil{
                        self.myCompletedMinis = myCompletedMinis!
                        self.profileView.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                    }
                }
            }
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileSegmentedTitles.count
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myStatsCellIdentifier, for: indexPath) as! ProfileMyStatsCell
            cell.profileMyStatsCellDelegate = self
            cell.configure(user: currentUser, packs: myCompletedPacks, singles: myCompletedSingles, minis: myCompletedMinis)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myJourneyCellIdentifier, for: indexPath) as! ProfileMyJourneyCell
            cell.profileMyJourneyCellDelegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myStatsCellIdentifier, for: indexPath) as! ProfileMyStatsCell
            return cell
        }
    }
    
    //CollectionViewCell Delegate
    func didPressMyStatsCell(indexPath: IndexPath) {
        switch indexPath.section{
        case 3:
            //Add Buddy
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        default:
            break
        }
    }
    
    func didPressMainSubButton(sender: UIButton){
        if sender.titleLabel?.text == "meditate".localized().uppercased(){
            let tabBarController = self.tabBarController as? HSTabBarController
            tabBarController?.showDiscoverTab(segmentedIndex: 0)
        }
        else{
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        }
    }
    
    func didPressViewGoalsButton(sender: UIButton){
        let runStreakVC = RunStreakController()
        self.present(runStreakVC, animated: true, completion: nil)
    }
    
    func didPressProfileMyJourneyCell(indexPath: IndexPath){
        switch indexPath.item {
        case 0:
            let subscribeVC = SubscribeController()
            self.present(subscribeVC, animated: true)
        default:
            //Show Completed Pack, Single, or Mini View
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
            break
        }
    }
    
    func didPressDiscoverButton(sender: UIButton, tabTitle: String) {
        var selectedIndex = 0
        switch tabTitle{
        case _ where tabTitle == "packs":
            selectedIndex = 0
            break
        case _ where tabTitle == "singles":
            selectedIndex = 1
            break
        case _ where tabTitle == "minis":
            selectedIndex = 2
            break
        default:
            break
        }
        let tabBarController = self.tabBarController as? HSTabBarController
        tabBarController?.showDiscoverTab(segmentedIndex: selectedIndex)
    }

    //Segmented Control Delegate
    func segmentedControlChangedValue(segmentedControl: HMSegmentedControl){
        //Set CollectionView index to SegmentedControl index
        let indexPath = IndexPath(item: segmentedControl.selectedSegmentIndex, section: 0)
        self.profileView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.profileView.collectionView){
            //Change SegmentedControl index to match CollectionView index
            let pageWidth = scrollView.frame.size.width;
            let page = Int(scrollView.contentOffset.x / pageWidth)
            self.profileView.segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
        }
    }
    
    //Button Delegates
    func settingsButtonPressed(sender: UIButton){
        let settingsVC = SettingsController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
}

