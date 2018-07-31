//
//  ProfileStreakCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileStreakCellDelegate {
    func relayDidPressMainSubButton(sender: UIButton)
    func relayDidPressViewGoalsButton(sender: UIButton)
}

class ProfileStreakCell: UICollectionViewCell{
    
    var profileStreakCellDelegate: ProfileStreakCellDelegate!
    var mainImageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var mainSubButton = UIButton()
    var mainButton = UIButton()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor =  HSColor.secondary
        self.clipsToBounds = false
        
        //Setup Main ImageView
        self.setupMainImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup MainSub Button
        self.setupMainSubButton()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupMainImageView(){
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainImageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = .white
        self.subTitleLabel.textAlignment = .center
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 18)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
    }
    
    func setupMainSubButton(){
        self.mainSubButton.clipsToBounds = true
        self.mainSubButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.mainSubButton.addTarget(self, action: #selector(mainSubButtonPressed(sender:)), for: .touchUpInside)
        self.mainSubButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainSubButton)
    }
    
    func setupMainButton(){
        self.mainButton.setTitle("viewGoals".localized().uppercased(), for: .normal)
        self.mainButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.mainButton.backgroundColor = .clear
        self.mainButton.contentEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 24)
        self.mainButton.clipsToBounds = true
        self.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for: .touchUpInside)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupConstraints(){
        let spacerView1 = UIView()
        let spacerView2 = UIView()
        let spacerView3 = UIView()
        let spacerView4 = UIView()
        let spacerView5 = UIView()
        let spacerViews = [spacerView1, spacerView2, spacerView3, spacerView4, spacerView5]
        for spacer in spacerViews{
            spacer.isUserInteractionEnabled = false
            spacer.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(spacer)
        }
        
        let viewDict = ["mainImageView": mainImageView, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "mainSubButton": mainSubButton, "mainButton": mainButton, "spacerView1": spacerView1, "spacerView2": spacerView2, "spacerView3": spacerView3, "spacerView4": spacerView4, "spacerView5": spacerView5] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[subTitleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: mainSubButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: mainButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerView1(==spacerView2)][subTitleLabel][spacerView2(==spacerView3)][titleLabel][spacerView3(==spacerView4)][mainSubButton][spacerView4(==spacerView5)][mainButton][spacerView5(==spacerView1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.mainSubButton.layer.cornerRadius = self.mainSubButton.frame.height/2
        self.mainButton.layer.cornerRadius = self.mainButton.frame.height/2
    }
    
    func configure(user: NSManagedObject?){
        //TODO: Improve on this algorithm
        //For demo purposes, turning 24 hour check off
        //let lastSession = user?.value(forKey: "lastSession") as? Double ?? 25
        //let lastSessionDate = Date.init(timeIntervalSince1970: lastSession/1000)
        if user != nil /*&& lastSessionDate.hours(from: Date()) < 24*/{
            self.mainImageView.image = UIImage(named: "runStreakBackground")
            self.subTitleLabel.text = "currentRunStreak".localized()
            self.titleLabel.text = String(format: "%@ %@", "1", "day".localized())
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 50)
            self.mainSubButton.backgroundColor = .white
            self.mainSubButton.setImage(UIImage(named: "share"), for: .normal)
            self.mainSubButton.setTitle("", for: .normal)
            self.mainSubButton.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
            self.mainButton.layer.borderColor = UIColor.white.cgColor
            self.mainButton.layer.borderWidth = 2
        }
        else{
            self.titleLabel.text = "noStreakTitle".localized()
            self.subTitleLabel.text = ""
            self.titleLabel.font = UIFont.systemFont(ofSize: 24)
            self.mainSubButton.backgroundColor = .clear
            self.mainSubButton.setTitle("meditate".localized().uppercased(), for: .normal)
            self.mainSubButton.setImage(UIImage(), for: .normal)
            self.mainSubButton.layer.borderColor = UIColor.white.cgColor
            self.mainSubButton.layer.borderWidth = 2
            self.mainSubButton.contentEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 24)
            self.mainButton.layer.borderWidth = 0
        }
    }
    
    //Button Delegates
    func mainSubButtonPressed(sender: UIButton){
        self.profileStreakCellDelegate.relayDidPressMainSubButton(sender: sender)
    }
    
    func mainButtonPressed(sender: UIButton){
        self.profileStreakCellDelegate.relayDidPressViewGoalsButton(sender: sender)
    }
}

extension Date {
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
}
