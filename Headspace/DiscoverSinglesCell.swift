//
//  DiscoverSinglesCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/22/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol DiscoverSinglesCellDelegate {
    func didPressDiscoverSinglesCell(indexPath: IndexPath)
}

class DiscoverSinglesCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var discoverSinglesCellDelegate: DiscoverSinglesCellDelegate!
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
    private var featuredSingle: NSManagedObject!
    private var singlesDict = [String: [NSManagedObject]]()
    
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
        self.collectionView.register(DiscoverHeaderCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        self.collectionView.register(HSCollectionSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier)
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
    
    func configure(featuredSingle: NSManagedObject?, singlesDict: [String: [NSManagedObject]]?){
        if featuredSingle != nil && singlesDict != nil{
            self.featuredSingle = featuredSingle!
            self.singlesDict = singlesDict!
            self.collectionView.reloadData()
        }
        else if featuredSingle != nil && singlesDict == nil{
            self.featuredSingle = featuredSingle!
            self.collectionView.reloadData()
        }
        else if featuredSingle == nil && singlesDict != nil{
            self.singlesDict = singlesDict!
            self.collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.singlesDict.keys.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case _ where section > 0:
            let keys = Array(self.singlesDict.keys)
            let key = keys[section-1]
            let singles = self.singlesDict[key]
            if singles != nil{
                return singles!.count
            }
            else{
                return 0
            }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section{
        case 0:
            return 0
        default:
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        //Setup Search Results Header
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView: HSCollectionSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier, for: indexPath as IndexPath) as! HSCollectionSectionHeader
            if indexPath.section > 0{
                let keys = Array(self.singlesDict.keys)
                let key = keys[indexPath.section-1]
                headerView.configure(title: key.uppercased(), subTitle: nil, centered: true)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! DiscoverHeaderCell
            cell.configure(object: self.featuredSingle)
            return cell
        case _ where indexPath.section > 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SinglesMinisCell
            let keys = Array(self.singlesDict.keys)
            let key = keys[indexPath.section-1]
            let singles = self.singlesDict[key]
            cell.configure(singleMini: singles?[indexPath.item])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SinglesMinisCell
            return cell
        }
    }
    
    //UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.discoverSinglesCellDelegate.didPressDiscoverSinglesCell(indexPath: indexPath)
    }
}
