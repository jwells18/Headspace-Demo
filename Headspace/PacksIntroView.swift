//
//  PacksIntroView.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class PacksIntroView: UIView{
    
    var cancelButton = UIButton()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var mainButton = UIButton()
    var mainSubButton = UIButton()
    
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
        
        //Setup Cancel Button
        self.setupCancelButton()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup MainSub Button
        self.setupMainSubButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCollectionView(){
        self.collectionView.backgroundColor = .white
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupCancelButton(){
        self.cancelButton.backgroundColor = .white
        self.cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        self.cancelButton.tintColor = HSColor.secondary
        self.cancelButton.clipsToBounds = true
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cancelButton)
    }
    
    func setupMainButton(){
        self.mainButton.setTitleColor(.white, for: .normal)
        self.mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.mainButton.backgroundColor = HSColor.secondary
        self.mainButton.clipsToBounds = true
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupMainSubButton(){
        self.mainSubButton.setTitleColor(HSColor.secondary, for: .normal)
        self.mainSubButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.mainSubButton.backgroundColor = HSColor.quaternary
        self.mainSubButton.clipsToBounds = true
        self.mainSubButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainSubButton)
    }

    func setupConstraints(){
        let viewDict = ["collectionView": self.collectionView, "cancelButton": cancelButton, "mainButton": mainButton, "mainSubButton": mainSubButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancelButton(40)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainSubButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView][mainSubButton(60)][mainButton(60)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[cancelButton(40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.width/2
    }
    
    func configure(pack: NSManagedObject?){
        if pack?.value(forKey: "isPremium") as? NSNumber == 0{
            self.mainButton.setTitle("beginPack".localized().uppercased(), for: .normal)
        }
        else{
            self.mainButton.setTitle("subscribeToUnlock".localized().uppercased(), for: .normal)
        }
        self.mainSubButton.setTitle("addToMyPacks".localized().uppercased(), for: .normal)
    }
}
