//
//  HomePeopleCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class HomePeopleCell: UICollectionViewCell{
    
    var titleLabel = UILabel()
    
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
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTitleLabel(){
        self.titleLabel.textColor = HSColor.secondary
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 46)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupConstraints(){
        let viewDict = ["titleLabel": titleLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30@750-[titleLabel]-30@750-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(data: NSManagedObject?){
        if data != nil{
            let formatter = NumberFormatter()
            formatter.locale = NSLocale.current
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.usesGroupingSeparator = true
            let count = data?.value(forKey: "currentUserCount") as? NSNumber ?? 0
            self.titleLabel.text = formatter.string(from: count)
        }
    }
}
