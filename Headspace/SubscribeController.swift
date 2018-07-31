//
//  SubscribeNowController.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class SubscribeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    private let headerCellIdentifier = "headerCell"
    private let sectionHeaderCellIdentifier = "sectionHeaderCell"
    private let plansCellIdentifier = "plansCell"
    var subscribeView = SubscribeView()
    var plans = [Plan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup View
        self.setupView()
        
        //Download Data
        self.downloadData()
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup Subscribe View
        self.setupSubscribeView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    func setupSubscribeView(){
        self.subscribeView.collectionView.dataSource = self
        self.subscribeView.collectionView.delegate = self
        self.subscribeView.collectionView.register(SubscribeHeaderCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        self.subscribeView.collectionView.register(SubscribePlansCell.self, forCellWithReuseIdentifier: plansCellIdentifier)
        self.subscribeView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for:.touchUpInside)
        self.subscribeView.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for:.touchUpInside)
        self.subscribeView.configure()
        self.subscribeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subscribeView)
    }
    
    func setupConstraints(){
        let viewDict = ["subscribeView": subscribeView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subscribeView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subscribeView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        let headspaceManager = HeadspaceManager()
        headspaceManager.downloadPlans { (plans) in
            self.plans = plans
            self.subscribeView.collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = collectionView.frame.width
        switch indexPath.item{
        case 0:
            return CGSize(width: cellWidth, height: cellWidth*0.9)
        case 1:
            return CGSize(width: cellWidth, height: 270)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! SubscribeHeaderCell
            cell.configure()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: plansCellIdentifier, for: indexPath) as! SubscribePlansCell
            cell.configure(plans: self.plans)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! SubscribeHeaderCell
            return cell
        }
    }
    
    //CollectionViewCell Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //Button Delegates
    func cancelButtonPressed(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func mainButtonPressed(sender: UIButton){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
}
