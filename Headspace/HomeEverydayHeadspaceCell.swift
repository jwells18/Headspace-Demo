//
//  HomeEverydayHeadspaceCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol HomeEveryayHeadspaceCellDelegate {
    func didPressEverydayHeadspaceButton(sender: UIButton)
    func didPressEverydayHeadspacePlayButton(sender: UIButton)
}

class HomeEverydayHeadspaceCell: UICollectionViewCell{
    
    var homeEverydayHeadspaceCellDelegate: HomeEveryayHeadspaceCellDelegate!
    var mainButton = UIButton()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
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
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup Play Button
        self.setupPlayButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupMainButton(){
        self.mainButton.backgroundColor = HSColor.mustard
        self.mainButton.clipsToBounds = true
        self.mainButton.contentHorizontalAlignment = .fill
        self.mainButton.contentVerticalAlignment = .fill
        self.mainButton.layer.cornerRadius = 5
        self.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for: .touchUpInside)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = HSColor.secondary
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(self.subTitleLabel)
    }
    
    func setupPlayButton(){
        self.playButton.tintColor = HSColor.mustard
        self.playButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.playButton.layer.cornerRadius = 50/2
        self.playButton.addTarget(self, action: #selector(playButtonPressed(sender:)), for: .touchUpInside)
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(self.playButton)
    }
    
    func setupConstraints(){
        let spacerViewTop = UIView()
        spacerViewTop.isUserInteractionEnabled = false
        spacerViewTop.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(spacerViewTop)
        let spacerViewBottom = UIView()
        spacerViewBottom.isUserInteractionEnabled = false
        spacerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(spacerViewBottom)
        
        let viewDict = ["mainButton": mainButton, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "playButton": playButton, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30@750-[mainButton]-30@750-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mainButton.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLabel]-[playButton(50)]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mainButton.addConstraints([NSLayoutConstraint.init(item: self.subTitleLabel, attribute: .left, relatedBy: .equal, toItem: self.titleLabel, attribute: .left, multiplier: 1, constant: 0)])
        self.mainButton.addConstraints([NSLayoutConstraint.init(item: self.subTitleLabel, attribute: .width, relatedBy: .equal, toItem: self.titleLabel, attribute: .width, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mainButton.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerViewTop(==spacerViewBottom)][titleLabel][subTitleLabel][spacerViewBottom(==spacerViewTop)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mainButton.addConstraints([NSLayoutConstraint.init(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: self.mainButton, attribute: .centerY, multiplier: 1, constant: 0)])
        self.mainButton.addConstraints([NSLayoutConstraint.init(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    func configure(singleMini: NSManagedObject?){
        if singleMini != nil{
            self.titleLabel.text = singleMini?.value(forKey: "name") as? String ?? ""
            self.subTitleLabel.text = "tryItForFree".localized()
            self.mainButton.setImage(UIImage(named: "everydayHeadspaceBackground"), for: .normal)
            self.playButton.backgroundColor = HSColor.secondary
            self.playButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    //Button Delegates
    func mainButtonPressed(sender: UIButton){
        self.homeEverydayHeadspaceCellDelegate.didPressEverydayHeadspaceButton(sender: sender)
    }
    
    func playButtonPressed(sender: UIButton){
        self.homeEverydayHeadspaceCellDelegate.didPressEverydayHeadspacePlayButton(sender: sender)
    }
}
