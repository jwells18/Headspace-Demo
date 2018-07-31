//
//  ProfileBuddyCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class ProfileBuddyCell: UICollectionViewCell{
    
    var mainImageView = UIImageView()
    var titleLabel = UILabel()
    var accessoryImageView = UIImageView()
    var separatorView = UIView()
    
    public override init(frame: CGRect){
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
        
        //Setup Main ImageView
        self.setupMainImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Accessory ImageView
        self.setupAccessoryImageView()
        
        //Setup Separator View
        self.setupSeparatorView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupMainImageView(){
        self.mainImageView.backgroundColor = HSColor.quaternary
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainImageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = .darkGray
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupAccessoryImageView(){
        self.accessoryImageView.tintColor = .darkGray
        self.accessoryImageView.clipsToBounds = true
        self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.accessoryImageView)
    }
    
    func setupSeparatorView(){
        self.separatorView.backgroundColor = HSColor.quaternary
        self.separatorView.isUserInteractionEnabled = false
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.separatorView)
    }
    
    func setupConstraints(){
        let viewDict = ["mainImageView": mainImageView, "titleLabel": titleLabel, "accessoryImageView": accessoryImageView, "separatorView": separatorView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[mainImageView(60)]-30-[titleLabel]-[accessoryImageView(30)]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints([NSLayoutConstraint.init(item: mainImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: mainImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)])
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        self.addConstraints([NSLayoutConstraint.init(item: accessoryImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: accessoryImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        self.addConstraints([NSLayoutConstraint.init(item: separatorView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2)])
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.width/2
    }
    
    func configure(user: NSManagedObject?){
        if user?.value(forKey: "image") as? String != nil{
            self.mainImageView.sd_setImage(with: URL(string: user?.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage(named: "addABuddy"))
        }
        else{
            mainImageView.image = UIImage(named: "addABuddy")
        }
        switch user == nil{
        case true:
            self.titleLabel.text = "addABuddy".localized()
            self.accessoryImageView.image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        case false:
            self.titleLabel.text = String(format: "%@ %@", user?.value(forKey: "firstName") as? String ?? "", user?.value(forKey: "lastName") as? String ?? "")
            self.accessoryImageView.image = UIImage()
        }
    }
}
