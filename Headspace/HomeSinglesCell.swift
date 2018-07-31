//
//  HomeSinglesCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HomeSinglesCell: UICollectionViewCell{
    
    var mainImageView = UIImageView()
    var titleLabel = UILabel()
    var accessoryImageView = UIImageView()
    var separatorViewTop = UIView()
    var separatorViewBottom = UIView()
    
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
        
        //Setup Main ImageView
        self.setupMainImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Accessory ImageView
        self.setupAccessoryImageView()
        
        //Setup Separator Views
        self.setupSeparatorViews()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupMainImageView(){
        self.mainImageView.image = UIImage(named: "viewAllSingles")
        self.mainImageView.backgroundColor = HSColor.quaternary
        self.mainImageView.clipsToBounds = true
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainImageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.text = "viewAllSingles".localized()
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupAccessoryImageView(){
        self.accessoryImageView.image = UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate)
        self.accessoryImageView.tintColor = HSColor.quaternary
        self.accessoryImageView.clipsToBounds = true
        self.accessoryImageView.layer.cornerRadius = 5
        self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.accessoryImageView)
    }
    
    func setupSeparatorViews(){
        let separators = [self.separatorViewTop, self.separatorViewBottom]
        for separator in separators{
            separator.backgroundColor = HSColor.quaternary
            separator.isUserInteractionEnabled = false
            separator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(separator)
        }
    }
    
    func setupConstraints(){
        let viewDict = ["mainImageView": mainImageView, "titleLabel": titleLabel, "accessoryImageView": accessoryImageView, "separatorViewTop": separatorViewTop, "separatorViewBottom": separatorViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[mainImageView(70)]-30-[titleLabel]-30-[accessoryImageView(30)]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorViewTop]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorViewBottom]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[mainImageView]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: self.titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.accessoryImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: accessoryImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        self.addConstraints([NSLayoutConstraint.init(item: self.separatorViewTop, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.separatorViewTop, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2)])
        self.addConstraints([NSLayoutConstraint.init(item: self.separatorViewBottom, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: self.separatorViewBottom, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.width/2
    }
}
