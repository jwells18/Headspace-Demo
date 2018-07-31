//
//  ProfileCompletionEmptyView.swift
//  Headspace
//
//  Created by Justin Wells on 7/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class ProfileCompletionEmptyView: UIView{
    
    var titleLabel = UILabel()
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
        self.backgroundColor = HSColor.quaternary
        self.clipsToBounds = false
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = .gray
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupMainButton(){
        self.mainButton.backgroundColor = HSColor.secondary
        self.mainButton.setTitle("discover".localized().uppercased(), for: .normal)
        self.mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.mainButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
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
        
        let viewDict = ["titleLabel": titleLabel, "mainButton": mainButton, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: mainButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerViewTop(==spacerViewBottom)][titleLabel]-20-[mainButton][spacerViewBottom(==spacerViewTop)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(title: String?){
        self.titleLabel.text = title?.localized()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.mainButton.layer.cornerRadius = self.mainButton.frame.height/2
    }
}
