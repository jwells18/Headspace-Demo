//
//  DiscoverHeaderCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/22/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class DiscoverHeaderCell: UICollectionViewCell{
    
    var imageView = UIImageView()
    var titleButton = UIButton()
    var subTitleButton = UIButton()
    
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
        
        //Setup Title Button
        self.setupTitleButton()
        
        //Setup SubTitle Button
        self.setupSubTitleButton()
        
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
    
    func setupTitleButton(){
        self.titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        self.titleButton.contentEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        self.titleButton.isUserInteractionEnabled = false
        self.titleButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleButton)
    }
    
    func setupSubTitleButton(){
        self.subTitleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.subTitleButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16)
        self.subTitleButton.isUserInteractionEnabled = false
        self.subTitleButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleButton)
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView, "titleButton": titleButton, "subTitleButton": subTitleButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[subTitleButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[subTitleButton][titleButton]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleButton.roundCorners(corners: [.topRight, .bottomLeft, .bottomRight], radius: 5)
        self.subTitleButton.roundCorners(corners: [.topLeft, .topRight], radius: 5)
    }
    
    func configure(image: UIImage?){
        self.imageView.image = image
    }
    
    func configure(object: NSManagedObject?){
        if object?.value(forKey: "image") != nil{
            self.imageView.sd_setImage(with: URL(string: object?.value(forKey: "image") as? String ?? ""), completed: nil)
        }
        else{
            self.imageView.image = UIImage()
        }
        let title = object?.value(forKey: "name") as? String 
        if title != nil{
            self.titleButton.setTitle(object?.value(forKey: "name") as? String, for: .normal)
            self.titleButton.backgroundColor = HSColor.quaternary
            self.titleButton.setTitleColor(HSColor.secondary, for: .normal)
            self.subTitleButton.setTitle("featured".localized().uppercased(), for: .normal)
            self.subTitleButton.backgroundColor = HSColor.primary
            self.subTitleButton.setTitleColor(.white, for: .normal)
        }
    }
}
