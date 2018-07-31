//
//  SettingsInfoCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class SettingsInfoCell: UITableViewCell{
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
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
        self.clipsToBounds = false
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = HSColor.secondary
        self.subTitleLabel.textAlignment = .center
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        self.subTitleLabel.numberOfLines = 3
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
    }
    
    func setupConstraints(){
        let viewDict = ["titleLabel": titleLabel, "subTitleLabel": subTitleLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: subTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[titleLabel]-[subTitleLabel]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(user: NSManagedObject?){
        self.titleLabel.text = "loggedInAs".localized()
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        self.subTitleLabel.text = String(format:"%@\n\n%@ %@.%@", user?.value(forKey: "email") as? String ?? "", "version".localized(), versionNumber, buildNumber)
    }
}
