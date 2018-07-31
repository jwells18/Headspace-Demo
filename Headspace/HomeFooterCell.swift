//
//  HomeFooterCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol HomeFooterCellDelegate {
    func didPressSubscribeButton(sender: UIButton)
}

class HomeFooterCell: UICollectionViewCell{
    
    var homeFooterCellDelegate: HomeFooterCellDelegate!
    var backgroundImageView = UIImageView()
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
        
        //Setup Background ImageView
        self.setupBackgroundImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupBackgroundImageView(){
        self.backgroundImageView.image = UIImage(named: "homeTableFooterBackground")
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.clipsToBounds = true
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.backgroundImageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.text = "unlockTheHeadspaceLibrary".localized()
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupMainButton(){
        self.mainButton.setTitle("subscribeNow".localized().uppercased(), for: .normal)
        self.mainButton.backgroundColor = HSColor.secondary
        self.mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.mainButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16)
        self.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for: .touchUpInside)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupConstraints(){
        let viewDict = ["backgroundImageView": backgroundImageView, "titleLabel": titleLabel, "mainButton": mainButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: mainButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[titleLabel]-20-[mainButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainButton.layer.cornerRadius = self.mainButton.frame.height/2
    }
    
    //Button Delegates
    func mainButtonPressed(sender: UIButton){
        self.homeFooterCellDelegate.didPressSubscribeButton(sender: sender)
    }
}
