//
//  AnimationsCollectionCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class AnimationsCollectionCell: UICollectionViewCell{
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var statusImageView = UIImageView()
    
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
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        
        //Setup ImageView
        self.setupImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Status ImageView
        self.setupStatusImageView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        self.imageView.backgroundColor = .lightGray
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.titleLabel.numberOfLines = 2
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupStatusImageView(){
        self.statusImageView.contentMode = .scaleAspectFill
        self.statusImageView.clipsToBounds = true
        self.statusImageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.addSubview(self.statusImageView)
    }
    
    func setupConstraints(){
        
        let viewDict = ["imageView": imageView, "titleLabel": titleLabel, "statusImageView": statusImageView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[titleLabel]-12-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.imageView.addConstraint(NSLayoutConstraint.init(item: statusImageView, attribute: .centerX, relatedBy: .equal, toItem: self.imageView, attribute: .centerX, multiplier: 1, constant: 0))
        self.imageView.addConstraint(NSLayoutConstraint.init(item: statusImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView][titleLabel(70)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.imageView.addConstraint(NSLayoutConstraint.init(item: statusImageView, attribute: .centerY, relatedBy: .equal, toItem: self.imageView, attribute: .centerY, multiplier: 1, constant: 0))
        self.imageView.addConstraint(NSLayoutConstraint.init(item: statusImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
    }
    
    func configure(animation: NSManagedObject?){
        if animation?.value(forKey: "coverImage") != nil{
            self.imageView.sd_setImage(with: URL(string: animation?.value(forKey: "coverImage") as? String ?? ""), completed: nil)
        }
        else{
            self.imageView.image = UIImage()
        }
        self.titleLabel.text = animation?.value(forKey: "name") as? String
    }
}
