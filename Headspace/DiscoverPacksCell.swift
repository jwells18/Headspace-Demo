//
//  DiscoverPacksCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol DiscoverPacksCellDelegate {
    func didPressDiscoverPacksHeaderCell()
    func didPressDiscoverPacksCell(sectionIndexPath: IndexPath?, indexPath: IndexPath)
}

class DiscoverPacksCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PacksCellDelegate{
    
    var discoverPacksCellDelgate: DiscoverPacksCellDelegate!
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
    private var featuredPack: NSManagedObject!
    private var packsDict = [String: [NSManagedObject]]()
    
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
        self.collectionView.register(PacksCell.self, forCellWithReuseIdentifier: cellIdentifier)
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
    
    func configure(featuredPack: NSManagedObject?, packsDict: [String: [NSManagedObject]]?){
        if featuredPack != nil && packsDict != nil{
            self.featuredPack = featuredPack!
            self.packsDict = packsDict!
            self.collectionView.reloadData()
        }
        else if featuredPack != nil && packsDict == nil{
            self.featuredPack = featuredPack!
            self.collectionView.reloadData()
        }
        else if featuredPack == nil && packsDict != nil{
            self.packsDict = packsDict!
            self.collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.packsDict.keys.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
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
            let headerView: HSCollectionSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier, for: indexPath as IndexPath) as! HSCollectionSectionHeader
            if indexPath.section > 0{
                var keys = Array(self.packsDict.keys)
                //TODO: Update to use priorities for sorting and only perform once
                keys = keys.sorted(by: <)
                let key = keys[indexPath.section-1]
                headerView.configure(title: key.uppercased(), subTitle: nil, centered: false)
            }
            reusableView = headerView
        }
        return reusableView!
    }

    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = collectionView.frame.width
        switch indexPath.section{
        case 0:
            return CGSize(width: cellWidth, height: cellWidth*0.7)
        default:
            return CGSize(width: cellWidth, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! DiscoverHeaderCell
            cell.configure(object: self.featuredPack)
            return cell
        case _ where indexPath.section > 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PacksCell
            cell.packsCellDelegate = self
            var keys = Array(self.packsDict.keys)
            keys = keys.sorted(by: <)
            let key = keys[indexPath.section-1]
            let packs = self.packsDict[key]
            cell.configure(packs: packs, showAdd: false)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PacksCell
            return cell
        }
    }
    
    //UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.discoverPacksCellDelgate.didPressDiscoverPacksHeaderCell()
        }
    }
    
    func didPressPacksCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        let sectionIndexPath = self.collectionView.indexPath(for: cell)
        self.discoverPacksCellDelgate.didPressDiscoverPacksCell(sectionIndexPath: sectionIndexPath, indexPath: indexPath)
    }
}
