//
//  HSReachabilityView.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HSReachabilityView: UIView{
    
    var circularView = UIView()
    var titleLabel = UILabel()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        //Setup CircularView
        self.setupCircularView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCircularView(){
        self.circularView.backgroundColor = HSColor.primary
        self.circularView.clipsToBounds = true
        self.circularView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.circularView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.text = "noInternetConnection".localized().uppercased()
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupConstraints(){
        let viewDict = ["circularView": self.circularView, "titleLabel": titleLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[circularView(16)]-12-[titleLabel]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-34-[circularView(16)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self.circularView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circularView.layer.cornerRadius = self.circularView.frame.width/2
    }
}
