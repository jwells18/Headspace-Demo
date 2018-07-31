//
//  DiscoverKidsHeaderCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/22/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol DiscoverHeaderCellDelegate {
    func didPressDiscoverHeaderButton(sender: UIButton)
}

class DiscoverKidsHeaderCell: UICollectionViewCell{
    
    var discoverHeaderCellDelegate: DiscoverHeaderCellDelegate!
    var imageView = UIImageView()
    var mainButton = HSIconButton()
    
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
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        self.imageView.image = UIImage(named: "kidsHeader")
        self.imageView.backgroundColor = .lightGray
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    func setupMainButton(){
        self.mainButton.configure(image: UIImage(named: "play"), title: "learnMore".localized().uppercased())
        self.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for: .touchUpInside)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView, "mainButton": mainButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[mainButton]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[mainButton]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //Button Delegates
    func mainButtonPressed(sender: UIButton){
        self.discoverHeaderCellDelegate.didPressDiscoverHeaderButton(sender: sender)
    }
}
