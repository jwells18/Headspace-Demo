//
//  SinglesMinisIntroView.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class SinglesMinisIntroView: UIView{
    
    var cancelButton = UIButton()
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var mainButton = UIButton()
    var mainSubButton = UIButton()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        //Setup ImageView
        self.setupImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitleLabel
        self.setupSubTitleLabel()
        
        //Setup Cancel Button
        self.setupCancelButton()
        
        //Setup Main Button
        self.setupMainButton()
        
        //Setup MainSub Button
        self.setupMainSubButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        self.imageView.backgroundColor = .lightGray
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = .darkGray
        self.subTitleLabel.textAlignment = .center
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
        self.subTitleLabel.numberOfLines = 0
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
    }
    
    func setupCancelButton(){
        self.cancelButton.backgroundColor = .white
        self.cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        self.cancelButton.tintColor = HSColor.secondary
        self.cancelButton.clipsToBounds = true
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cancelButton)
    }
    
    func setupMainButton(){
        self.mainButton.setTitleColor(.white, for: .normal)
        self.mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.mainButton.backgroundColor = HSColor.secondary
        self.mainButton.clipsToBounds = true
        self.mainButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainButton)
    }
    
    func setupMainSubButton(){
        self.mainSubButton.setTitleColor(HSColor.secondary, for: .normal)
        self.mainSubButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.mainSubButton.backgroundColor = HSColor.quaternary
        self.mainSubButton.isHidden = true
        self.mainSubButton.clipsToBounds = true
        self.mainSubButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainSubButton)
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerView)
        
        let viewDict = ["imageView": imageView, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "cancelButton": cancelButton, "mainButton": mainButton, "mainSubButton": mainSubButton, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[titleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[subTitleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancelButton(40)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainSubButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]-100-[titleLabel]-20-[subTitleLabel][spacerView][mainSubButton(60)][mainButton(60)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[cancelButton(40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 0.7, constant: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.width/2
    }
    
    func configure(singleMini: NSManagedObject?){
        if singleMini?.value(forKey: "image") != nil{
            self.imageView.sd_setImage(with: URL(string: singleMini?.value(forKey: "image") as? String ?? ""), completed: nil)
        }
        else{
            self.imageView.image = UIImage()
        }
        self.titleLabel.text = singleMini?.value(forKey: "name") as? String
        
        self.subTitleLabel.text = singleMini?.value(forKey: "details") as? String
        if singleMini?.value(forKey: "isPremium") as? NSNumber == 0{
            self.mainButton.setTitle("startNow".localized().uppercased(), for: .normal)
        }
        else{
            self.mainButton.setTitle("subscribeToUnlock".localized().uppercased(), for: .normal)
        }
        let introductionLengths = singleMini?.value(forKey: "introductionLengths") as? String
        if (introductionLengths != nil && introductionLengths != "") {
            self.mainSubButton.isHidden = false
            self.mainSubButton.setTitle(String(format: "%@ (%@ %@)", "introduction".localized().uppercased(), introductionLengths!, "min".localized().uppercased()), for: .normal)
        }
        else{
            self.mainSubButton.isHidden = true
            self.mainSubButton.setTitle("", for: .normal)
        }
        
    }
}
