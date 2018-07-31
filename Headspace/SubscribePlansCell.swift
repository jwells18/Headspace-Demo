//
//  SubscribePlansCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class SubscribePlansCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    private let cellIdentifier = "cell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30)
        layout.scrollDirection = .horizontal
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var activeLabel = UILabel()
    var disclaimerLabel = UILabel()
    var plans: [Plan]!
    var selectedPath = IndexPath(item: 1, section: 0)
    
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
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup Active Label
        self.setupActiveLabel()
        
        //Setup Disclaimer Label
        self.setupDisclaimerLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .white
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(SubscribePlansCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.text = "recurringBillTitle".localized()
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = HSColor.secondary
        self.subTitleLabel.textAlignment = .center
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
    }
    
    func setupActiveLabel(){
        self.activeLabel.textColor = .gray
        self.activeLabel.textAlignment = .center
        self.activeLabel.font = UIFont.systemFont(ofSize: 12)
        self.activeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.activeLabel)
    }
    
    func setupDisclaimerLabel(){
        self.disclaimerLabel.text = "subscribeDisclaimer".localized()
        self.disclaimerLabel.textColor = HSColor.secondary
        self.disclaimerLabel.textAlignment = .center
        self.disclaimerLabel.font = UIFont.systemFont(ofSize: 10)
        self.disclaimerLabel.numberOfLines = 0
        self.disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.disclaimerLabel)
    }
    
    func setupConstraints(){
        let viewDict = ["collectionView": self.collectionView, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "activeLabel": activeLabel, "disclaimerLabel": disclaimerLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[subTitleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[activeLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[disclaimerLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView(135)]-[titleLabel(16)]-[subTitleLabel(16)]-[activeLabel(16)][disclaimerLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(plans: [Plan]?){
        if plans != nil{
            self.plans = plans!
            self.collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.plans.count
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.height*0.75, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SubscribePlansCollectionCell
        let plan = self.plans[indexPath.item]
        cell.configure(plan: plan)
        if indexPath == self.selectedPath{
            cell.isSelected = true
            self.determineSubTitleLabel(plan: plan)
        }
        else{
            cell.isSelected = false
        }
        return cell
    }
    
    func determineSubTitleLabel(plan: Plan?){
        if plan?.period ?? 0 > 0 && plan?.price != nil{
            let perMonthRate = NSNumber(value: Double((plan?.price)!)/Double((plan?.period)!))
            let perMonthString = perMonthRate.currencyString(maxFractionDigits: 2)
            self.subTitleLabel.text = String(format: "%@ %@ %@.","thats".localized(), perMonthString, "aMonth".localized())
        }
        else{
            self.subTitleLabel.text = ""
        }
    }
    
    //CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath != self.selectedPath{
            self.selectedPath = indexPath
            collectionView.reloadData()
        }
    }
}
