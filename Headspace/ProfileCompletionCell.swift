//
//  ProfileCompletionCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import HMSegmentedControl
import CoreData

protocol ProfileCompletionCellDelegate {
    func relayDidPressDiscoverButton(sender: UIButton, tabTitle: String)
}

class ProfileCompletionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProfileCompletionCollectionCellDelegate{
    
    var profileCompletionCellDelegate: ProfileCompletionCellDelegate!
    private let cellIdentifier = "cell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var segmentedControl = HMSegmentedControl()
    private var profileCompletionSegmentedTitles = ["packs", "singles", "minis"]
    private var myCompletedPacks = [NSManagedObject]()
    private var myCompletedSingles = [NSManagedObject]()
    private var myCompletedMinis = [NSManagedObject]()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = HSColor.quaternary
        
        //Setup SegmentedControl
        self.setupSegmentedControl()
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupSegmentedControl(){
        let localizedSegmentedTitles = profileCompletionSegmentedTitles.map { $0.localized().uppercased()}
        segmentedControl = HMSegmentedControl(sectionTitles: localizedSegmentedTitles)
        segmentedControl.backgroundColor = HSColor.quaternary
        segmentedControl.frame = CGRect(x: 0, y: 20, width: self.frame.width, height: 60)
        segmentedControl.selectionIndicatorColor = HSColor.secondary
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionIndicatorHeight = 4
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.lightGray]
        segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: HSColor.secondary]
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(segmentedControl)
    }
    
    func setupCollectionView(){
        //Setup CollectionView
        self.collectionView.backgroundColor = HSColor.quaternary
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.bounces = false
        self.collectionView.register(ProfileCompletionCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupConstraints(){
        let viewDict = ["segmentedControl": segmentedControl, "collectionView": collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentedControl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[segmentedControl(50@750)][collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(packs: [NSManagedObject]?, singles: [NSManagedObject]?, minis: [NSManagedObject]?){
        if packs != nil{
            self.myCompletedPacks = packs!
        }
        if singles != nil{
            self.myCompletedSingles = singles!
        }
        if minis != nil{
            self.myCompletedMinis = minis!
        }
        self.collectionView.reloadData()
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileCompletionSegmentedTitles.count
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCompletionCollectionCell
        cell.profileCompletionCollectionCellDelegate = self
        switch indexPath.item{
        case 0:
            cell.configure(objects: self.myCompletedPacks, title: profileCompletionSegmentedTitles[indexPath.item])
        case 1:
            cell.configure(objects: self.myCompletedSingles, title: profileCompletionSegmentedTitles[indexPath.item])
        case 2:
            cell.configure(objects: self.myCompletedMinis, title: profileCompletionSegmentedTitles[indexPath.item])
        default:
            break
        }
        return cell
    }
    
    //CollectionViewCell Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func relayDidPressDiscoverButton(sender: UIButton, tabTitle: String) {
        self.profileCompletionCellDelegate.relayDidPressDiscoverButton(sender: sender, tabTitle: tabTitle)
    }
    
    //Segmented Control Delegate
    func segmentedControlChangedValue(segmentedControl: HMSegmentedControl){
        //Set CollectionView index to SegmentedControl index
        let indexPath = IndexPath(item: segmentedControl.selectedSegmentIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.collectionView){
            //Change SegmentedControl index to match CollectionView index
            let pageWidth = scrollView.frame.size.width;
            let page = Int(scrollView.contentOffset.x / pageWidth)
            self.segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
        }
    }
}





