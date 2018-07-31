//
//  ProfileHeaderView.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class ProfileHeaderView: UIView{
    
    var imageView = UIImageView()
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
        self.backgroundColor = .white
        self.clipsToBounds = false
        
        //Setup ImageView
        self.setupImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        self.imageView.backgroundColor = HSColor.quaternary
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupMainButton(){
        self.mainButton.setImage(UIImage(named: "settings"), for: .normal)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView, "titleLabel": titleLabel, "mainButton": mainButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[imageView(70)]-16-[titleLabel]-[mainButton(25)]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints([NSLayoutConstraint.init(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70)])
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
        self.addConstraints([NSLayoutConstraint.init(item: mainButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: mainButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.imageView.frame.width/2
    }
    
    func configure(user: NSManagedObject?){
        if user?.value(forKey: "image") as? String != nil{
            self.imageView.sd_setImage(with: URL(string: user?.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage(named: "userImagePlaceholder"))
        }
        else{
            imageView.image = UIImage(named: "userImagePlaceholder")
        }
        self.titleLabel.text = String(format: "%@ %@", user?.value(forKey: "firstName") as? String ?? "", user?.value(forKey: "lastName") as? String ?? "")
    }
}
