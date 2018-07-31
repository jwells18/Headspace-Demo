//
//  SettingsViewTableFooter.swift
//  Headspace
//
//  Created by Justin Wells on 7/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class SettingsViewTableFooter: UIView{
    
    var mainButton = UIButton()
    
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
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupMainButton(){
        self.mainButton.setTitle("logOut".localized().uppercased(), for: .normal)
        self.mainButton.backgroundColor = HSColor.secondary
        self.mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
