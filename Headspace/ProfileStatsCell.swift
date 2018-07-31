//
//  ProfileStatsCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class ProfileStatsCell: UICollectionViewCell{
    
    var headerImageView = UIImageView()
    var headerLabel = UILabel()
    var titleLabel = UILabel()
    
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
        
        //Setup Header ImageView
        self.setupHeaderImageView()
        
        //Setup Header Label
        self.setupHeaderLabel()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupHeaderImageView(){
        self.headerImageView.contentMode = .scaleAspectFill
        self.headerImageView.clipsToBounds = true
        self.headerImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerImageView)
    }
    
    func setupHeaderLabel(){
        self.headerLabel.textColor = .lightGray
        self.headerLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerLabel)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupConstraints(){
        let viewDict = ["headerImageView": headerImageView, "headerLabel": headerLabel, "titleLabel": titleLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[headerImageView(40)]-12-[headerLabel]-50-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[titleLabel]-50-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerImageView(40)]-12-[titleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: headerLabel, attribute: .centerY, relatedBy: .equal, toItem: self.headerImageView, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: headerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.headerImageView.layer.cornerRadius = self.headerImageView.frame.height/2
    }
    
    func configure(title: String?, user: NSManagedObject?){
        self.headerImageView.image = UIImage(named: title ?? "")
        self.headerLabel.text = title?.localized().uppercased()
        let totalMinutesMeditated = user?.value(forKey: "totalMinutesMeditated") as? NSNumber ?? 0
        let sessionsCompleted = user?.value(forKey: "sessionsCompleted") as? NSNumber ?? 0
        switch title{
        case _ where title == "totalTimeMeditated":
            let string = String(format: "%@  %@", totalMinutesMeditated.stringValue, "minutes".localized())
            let attributedString = NSMutableAttributedString(string: string, attributes:[NSForegroundColorAttributeName: HSColor.secondary])
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 50), range: NSMakeRange(0, totalMinutesMeditated.stringValue.characters.count))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 22), range: NSMakeRange(totalMinutesMeditated.stringValue.characters.count+2, "minutes".localized().characters.count))
            self.titleLabel.attributedText = attributedString
            break
        case _ where title == "sessionsCompleted":
            let string = String(format: "%@  %@", sessionsCompleted.stringValue, "sessions".localized())
            let attributedString = NSMutableAttributedString(string: string, attributes:[NSForegroundColorAttributeName: HSColor.secondary])
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 50), range: NSMakeRange(0, sessionsCompleted.stringValue.characters.count))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 22), range: NSMakeRange(sessionsCompleted.stringValue.characters.count+2, "sessions".localized().characters.count))
            self.titleLabel.attributedText = attributedString
            break
        case _ where title == "averageDuration":
            let averageDuration = Int(Double(totalMinutesMeditated)/Double(sessionsCompleted))
            let string = String(format: "%@  %@", String(averageDuration), "minutes".localized())
            let attributedString = NSMutableAttributedString(string: string, attributes:[NSForegroundColorAttributeName: HSColor.secondary])
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 50), range: NSMakeRange(0, String(averageDuration).characters.count))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 22), range: NSMakeRange(String(averageDuration).characters.count+2, "minutes".localized().characters.count))
            self.titleLabel.attributedText = attributedString
            break
        default:
            self.titleLabel.attributedText = nil
            break
        }
    }
}
