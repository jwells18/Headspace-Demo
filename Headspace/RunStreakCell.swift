//
//  RunStreakCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class RunStreakCell: UICollectionViewCell{
    
    var imageView = UIImageView()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor =  HSColor.quaternary
        self.clipsToBounds = false
        
        //Setup ImageView
        self.setupImageView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(image: UIImage?){
        self.imageView.image = image
    }
}
