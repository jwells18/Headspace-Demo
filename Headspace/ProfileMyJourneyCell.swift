//
//  ProfileMyJourneyCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/22/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol ProfileMyJourneyCellDelegate{
    func didPressProfileMyJourneyCell(indexPath: IndexPath)
}

class ProfileMyJourneyCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProfileCompletedCellDelegate{
    
    var profileMyJourneyCellDelegate: ProfileMyJourneyCellDelegate!
    private let subscribeCellIdentifier = "subscribeCell"
    private let completedCellIdentifier = "completedCell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    
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
        self.collectionView.register(ProfileSubscribeCell.self, forCellWithReuseIdentifier: subscribeCellIdentifier)
        self.collectionView.register(ProfileCompletedCell.self, forCellWithReuseIdentifier: completedCellIdentifier)
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

    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        switch indexPath.item{
        case 0:
            return CGSize(width: collectionView.frame.width, height: 60)
        default:
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subscribeCellIdentifier, for: indexPath) as! ProfileSubscribeCell
            return cell
        case _ where indexPath.item > 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: completedCellIdentifier, for: indexPath) as! ProfileCompletedCell
            cell.profileCompletedCellDelegate = self
            var isLast = false
            if indexPath.item == 2{
                isLast = true
            }
            cell.configure(object: nil, isLast: isLast)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subscribeCellIdentifier, for: indexPath) as! ProfileSubscribeCell
            return cell
        }
    }
    
    //UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.profileMyJourneyCellDelegate.didPressProfileMyJourneyCell(indexPath: indexPath)
    }
    
    func relayDidPressJourneyButton(sender: UIButton) {
        let touchPoint = sender.convert(CGPoint.zero, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
        if indexPath != nil{
            self.profileMyJourneyCellDelegate.didPressProfileMyJourneyCell(indexPath: indexPath!)
        }
    }
}
