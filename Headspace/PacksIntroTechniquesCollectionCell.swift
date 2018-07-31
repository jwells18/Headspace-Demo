//
//  PacksIntroTechniquesCollectionCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class PacksIntroTechniquesCollectionCell: UICollectionViewCell{
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var playButton = UIButton()
    
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
        
        //Setup Play Button
        self.setupPlayButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        self.imageView.backgroundColor = HSColor.mustard
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupPlayButton(){
        self.playButton.backgroundColor = HSColor.secondary
        self.playButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.playButton.tintColor = HSColor.quaternary
        self.playButton.contentMode = .scaleAspectFill
        self.playButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        self.playButton.isUserInteractionEnabled = false
        self.playButton.clipsToBounds = true
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.playButton)
    }
    
    func setupConstraints(){
        //Width & Horizontal Alignment
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)])
        self.addConstraints([NSLayoutConstraint.init(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.playButton, attribute: .right, relatedBy: .equal, toItem: self.imageView, attribute: .right, multiplier: 1, constant: 5)])
        self.addConstraints([NSLayoutConstraint.init(item: self.playButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
        //Height & Vertical Alignment
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.imageView, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 12)])
        self.addConstraints([NSLayoutConstraint.init(item: self.playButton, attribute: .bottom, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 5)])
        self.addConstraints([NSLayoutConstraint.init(item: self.playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.imageView.frame.width/2
        self.playButton.layer.cornerRadius = self.playButton.frame.width/2
    }
    
    func configure(technique: NSManagedObject?){
        if technique?.value(forKey: "image") != nil{
            self.imageView.sd_setImage(with: URL(string: technique?.value(forKey: "image") as? String ?? ""), completed: nil)
        }
        else{
            self.imageView.image = UIImage()
        }
        self.titleLabel.text = technique?.value(forKey: "name") as? String
    }
}
