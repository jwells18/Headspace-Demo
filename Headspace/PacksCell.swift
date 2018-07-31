//
//  PacksCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol PacksCellDelegate {
    func didPressPacksCell(cell: UICollectionViewCell, indexPath: IndexPath)
}

class PacksCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var packsCellDelegate: PacksCellDelegate!
    private let cellIdentifier = "cell"
    private let addCellIdentifier = "addCell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30)
        layout.scrollDirection = .horizontal
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var packs = [NSManagedObject]()
    var showAddPack = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor = .white
        self.clipsToBounds = false
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCollectionView(){
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(PacksCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.register(PacksAddCollectionCell.self, forCellWithReuseIdentifier: addCellIdentifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupConstraints(){
        let viewDict = ["collectionView": collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(packs: [NSManagedObject]?, showAdd: Bool){
        if packs != nil{
            self.packs = packs!
            self.showAddPack = showAdd
            self.collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.showAddPack{
        case true:
            return self.packs.count+1
        case false:
            return self.packs.count
        }
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.height*0.75, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch showAddPack{
        case true:
            switch indexPath.item{
            case _ where indexPath.item < self.packs.count:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PacksCollectionCell
                cell.configure(pack: packs[indexPath.item])
                return cell
            case _ where indexPath.item == self.packs.count:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addCellIdentifier, for: indexPath) as! PacksAddCollectionCell
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addCellIdentifier, for: indexPath) as! PacksAddCollectionCell
                return cell
            }
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PacksCollectionCell
            cell.configure(pack: packs[indexPath.item])
            return cell
        }
    }
    
    //CollectionViewCell Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.packsCellDelegate.didPressPacksCell(cell: self, indexPath: indexPath)
    }
}
