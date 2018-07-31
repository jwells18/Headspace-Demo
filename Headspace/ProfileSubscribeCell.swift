//
//  ProfileSubscribeCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class ProfileSubscribeCell: UICollectionViewCell{
    
    var titleLabel = UILabel()
    var mainButton = UIButton()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor =  .white
        self.clipsToBounds = false
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTitleLabel(){
        self.titleLabel.text = "subscribeToHeadspace".localized()
        self.titleLabel.textColor = .darkGray
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupMainButton(){
        self.mainButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        self.mainButton.backgroundColor = .darkGray
        self.mainButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        self.mainButton.isUserInteractionEnabled = false
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupConstraints(){
        let spacerViewRight = UIView()
        spacerViewRight.isUserInteractionEnabled = false
        spacerViewRight.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewRight)
        let spacerViewLeft = UIView()
        spacerViewLeft.isUserInteractionEnabled = false
        spacerViewLeft.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewLeft)
        
        let viewDict = ["titleLabel": titleLabel, "mainButton": mainButton, "spacerViewRight": spacerViewRight, "spacerViewLeft": spacerViewLeft] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacerViewRight(==spacerViewLeft)][titleLabel]-12-[mainButton(30)]-12-[spacerViewLeft(==spacerViewRight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: mainButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: mainButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.mainButton.layer.cornerRadius = self.mainButton.frame.height/2
    }
}
