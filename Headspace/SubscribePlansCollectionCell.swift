//
//  SubscribePlansCollectionCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class SubscribePlansCollectionCell: UICollectionViewCell{
    
    var containerView = UIView()
    var headerLabel = UILabel()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var descriptionLabel = UILabel()
    
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
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        
        //Setup ContainerView
        self.setupContainerView()
        
        //Setup Header Label
        self.setupHeaderLabel()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup Description Label
        self.setupDescriptionLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupContainerView(){
        self.containerView.backgroundColor = HSColor.quaternary
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 5
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)
    }
    
    func setupHeaderLabel(){
        self.headerLabel.textColor = HSColor.quaternary
        self.headerLabel.textAlignment = .center
        self.headerLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.headerLabel.numberOfLines = 2
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.headerLabel)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.titleLabel)
    }
    
    func setupSubTitleLabel(){
        self.subTitleLabel.textColor = HSColor.secondary
        self.subTitleLabel.textAlignment = .center
        self.subTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.subTitleLabel)
    }
    
    func setupDescriptionLabel(){
        self.descriptionLabel.textColor = .gray
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 10)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.descriptionLabel)
    }
    
    func setupConstraints(){
        let spacerViewTop = UIView()
        spacerViewTop.isUserInteractionEnabled = false
        spacerViewTop.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(spacerViewTop)
        let spacerViewBottom = UIView()
        spacerViewBottom.isUserInteractionEnabled = false
        spacerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(spacerViewBottom)
        
        let viewDict = ["containerView": containerView, "headerLabel": headerLabel, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "descriptionLabel": descriptionLabel, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[containerView]-4-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subTitleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[descriptionLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[containerView]-4-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerLabel][spacerViewTop(==spacerViewBottom)][titleLabel]-[subTitleLabel]-[descriptionLabel][spacerViewBottom(==spacerViewTop)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(plan: Plan?){
        self.headerLabel.text = plan?.promotionalDetail.localized() ?? ""
        switch plan?.promotionalDetail ?? "" != ""{
        case true:
            self.headerLabel.backgroundColor = HSColor.secondary
        case false:
            self.headerLabel.backgroundColor = .clear
        }
        self.titleLabel.text = plan?.name.localized() ?? ""
        switch plan?.price != nil{
        case true:
            self.subTitleLabel.text = NSNumber(value: (plan?.price)!).currencyString(maxFractionDigits: 2)
        case false:
            self.subTitleLabel.text = ""
        }
        if plan?.period ?? 0 > 0{
            self.subTitleLabel.text?.append("*")
        }
        self.descriptionLabel.text = plan?.periodName.localized() ?? ""
    }
    
    override var isSelected: Bool{
        didSet{
            switch isSelected{
            case true:
                self.layer.borderColor = HSColor.primary.cgColor
                break
            case false:
                self.layer.borderColor = UIColor.white.cgColor
                break
            }
        }
    }
}

extension NSNumber{
    func currencyString(maxFractionDigits: Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = maxFractionDigits
        let currencyString = formatter.string(from: self)
        
        return currencyString!
    }
}

