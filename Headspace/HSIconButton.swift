//
//  HSIconButton.swift
//  Headspace
//
//  Created by Justin Wells on 7/30/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HSIconButton: UIButton{
    
    var iconView = UIImageView()
    var textLabel = UILabel()
    
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
        self.clipsToBounds = true
        
        //Setup IconView
        self.setupIconView()
        
        //Setup TextLabel
        self.setupTextLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupIconView(){
        iconView.tintColor = HSColor.secondary
        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconView)
    }
    
    func setupTextLabel(){
        textLabel.textAlignment = .center
        textLabel.textColor = HSColor.secondary
        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)
    }
    
    func setupConstraints(){
        let viewDict = ["textLabel": textLabel, "iconView": iconView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[iconView(<=18)]-[textLabel]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints([NSLayoutConstraint.init(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[iconView(<=18)]-12-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func configure(image: UIImage? ,title: String?){
        if image != nil{
            iconView.image = image!.withRenderingMode(.alwaysTemplate)
        }
        textLabel.text = title
    }
}

