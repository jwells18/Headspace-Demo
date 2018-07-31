//
//  SettingsCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell{
    
    var titleLabel = UILabel()
    var accessoryImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Setup View
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.selectionStyle = .none
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup AccessoryImageView
        self.setupAccessoryImageView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupAccessoryImageView(){
        self.accessoryImageView.image = UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate)
        self.accessoryImageView.tintColor = HSColor.secondary
        self.accessoryImageView.clipsToBounds = true
        self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.accessoryImageView)
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerView)
        
        let viewDict = ["titleLabel": titleLabel, "accessoryImageView": accessoryImageView, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleLabel][spacerView][accessoryImageView(25)]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: accessoryImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: accessoryImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
    }
    
    func configure(title: String?){
        self.titleLabel.text = title
    }
}
