//
//  HomeMinisCollectionCollectionCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class HomeMinisCollectionCollectionCell: UICollectionViewCell{
    
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
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = HSColor.secondary
        self.subTitleLabel.textAlignment = .center
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
    }
    
    func setupConstraints(){
        //Width & Horizontal Alignment
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.subTitleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.imageView, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 12)])
        self.addConstraints([NSLayoutConstraint.init(item: self.subTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 0)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.imageView.frame.width/2
    }
    
    func configure(singleMini: NSManagedObject?){
        if singleMini?.value(forKey: "isPremium") as? NSNumber == 1{
            self.alpha = 0.5
        }
        else{
            self.alpha = 1
        }
        if singleMini?.value(forKey: "coverImage") != nil{
            self.imageView.sd_setImage(with: URL(string: singleMini?.value(forKey: "coverImage") as? String ?? ""), completed: nil)
        }
        else{
            self.imageView.image = UIImage()
        }
        self.titleLabel.text = singleMini?.value(forKey: "name") as? String ?? ""
        let sessionLengthsString = singleMini?.value(forKey: "sessionLengths") as? String ?? ""
        let sessionLengths = sessionLengthsString.components(separatedBy: ",")
        self.subTitleLabel.text = String(format: "%@ %@", sessionLengths.first ?? "0" , "min".localized())
    }
}

