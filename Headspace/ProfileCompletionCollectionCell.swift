//
//  ProfileCompletionCollectionCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileCompletionCollectionCellDelegate {
    func relayDidPressDiscoverButton(sender: UIButton, tabTitle: String)
}

class ProfileCompletionCollectionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var profileCompletionCollectionCellDelegate: ProfileCompletionCollectionCellDelegate!
    private let cellIdentifier = "cell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30)
        layout.scrollDirection = .horizontal
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var objects = [NSManagedObject]()
    private var title = ""
    private var emptyView = ProfileCompletionEmptyView()
    
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
        self.collectionView.backgroundColor = HSColor.quaternary
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(SinglesMinisCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        
        //Setup EmptyView
        self.emptyView.mainButton.addTarget(self, action: #selector(discoverButtonPressed(sender:)), for: .touchUpInside)
    }
    
    func setupConstraints(){
        let viewDict = ["collectionView": collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(objects: [NSManagedObject]?, title: String?){
        self.title = title ?? ""
        if objects != nil{
            self.objects = objects!
        }
        self.collectionView.reloadData()
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if objects.count > 0{
            self.collectionView.backgroundView = nil
            return objects.count
        }
        else{
            //Show Empty Background
            self.emptyView.configure(title: self.title+"NoneCompletedError")
            self.collectionView.backgroundView = self.emptyView
            return 0
        }
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 80, height: collectionView.frame.height-60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.width-300)/2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SinglesMinisCell
        //let minis = self.minis[indexPath.row]
        cell.backgroundColor = HSColor.quaternary
        cell.configure(singleMini: nil)
        return cell
    }
    
    //Button Delegates
    func discoverButtonPressed(sender: UIButton){
        self.profileCompletionCollectionCellDelegate.relayDidPressDiscoverButton(sender: sender, tabTitle: self.title)
    }
}

