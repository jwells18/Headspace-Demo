//
//  PacksIntroController.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData
import AVKit
import AVFoundation

class PacksIntroController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PacksIntroTechniquesCellDelegate{
    
    private let headerCellIdentifier = "headerCell"
    private let sectionHeaderCellIdentifier = "sectionHeaderCell"
    private let descriptionCellIdentifier = "descriptionCell"
    private let techniquesCellIdentifier = "techniquesCell"
    var packsIntroView = PacksIntroView()
    var packsIntroSections = ["header", "sessions".localized().uppercased(), "techniques".localized().uppercased()]
    var pack: NSManagedObject!
    var techniques: [NSManagedObject]!
    
    convenience init(pack: NSManagedObject?) {
        self.init()
        self.pack = pack
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
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
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup PacksIntro View
        self.setupPacksIntroView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupPacksIntroView(){
        self.packsIntroView.collectionView.dataSource = self
        self.packsIntroView.collectionView.delegate = self
        self.packsIntroView.collectionView.register(PacksIntroHeaderCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        self.packsIntroView.collectionView.register(HSCollectionSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier)
        self.packsIntroView.collectionView.register(PacksIntroDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellIdentifier)
        self.packsIntroView.collectionView.register(PacksIntroTechniquesCell.self, forCellWithReuseIdentifier: techniquesCellIdentifier)
        self.packsIntroView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for:.touchUpInside)
        self.packsIntroView.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for:.touchUpInside)
        self.packsIntroView.mainSubButton.addTarget(self, action: #selector(mainSubButtonPressed(sender:)), for:.touchUpInside)
        self.packsIntroView.configure(pack: self.pack)
        self.packsIntroView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(packsIntroView)
    }
    
    func setupConstraints(){
        let viewDict = ["packsIntroView": packsIntroView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[packsIntroView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[packsIntroView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        let techniquesStringArray = self.pack.value(forKey: "techniques") as? String
        let techniquesArray = techniquesStringArray?.components(separatedBy: ",")
        if techniquesArray != nil{
            let animationsManager = AnimationsManager()
            animationsManager.loadAnimations(animationIds: techniquesArray!) { (techniques) in
                if techniques != nil{
                    self.techniques = techniques!
                    self.packsIntroView.collectionView.reloadSections(IndexSet(integer: 2))
                }
            }
        }
        
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packsIntroSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 0:
            return .zero
        default:
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        //Setup Search Results Header
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView: HSCollectionSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier, for: indexPath as IndexPath) as! HSCollectionSectionHeader
            headerView.configure(title: packsIntroSections[indexPath.section], subTitle: nil, centered: true)
            headerView.titleLabel.textColor = .darkGray
            reusableView = headerView
        }
        return reusableView!
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = collectionView.frame.width
        switch indexPath.section{
        case 0:
            return CGSize(width: cellWidth, height: (cellWidth*0.7)+50)
        case 1:
            return CGSize(width: cellWidth, height: 54)
        case 2:
            return CGSize(width: cellWidth, height: 104)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! PacksIntroHeaderCell
            cell.configure(pack: self.pack)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellIdentifier, for: indexPath) as! PacksIntroDescriptionCell
            cell.configure(pack: self.pack)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: techniquesCellIdentifier, for: indexPath) as! PacksIntroTechniquesCell
            cell.packsIntroTechniquesCellDelegate = self
            cell.configure(techniques: self.techniques)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! PacksIntroHeaderCell
            return cell
        }
    }
    
    //CollectionViewCell Delegate
    func didPressPacksIntroTechniquesCell(indexPath: IndexPath){
        let technique = self.techniques[indexPath.item]
        if technique.value(forKey: "isPremium") as? NSNumber == 0{
            //Show video
            let player = AVPlayer(url: URL(string: technique.value(forKey: "video") as? String ?? "")!)
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
    
    //Button Delegates
    func cancelButtonPressed(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func mainButtonPressed(sender: UIButton){
        if pack.value(forKey: "isPremium") as? NSNumber == 0{
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
            /*
            let playerVC = HSPlayerController(object: pack)
            let navVC = UINavigationController(rootViewController: playerVC)
            self.present(navVC, animated: true)*/
        }
        else{
            let subscribeVC = SubscribeController()
            self.present(subscribeVC, animated: true)
        }
    }
    
    func mainSubButtonPressed(sender: UIButton){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
}
