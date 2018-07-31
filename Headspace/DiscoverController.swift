//
//  DiscoverController.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import HMSegmentedControl
import CoreData
import AVKit
import AVFoundation

class DiscoverController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DiscoverPacksCellDelegate, DiscoverSinglesCellDelegate, DiscoverMinisCellDelegate, DiscoverKidsCellDelegate, DiscoverAnimationsCellDelegate{
    
    private let cellIdentifier = "cell"
    private let packsCellIdentifier = "packsCell"
    private let singlesCellIdentifier = "singlesCell"
    private let minisCellIdentifier = "minisCell"
    private let kidsCellIdentifier = "kidsCell"
    private let animationsCellIdentifier = "animationsCell"
    var discoverView = DiscoverView()
    private var isDarkMode = false
    private var headspaceData: NSManagedObject!
    private var currentUser: NSManagedObject!
    private var featuredPack: NSManagedObject!
    private var packsDict: [String: [NSManagedObject]]!
    private var featuredSingle: NSManagedObject!
    private var singlesDict: [String: [NSManagedObject]]!
    private var minis: [NSManagedObject]!
    private var kidsSingles: [NSManagedObject]!
    private var animationsDict: [String: [NSManagedObject]]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "discover".localized()
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: HSColor.secondary], for: .normal)
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: HSColor.primary], for: .selected)
        self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5)
        self.tabBarItem.image = UIImage(named: "discover")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup View
        self.setupView()
        
        //Download Data()
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
        
        //Setup Discover View
        self.setupDiscoverView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    func setupDiscoverView(){
        self.discoverView.segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        self.discoverView.collectionView.dataSource = self
        self.discoverView.collectionView.delegate = self
        self.discoverView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.discoverView.collectionView.register(DiscoverPacksCell.self, forCellWithReuseIdentifier: packsCellIdentifier)
        self.discoverView.collectionView.register(DiscoverSinglesCell.self, forCellWithReuseIdentifier: singlesCellIdentifier)
        self.discoverView.collectionView.register(DiscoverMinisCell.self, forCellWithReuseIdentifier: minisCellIdentifier)
        self.discoverView.collectionView.register(DiscoverKidsCell.self, forCellWithReuseIdentifier: kidsCellIdentifier)
        self.discoverView.collectionView.register(DiscoverAnimationsCell.self, forCellWithReuseIdentifier: animationsCellIdentifier)
        self.discoverView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(discoverView)
    }
    
    func setupConstraints(){
        let viewDict = ["discoverView": discoverView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[discoverView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[discoverView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        let usersManager = UsersManager()
        usersManager.loadCurrentUser { (currentUser) in
            self.currentUser = currentUser
        }
        let packsManager = PacksManager()
        packsManager.loadPacks { (packsDict) in
            self.packsDict = packsDict
            self.discoverView.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        let singlesManager = SinglesManager()
        singlesManager.loadSingles { (singlesDict) in
            self.singlesDict = singlesDict
            self.discoverView.collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
        }
        let headspaceManager = HeadspaceManager()
        headspaceManager.loadHeadspaceData { (headspaceData) in
            if headspaceData != nil{
                self.headspaceData = headspaceData!
                //Load Featured Pack
                let packsFeaturedId = headspaceData!.value(forKey: "packsFeaturedId") as? String ?? ""
                let packsManager = PacksManager()
                packsManager.loadPacks(packIds: [packsFeaturedId], completionHandler: { (packs) in
                    self.featuredPack = packs?.first
                    self.discoverView.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                })
                //Load Featured Single
                let singlesFeaturedId = headspaceData!.value(forKey: "singlesFeaturedId") as? String ?? ""
                let singlesManager = SinglesManager()
                singlesManager.loadSingles(singleIds: [singlesFeaturedId], completionHandler: { (singles) in
                    self.featuredSingle = singles?.first
                    self.discoverView.collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
                })
                
            }
        }
        singlesManager.loadKidsSingles { (kidsSingles) in
            self.kidsSingles = kidsSingles
            self.discoverView.collectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
        }
        let minisManager = MinisManager()
        minisManager.loadMinis { (minis) in
            self.minis = minis
            self.discoverView.collectionView.reloadItems(at: [IndexPath(item: 3, section: 0)])
        }
        let animationsManager = AnimationsManager()
        animationsManager.loadAnimations { (animationsDict) in
            self.animationsDict = animationsDict
            self.discoverView.collectionView.reloadItems(at: [IndexPath(item: 4, section: 0)])
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverSegmentedTitles.count
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: packsCellIdentifier, for: indexPath) as! DiscoverPacksCell
            cell.discoverPacksCellDelgate = self
            cell.configure(featuredPack: self.featuredPack, packsDict: self.packsDict)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: singlesCellIdentifier, for: indexPath) as! DiscoverSinglesCell
            cell.discoverSinglesCellDelegate = self
            cell.configure(featuredSingle: self.featuredSingle, singlesDict: self.singlesDict)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: minisCellIdentifier, for: indexPath) as! DiscoverMinisCell
            cell.discoverMinisCellDelegate = self
            cell.configure(minis: self.minis)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kidsCellIdentifier, for: indexPath) as! DiscoverKidsCell
            cell.discoverKidsCellDelegate = self
            cell.configure(kidsSingles: self.kidsSingles)
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: animationsCellIdentifier, for: indexPath) as! DiscoverAnimationsCell
            cell.discoverAnimationsCellDelegate = self
            cell.configure(animationsDict: self.animationsDict)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            return cell
        }
    }
    
    //CollectionViewCell Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func didPressDiscoverPacksHeaderCell() {
        let packsIntroVC = PacksIntroController(pack: self.featuredPack)
        self.present(packsIntroVC, animated: true)
    }
    
    func didPressDiscoverPacksCell(sectionIndexPath: IndexPath?, indexPath: IndexPath) {
        if sectionIndexPath != nil{
            var keys = Array(self.packsDict.keys)
            keys = keys.sorted(by: <)
            let key = keys[sectionIndexPath!.section-1]
            let packs = self.packsDict[key]
            let pack = packs?[indexPath.item]
            let packsIntroVC = PacksIntroController(pack: pack)
            self.present(packsIntroVC, animated: true)
        }
    }
    
    func didPressDiscoverSinglesCell(indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            let singlesMinisIntroVC = SinglesMinisIntroController(singleMini: self.featuredSingle)
            self.present(singlesMinisIntroVC, animated: true)
            break
        case _ where indexPath.section > 0:
            var keys = Array(self.singlesDict.keys)
            keys = keys.sorted(by: <)
            let key = keys[indexPath.section-1]
            let singles = self.singlesDict[key]
            let single = singles?[indexPath.item]
            let singlesMinisIntroVC = SinglesMinisIntroController(singleMini: single)
            self.present(singlesMinisIntroVC, animated: true)
            break
        default:
            break
        }
        
    }
    
    func didPressDiscoverMinisCell(indexPath: IndexPath){
        let mini = self.minis[indexPath.item]
        if mini.value(forKey: "isPremium") as? NSNumber == 0{
            let singlesMinisIntroVC = SinglesMinisIntroController(singleMini: mini)
            self.present(singlesMinisIntroVC, animated: true)
        }
        else{
            let subscribeVC = SubscribeController()
            self.present(subscribeVC, animated: true)
        }
    }
    
    func didPressDiscoverKidsHeader(sender: UIButton){
        if headspaceData?.value(forKey: "kidsIntroVideo") as? String != nil{
            //Show video
            let player = AVPlayer(url: URL(string: headspaceData?.value(forKey: "kidsIntroVideo") as? String ?? "")!)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            self.present(playerVC, animated: true, completion: {
                playerVC.player?.play()
            })
        }
    }
    
    func didPressDiscoverKidsCell(indexPath: IndexPath){
        if indexPath.section > 0{
            let kidSingle = self.kidsSingles[indexPath.item]
            if kidSingle.value(forKey: "isPremium") as? NSNumber == 0{
                let singlesMinisIntroVC = SinglesMinisIntroController(singleMini: kidSingle)
                self.present(singlesMinisIntroVC, animated: true)
            }
            else{
                let subscribeVC = SubscribeController()
                self.present(subscribeVC, animated: true)
            }
        }
    }
    
    func didPressDiscoverKidsSectionHeader(sender: UIButton){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func didPressDiscoverAnimationsHeaderCell() {
        let subscribeVC = SubscribeController()
        self.present(subscribeVC, animated: true)
    }
    
    func didPressDiscoverAnimationsCell(sectionIndexPath: IndexPath?, indexPath: IndexPath) {
        if sectionIndexPath != nil{
            var keys = Array(self.animationsDict.keys)
            keys = keys.sorted(by: <)
            let key = keys[sectionIndexPath!.section-1]
            let animations = self.animationsDict[key]
            let animation = animations?[indexPath.item]
            if animation?.value(forKey: "isPremium") as? NSNumber == 0{
                //Show video
                let player = AVPlayer(url: URL(string: animation?.value(forKey: "video") as? String ?? "")!)
                let playerVC = AVPlayerViewController()
                playerVC.player = player
                self.present(playerVC, animated: true, completion: { 
                    playerVC.player?.play()
                })
            }
            else{
                let subscribeVC = SubscribeController()
                self.present(subscribeVC, animated: true)
            }
        }
    }
    
    //Segmented Control Delegate
    func segmentedControlChangedValue(segmentedControl: HMSegmentedControl){
        //Set CollectionView index to SegmentedControl index
        let indexPath = IndexPath(item: segmentedControl.selectedSegmentIndex, section: 0)
        self.discoverView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        switch segmentedControl.selectedSegmentIndex{
        case 4:
            self.adjustViewMode(darkMode: true)
            break
        default:
            self.adjustViewMode(darkMode: false)
            break
        }
    }
    
    //ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.discoverView.collectionView){
            //Change SegmentedControl index to match CollectionView index
            let pageWidth = scrollView.frame.size.width;
            let page = Int(scrollView.contentOffset.x / pageWidth)
            self.discoverView.segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
            switch self.discoverView.segmentedControl.selectedSegmentIndex{
            case 4:
                self.adjustViewMode(darkMode: true)
                break
            default:
                self.adjustViewMode(darkMode: false)
                break
            }
        }
    }
    
    //Other Functions
    func adjustViewMode(darkMode: Bool){
        switch darkMode{
        case true:
            self.discoverView.backgroundColor = HSColor.secondary
            self.discoverView.segmentedControl.backgroundColor = HSColor.secondary
            self.discoverView.segmentedControl.selectionIndicatorColor = HSColor.primary
            self.discoverView.segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.white]
            self.tabBarController?.tabBar.barTintColor = HSColor.secondary
        case false:
            self.discoverView.backgroundColor = HSColor.quaternary
            self.discoverView.segmentedControl.backgroundColor = HSColor.quaternary
            self.discoverView.segmentedControl.selectionIndicatorColor = HSColor.secondary
            self.discoverView.segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: HSColor.secondary]
            self.tabBarController?.tabBar.barTintColor = .white
        }
    }
}
