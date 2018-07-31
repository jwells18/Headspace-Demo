//
//  ProfileView.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import HMSegmentedControl

class ProfileView: UIView{
    
    var headerView = ProfileHeaderView()
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
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        //Setup HeaderView
        self.setupHeaderView()
        
        //Setup SegmentedControl
        self.setupSegmentedControl()
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupHeaderView(){
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerView)
    }
    
    func setupSegmentedControl(){
        segmentedControl = HMSegmentedControl(sectionTitles: profileSegmentedTitles)
        segmentedControl.backgroundColor = HSColor.quaternary
        segmentedControl.frame = CGRect(x: 0, y: 20, width: self.frame.width, height: 60)
        segmentedControl.selectionIndicatorColor = HSColor.secondary
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionIndicatorHeight = 4
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.lightGray]
        segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: HSColor.secondary]
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(segmentedControl)
    }
    
    func setupCollectionView(){
        //Setup CollectionView
        self.collectionView.backgroundColor = .white
        self.collectionView.isPagingEnabled = true
        self.collectionView.bounces = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupConstraints(){
        let viewDict = ["headerView": headerView, "segmentedControl": segmentedControl, "collectionView": collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentedControl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[headerView(100)][segmentedControl(55)][collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
