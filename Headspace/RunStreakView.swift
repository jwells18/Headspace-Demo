//
//  RunStreakView.swift
//  Headspace
//
//  Created by Justin Wells on 7/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class RunStreakView: UIView{
    
    var cancelButton = UIButton()
    var titleLabel = UILabel()
    var imageView = UIImageView()
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
        self.backgroundColor = HSColor.quaternary
        
        //Setup Cancel Button
        self.setupCancelButton()
        
        //Setup TitleLabel
        self.setupTitleLabel()
        
        //Setup ImageView
        self.setupImageView()
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCancelButton(){
        self.cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        self.cancelButton.clipsToBounds = true
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cancelButton)
    }
    
    func setupTitleLabel(){
        self.titleLabel.text = "runStreakGoals".localized().uppercased()
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = .lightGray
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupImageView(){
        self.imageView.image = UIImage(named: "runStreak")
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    func setupCollectionView(){
        //Setup CollectionView
        self.collectionView.backgroundColor = HSColor.quaternary
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupConstraints(){
        let spacerViewTop = UIView()
        spacerViewTop.isUserInteractionEnabled = false
        spacerViewTop.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewTop)
        let spacerViewBottom = UIView()
        spacerViewBottom.isUserInteractionEnabled = false
        spacerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewBottom)
        
        let viewDict = ["cancelButton": cancelButton, "titleLabel": titleLabel, "imageView": imageView, "collectionView": collectionView, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancelButton(30)]-12-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.6, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[collectionView]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-27-[cancelButton(30)]-40-[titleLabel][spacerViewTop(==spacerViewBottom)][imageView][spacerViewBottom(==spacerViewTop)][collectionView(200)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: self.imageView, attribute: .width, multiplier: 1.25, constant: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.width/2
    }
}
