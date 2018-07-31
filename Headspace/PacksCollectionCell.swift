//
//  PacksCollectionCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class PacksCollectionCell: UICollectionViewCell{
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
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
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
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
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel.numberOfLines = 2
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = .white
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerView)
        
        let viewDict = ["imageView": imageView, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLabel]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[subTitleLabel]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[titleLabel][spacerView][subTitleLabel]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(pack: NSManagedObject?){
        if pack?.value(forKey: "coverImage") != nil{
            self.imageView.sd_setImage(with: URL(string: pack?.value(forKey: "coverImage") as? String ?? ""), completed: nil)
        }
        else{
            self.imageView.image = UIImage()
        }
        self.titleLabel.text = pack?.value(forKey: "name") as? String
        self.subTitleLabel.text = String(format: "%@ %@", pack?.value(forKey: "sessions") as? NSNumber ?? "0", "sessions".localized())
    }
}
