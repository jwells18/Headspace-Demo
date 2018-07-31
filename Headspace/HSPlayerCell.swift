//
//  HSPlayerCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/30/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HSPlayerCell: UICollectionViewCell{
    
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
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupMainButton(){
        //self.mainButton.backgroundImageView.image = UIImage(named: "HSPlayButton")
        self.mainButton.setImage(UIImage(named: "HSPlayButton"), for: .normal)
        self.tintColor = HSColor.secondary
        self.mainButton.clipsToBounds = true
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupConstraints(){
        let viewDict = ["mainButton": mainButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
