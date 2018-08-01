//
//  HomeHeaderCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol HomeHeaderCellDelegate {
    func didPressBeginButton(sender: UIButton)
}

class HomeHeaderCell: UICollectionViewCell{
    
    var homeHeaderCellDelegate: HomeHeaderCellDelegate!
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
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
        self.backgroundColor = .lightGray
        self.clipsToBounds = true
        
        //Setup ImageView
        self.setupImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup Main Button
        self.setupMainButton()
        
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
    
    func setupTitleLabel(){
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 44)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = .white
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 22)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
    }
    
    func setupMainButton(){
        self.mainButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "mainButton": mainButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30@750-[titleLabel]-30@750-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30@750-[subTitleLabel]-30@750-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[mainButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: subTitleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.titleLabel, attribute: .top, multiplier: 1, constant: -20)])
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint.init(item: mainButton, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 20)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainButton.layer.cornerRadius = self.mainButton.frame.height/2
    }
    
    func configure(pack: NSManagedObject?){
        if pack != nil{
            if pack?.value(forKey: "coverImage") != nil{
                self.imageView.sd_setImage(with: URL(string: pack?.value(forKey: "coverImage") as? String ?? ""), completed: nil)
            }
            else{
                self.imageView.image = UIImage()
            }
            self.titleLabel.text = pack?.value(forKey: "name") as? String ?? ""
            self.titleLabel.textColor = .white
            let sessions = pack?.value(forKey: "sessions") as? NSNumber ?? 0
            self.subTitleLabel.text = String(format: "%@ %@ %@ %@", "day".localized(), "1"/*pack.currentLevel*/, "of".localized(), sessions.stringValue)
            self.mainButton.configure(image: UIImage(named: "play"), title: "begin".localized().uppercased())
            self.mainButton.isHidden = false
        }
        else{
            //TODO: Finish implementation
            /*
            self.imageView.image = UIImage(named: "homeHeaderBackground")
            self.titleLabel.text = "readyForNextPack".localized()
            self.titleLabel.textColor = HSColor.primary
            self.subTitleLabel.text = ""
            self.mainButton.configure(image: nil, title: "discover".localized().uppercased())*/
            self.mainButton.isHidden = true
        }
    }
    
    //Button Delegates
    func mainButtonPressed(sender: UIButton){
        self.homeHeaderCellDelegate.didPressBeginButton(sender: sender)
    }
}
