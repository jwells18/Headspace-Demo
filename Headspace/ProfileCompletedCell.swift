//
//  ProfileCompletedCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileCompletedCellDelegate{
    func relayDidPressJourneyButton(sender: UIButton)
}

class ProfileCompletedCell: UICollectionViewCell{
    
    var profileCompletedCellDelegate: ProfileCompletedCellDelegate!
    var timelineNode = UIImageView()
    var timeline = UIView()
    var mainButton = UIButton()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var dateLabel = UILabel()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor =  .white
        self.clipsToBounds = false
        
        //Setup Timeline Node
        self.setupTimelineNode()
        
        //Setup Timeline
        self.setupTimeline()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup Date Label
        self.setupDateLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTimelineNode(){
        self.timelineNode.clipsToBounds = true
        self.timelineNode.contentMode = .scaleToFill
        self.timelineNode.backgroundColor = .lightGray
        self.timelineNode.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.timelineNode)
    }
    
    func setupTimeline(){
        self.timeline.backgroundColor = HSColor.faintGray
        self.timeline.isHidden = true
        self.timeline.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.timeline)
    }
    
    func setupMainButton(){
        self.mainButton.backgroundColor = .lightGray
        self.mainButton.contentHorizontalAlignment = .fill
        self.mainButton.contentVerticalAlignment = .fill
        self.mainButton.showsTouchWhenHighlighted = false
        self.mainButton.clipsToBounds = true
        self.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for: .touchUpInside)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = .white
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(self.subTitleLabel)
    }
    
    func setupDateLabel(){
        self.dateLabel.textColor = .white
        self.dateLabel.font = UIFont.systemFont(ofSize: 14)
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(self.dateLabel)
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(spacerView)
        let spacerViewTop = UIView()
        spacerViewTop.isUserInteractionEnabled = false
        spacerViewTop.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(spacerViewTop)
        let spacerViewBottom = UIView()
        spacerViewBottom.isUserInteractionEnabled = false
        spacerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.mainButton.addSubview(spacerViewBottom)
        
        let viewDict = ["timelineNode": timelineNode, "timeline": timeline, "mainButton": mainButton, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "dateLabel": dateLabel, "spacerView": spacerView, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[timelineNode(16)]-20-[mainButton]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mainButton.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleLabel]-[spacerView]-[dateLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: timeline, attribute: .centerX, relatedBy: .equal, toItem: self.timelineNode, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: timeline, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2))
        self.mainButton.addConstraint(NSLayoutConstraint.init(item: subTitleLabel, attribute: .left, relatedBy: .equal, toItem: self.titleLabel, attribute: .left, multiplier: 1, constant: 0))
        self.mainButton.addConstraint(NSLayoutConstraint.init(item: subTitleLabel, attribute: .width, relatedBy: .equal, toItem: self.titleLabel, attribute: .width, multiplier: 1, constant: 0))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[timelineNode(16)]-4-[timeline]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: mainButton, attribute: .top, relatedBy: .equal, toItem: self.timelineNode, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: mainButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -16))
        self.mainButton.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerViewTop(==spacerViewBottom)][titleLabel]-2-[subTitleLabel][spacerViewBottom(==spacerViewTop)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mainButton.addConstraint(NSLayoutConstraint.init(item: dateLabel, attribute: .centerY, relatedBy: .equal, toItem: self.titleLabel, attribute: .centerY, multiplier: 1, constant: 0))
        self.mainButton.addConstraint(NSLayoutConstraint.init(item: dateLabel, attribute: .height, relatedBy: .equal, toItem: self.titleLabel, attribute: .height, multiplier: 1, constant: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.timelineNode.layer.cornerRadius = self.timelineNode.frame.width/2
        self.mainButton.roundCorners(corners: [.topRight, .bottomLeft, .bottomRight], radius: 10)
    }
    
    func configure(object: NSManagedObject?, isLast: Bool){
        //TODO: Using static data for demo purposes. Journey class has not been implemented yet
        self.mainButton.setImage(UIImage(named: "homeTableHeaderBackground"), for: .normal)
        self.timelineNode.image = UIImage(named: "homeTableHeaderBackground")
        self.timeline.isHidden = isLast
        self.titleLabel.text = "Basics"
        self.subTitleLabel.text = "Session 2 of 10"
        if isLast{
            self.subTitleLabel.text = "Session 1 of 10"
        }
        self.dateLabel.text = "Jul 24"
    }
    
    //Button Delegate
    func mainButtonPressed(sender: UIButton){
        self.profileCompletedCellDelegate.relayDidPressJourneyButton(sender: sender)
    }
}
