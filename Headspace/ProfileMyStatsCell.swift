//
//  ProfileMyStatsCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/22/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileMyStatsCellDelegate {
    func didPressMainSubButton(sender: UIButton)
    func didPressViewGoalsButton(sender: UIButton)
    func didPressMyStatsCell(indexPath: IndexPath)
    func didPressDiscoverButton(sender: UIButton, tabTitle: String)
}

class ProfileMyStatsCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProfileStreakCellDelegate, ProfileCompletionCellDelegate{
    
    var profileMyStatsCellDelegate: ProfileMyStatsCellDelegate!
    private let sectionHeaderCellIdentifier = "sectionHeaderCell"
    private let streakCellIdentifier = "streakCell"
    private let statsCellIdentifier = "statsCell"
    private let completionCellIdentifier = "completionCell"
    private let buddyCellIdentifier = "buddyCell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var currentUser: NSManagedObject!
    var buddies = [NSManagedObject]()
    var statsTitles = ["totalTimeMeditated", "sessionsCompleted", "averageDuration"]
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
        self.collectionView.register(HSCollectionSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier)
        self.collectionView.register(ProfileStreakCell.self, forCellWithReuseIdentifier: streakCellIdentifier)
        self.collectionView.register(ProfileStatsCell.self, forCellWithReuseIdentifier: statsCellIdentifier)
        self.collectionView.register(ProfileCompletionCell.self, forCellWithReuseIdentifier: completionCellIdentifier)
        self.collectionView.register(ProfileBuddyCell.self, forCellWithReuseIdentifier: buddyCellIdentifier)
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
    
    func configure(user: NSManagedObject?, packs: [NSManagedObject]?, singles: [NSManagedObject]?, minis: [NSManagedObject]?){
        if user != nil{
            self.currentUser = user!
        }
        if packs != nil{
            self.myCompletedPacks = packs!
        }
        if singles != nil{
            self.myCompletedSingles = singles!
        }
        if minis != nil{
            self.myCompletedMinis = minis!
        }
        self.collectionView.reloadSections(IndexSet(integer: 2))
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 3:
            return CGSize(width: collectionView.frame.width, height: 80)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        //Setup Search Results Header
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView: HSCollectionSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderCellIdentifier, for: indexPath as IndexPath) as! HSCollectionSectionHeader
            if indexPath.section == 3{
                headerView.configure(title: "buddies".localized().uppercased(), subTitle: nil, centered: true)
            }
            reusableView = headerView
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return statsTitles.count
        case 2:
            return 1
        case 3:
            switch buddies.count > 0{
            case true:
                return buddies.count
            case false:
                return 1
            }
        default:
            return 0
        }
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = collectionView.frame.width
        switch indexPath.section{
        case 0:
            return CGSize(width: cellWidth, height: cellWidth)
        case 1:
            return CGSize(width: cellWidth, height: 106)
        case 2:
            return CGSize(width: cellWidth, height: 250)
        case 3:
            return CGSize(width: cellWidth, height: 100)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section{
        case 1:
            return 30
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section{
        case 1:
            return UIEdgeInsetsMake(30, 0, 30, 0)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: streakCellIdentifier, for: indexPath) as! ProfileStreakCell
            cell.profileStreakCellDelegate = self
            cell.configure(user: self.currentUser)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statsCellIdentifier, for: indexPath) as! ProfileStatsCell
            cell.configure(title: statsTitles[indexPath.row], user: self.currentUser)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: completionCellIdentifier, for: indexPath) as! ProfileCompletionCell
            cell.profileCompletionCellDelegate = self
            cell.configure(packs: myCompletedPacks, singles: myCompletedSingles, minis: myCompletedMinis)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buddyCellIdentifier, for: indexPath) as! ProfileBuddyCell
            switch buddies.count > 0{
            case true:
                cell.configure(user: buddies[indexPath.row])
            case false:
                cell.configure(user: nil)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: streakCellIdentifier, for: indexPath) as! ProfileStreakCell
            return cell
        }
    }
    
    //UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.profileMyStatsCellDelegate.didPressMyStatsCell(indexPath: indexPath)
    }
    
    func relayDidPressMainSubButton(sender: UIButton) {
        self.profileMyStatsCellDelegate.didPressMainSubButton(sender: sender)
    }
    
    func relayDidPressViewGoalsButton(sender: UIButton) {
        self.profileMyStatsCellDelegate.didPressViewGoalsButton(sender: sender)
    }
    
    func relayDidPressDiscoverButton(sender: UIButton, tabTitle: String) {
        self.profileMyStatsCellDelegate.didPressDiscoverButton(sender: sender, tabTitle: tabTitle)
    }
}
