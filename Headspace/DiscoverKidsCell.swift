//
//  DiscoverKidsCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/22/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol DiscoverKidsCellDelegate {
    func didPressDiscoverKidsHeader(sender: UIButton)
    func didPressDiscoverKidsSectionHeader(sender: UIButton)
    func didPressDiscoverKidsCell(indexPath: IndexPath)
}

class DiscoverKidsCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DiscoverHeaderCellDelegate{
    
    var discoverKidsCellDelegate: DiscoverKidsCellDelegate!
    private let headerCellIdentifier = "headerCell"
    private let sectionHeaderCellIdentifier = "sectionHeaderCell"
    private let cellIdentifier = "cell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var ageSections = ["ages5AndUnder".localized().uppercased(), "ages6to8".localized().uppercased(), "ages9to12".localized().uppercased()]
    private var kidsSingles = [NSManagedObject]()
    
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
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCollectionView(){
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(DiscoverKidsHeaderCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        self.collectionView.register(DiscoverKidsSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier)
        self.collectionView.register(SinglesMinisCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupConstraints(){
        let viewDict = ["collectionView": self.collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(kidsSingles: [NSManagedObject]?){
        if kidsSingles != nil{
            self.kidsSingles = kidsSingles!
            self.collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if kidsSingles.count > 0{
            return 2
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case _ where section > 0:
            return kidsSingles.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 0:
            return .zero
        default:
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        //Setup Search Results Header
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView: DiscoverKidsSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier, for: indexPath as IndexPath) as! DiscoverKidsSectionHeader
            if indexPath.section > 0{
                headerView.configure(title: ageSections[indexPath.section-1])
                headerView.mainButton.addTarget(self, action: #selector(self.headerMainButtonPressed), for: .touchUpInside)
            }
            reusableView = headerView
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section{
        case 0:
            return .zero
        default:
            return UIEdgeInsetsMake(0, 30, 0, 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section{
        case 0:
            return 0
        default:
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section{
        case 0:
            return 0
        default:
            return 30
        }
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        switch indexPath.section{
        case 0:
            let cellWidth = collectionView.frame.width
            return CGSize(width: cellWidth, height: cellWidth*0.7)
        default:
            let cellWidth = (collectionView.frame.width-90)/2
            return CGSize(width: cellWidth, height: cellWidth+60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! DiscoverKidsHeaderCell
            cell.discoverHeaderCellDelegate = self
            return cell
        case _ where indexPath.section > 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SinglesMinisCell
            cell.configure(singleMini: self.kidsSingles[indexPath.item])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SinglesMinisCell
            return cell
        }
    }
    
    //UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.discoverKidsCellDelegate.didPressDiscoverKidsCell(indexPath: indexPath)
    }
    
    //Button Delegates
    func headerMainButtonPressed(sender: UIButton){
        self.discoverKidsCellDelegate.didPressDiscoverKidsSectionHeader(sender: sender)
    }
    
    func didPressDiscoverHeaderButton(sender: UIButton) {
        self.discoverKidsCellDelegate.didPressDiscoverKidsHeader(sender: sender)
    }
}

