//
//  HomeController.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HomeHeaderCellDelegate, HomeEveryayHeadspaceCellDelegate, HomeMinisCellDelegate, PacksCellDelegate, HomeFooterCellDelegate{
    
    private let headerCellIdentifier = "headerCell"
    private let sectionHeaderCellIdentifier = "sectionHeaderCell"
    private let everydayCellIdentifier = "everydayCell"
    private let minisCellIdentifier = "minisCell"
    private let packsCellIdentifier = "packsCell"
    private let singlesCellIdentifier = "singlesCell"
    private let peopleCellIdentifier = "peopleCell"
    private let footerCellIdentifier = "footerCell"
    private var homeView = HomeView()
    private var homeSections = ["", "everydayHeadspace".localized().uppercased(), "minis".localized().uppercased(), "myPacks".localized().uppercased(), "recentSingles".localized().uppercased(), "peopleGettingHeadspace".localized().uppercased(), ""]
    private var currentUser: NSManagedObject!
    private var headspaceData: NSManagedObject!
    private var everydayHeadspaceSingle: NSManagedObject!
    private var minis: [NSManagedObject]!
    private var myPacks: [NSManagedObject]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "home".localized()
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: HSColor.secondary], for: .normal)
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: HSColor.primary], for: .selected)
        self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5)
        self.tabBarItem.image = UIImage(named: "home")
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
        
        //Check if this is the first launch of the app. If so, create a Core Data observers after a delay to avoid mass amount of initial callbacks. Then, refresh the data and view.
        //NOTE: Core Data observers will eventually replace this algorithm, but has not been implemented yet.
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        switch hasLaunchedBefore{
        case true:
            break
        case false:
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                self.downloadData()
            })
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide NavigationBar
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Setup Home View
        self.setupHomeView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    func setupHomeView(){
        self.homeView.collectionView.dataSource = self
        self.homeView.collectionView.delegate = self
        self.homeView.collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        self.homeView.collectionView.register(HSCollectionSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier)
        self.homeView.collectionView.register(HomeEverydayHeadspaceCell.self, forCellWithReuseIdentifier: everydayCellIdentifier)
        self.homeView.collectionView.register(HomeMinisCell.self, forCellWithReuseIdentifier: minisCellIdentifier)
        self.homeView.collectionView.register(PacksCell.self, forCellWithReuseIdentifier: packsCellIdentifier)
        self.homeView.collectionView.register(HomeSinglesCell.self, forCellWithReuseIdentifier: singlesCellIdentifier)
        self.homeView.collectionView.register(HomePeopleCell.self, forCellWithReuseIdentifier: peopleCellIdentifier)
        self.homeView.collectionView.register(HomeFooterCell.self, forCellWithReuseIdentifier: footerCellIdentifier)
        self.homeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(homeView)
    }
    
    func setupConstraints(){
        let viewDict = ["homeView": homeView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[homeView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[homeView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        let headspaceManager = HeadspaceManager()
        headspaceManager.loadHeadspaceData { (headspaceData) in
            if headspaceData != nil{
                self.headspaceData = headspaceData!
                self.homeView.collectionView.reloadSections(IndexSet(integer: 5))
                //Load EverydayHeadspace Single
                let everydayHeadspaceId = headspaceData?.value(forKey: "everydayFeaturedId") as? String ?? ""
                let singlesManager = SinglesManager()
                singlesManager.loadSingles(singleIds: [everydayHeadspaceId], completionHandler: { (singles) in
                    self.everydayHeadspaceSingle = singles?.first
                    self.homeView.collectionView.reloadSections(IndexSet(integer: 1))
                })
            }
        }
        let minisManager = MinisManager()
        minisManager.loadMinis { (minis) in
            if minis != nil{
                self.minis = minis!
                self.homeView.collectionView.reloadSections(IndexSet(integer: 2))
            }
        }
        let usersManager = UsersManager()
        usersManager.loadCurrentUser { (currentUser) in
            self.currentUser = currentUser
            if currentUser != nil{
                let packsInProgressString = self.currentUser.value(forKey: "packsInProgress") as? String ?? ""
                let packsInProgress = packsInProgressString.components(separatedBy: ",")
                let packsManager = PacksManager()
                packsManager.loadPacks(packIds: packsInProgress) { (myPacks) in
                    if myPacks != nil{
                        self.myPacks = myPacks!
                        self.homeView.collectionView.reloadSections(IndexSet(integer: 0))
                        self.homeView.collectionView.reloadSections(IndexSet(integer: 3))
                    }
                }
            }
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return homeSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: Add Tips Cells
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 0:
            return .zero
        case 6:
            return CGSize(width: collectionView.frame.width, height: 30)
        default:
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        //Setup Search Results Header
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView: HSCollectionSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier, for: indexPath as IndexPath) as! HSCollectionSectionHeader
            if indexPath.section == 5{
                headerView.configure(title: homeSections[indexPath.section], subTitle: nil, centered: true)
            }
            else{
                headerView.configure(title: homeSections[indexPath.section], subTitle: nil, centered: false)
            }
            reusableView = headerView
        }
        return reusableView!
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = collectionView.frame.width
        switch indexPath.section{
        case 0:
            return CGSize(width: cellWidth, height: cellWidth*0.9)
        case 1:
            return CGSize(width: cellWidth, height: 80)
        case 2:
            return CGSize(width: cellWidth, height: 162)
        case 3:
            return CGSize(width: cellWidth, height: 200)
        case 4:
            return CGSize(width: cellWidth, height: 130)
        case 5:
            return CGSize(width: cellWidth, height: 50)
        case 6:
            return CGSize(width: cellWidth, height: cellWidth*0.9)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! HomeHeaderCell
            cell.homeHeaderCellDelegate = self
            cell.configure(pack: myPacks?.first)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: everydayCellIdentifier, for: indexPath) as! HomeEverydayHeadspaceCell
            cell.homeEverydayHeadspaceCellDelegate = self
            cell.configure(singleMini: everydayHeadspaceSingle)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: minisCellIdentifier, for: indexPath) as! HomeMinisCell
            cell.homeMinisCellDelegate = self
            cell.configure(minis: self.minis)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: packsCellIdentifier, for: indexPath) as! PacksCell
            cell.packsCellDelegate = self
            cell.configure(packs: self.myPacks, showAdd: true)
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: singlesCellIdentifier, for: indexPath) as! HomeSinglesCell
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: peopleCellIdentifier, for: indexPath) as! HomePeopleCell
            cell.configure(data: headspaceData)
            return cell
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: footerCellIdentifier, for: indexPath) as! HomeFooterCell
            cell.homeFooterCellDelegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! HomeHeaderCell
            return cell
        }
    }
    
    //CollectionViewCell Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section{
        case 4:
            let tabBarController = self.tabBarController as? HSTabBarController
            tabBarController?.showDiscoverTab(segmentedIndex: 1)
            break
        default:
            break
        }
    }
    
    func didPressBeginButton(sender: UIButton) {
        if self.myPacks != nil{
            let packsIntroVC = PacksIntroController(pack: self.myPacks?.first)
            self.present(packsIntroVC, animated: true)
        }
        else{
            let tabBarController = self.tabBarController as? HSTabBarController
            tabBarController?.showDiscoverTab(segmentedIndex: 0)
        }
    }
    
    func didPressEverydayHeadspaceButton(sender: UIButton) {
        let singlesMinisIntroVC = SinglesMinisIntroController(singleMini: self.everydayHeadspaceSingle)
        self.present(singlesMinisIntroVC, animated: true)
    }
    
    func didPressEverydayHeadspacePlayButton(sender: UIButton) {
        let singlesMinisIntroVC = SinglesMinisIntroController(singleMini: self.everydayHeadspaceSingle)
        self.present(singlesMinisIntroVC, animated: true)
    }
    
    func didPressHomeMinisCell(sectionIndexPath: IndexPath?, indexPath: IndexPath) {
        if sectionIndexPath != nil{
            let selectedIndex = (sectionIndexPath!.item*3)+indexPath.item
            let mini = self.minis[selectedIndex]
            if mini.value(forKey: "isPremium") as? NSNumber == 0{
                let singlesMinisIntroVC = SinglesMinisIntroController(singleMini: mini)
                self.present(singlesMinisIntroVC, animated: true)
            }
            else{
                let subscribeVC = SubscribeController()
                self.present(subscribeVC, animated: true)
            }
        }
    }
    
    func didPressPacksCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        if indexPath.item == self.myPacks.count{
            //Change to Discover Index
            let tabBarController = self.tabBarController as? HSTabBarController
            tabBarController?.showDiscoverTab(segmentedIndex: 0)
        }
        else if indexPath.row <= self.myPacks.count{
            let pack = myPacks[indexPath.item]
            let packsIntroVC = PacksIntroController(pack: pack)
            self.present(packsIntroVC, animated: true)
        }
    }
    
    func didPressSubscribeButton(sender: UIButton) {
        let subscribeVC = SubscribeController()
        self.present(subscribeVC, animated: true)
    }
}
