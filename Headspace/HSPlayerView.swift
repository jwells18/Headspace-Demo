//
//  HSPlayerView.swift
//  Headspace
//
//  Created by Justin Wells on 7/30/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class HSPlayerView: UIView{
    
    var imageView = UIImageView()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var titleLabel = UILabel()
    var pickerView = UIPickerView()
    
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
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup PickerView
        self.setupPickerView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        self.imageView.backgroundColor = .white
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    func setupTitleLabel(){
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
    }
    
    func setupCollectionView(){
        self.collectionView.backgroundColor = .clear
        self.collectionView.bounces = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupPickerView(){
        self.pickerView.showsSelectionIndicator = false
        self.pickerView.tintColor = .white
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.pickerView)
    }
    
    func setupConstraints(){
        let spacerView1 = UIView()
        let spacerView2 = UIView()
        let spacerView3 = UIView()
        let spacerView4 = UIView()
        let spacerViews = [spacerView1, spacerView2, spacerView3, spacerView4]
        for spacer in spacerViews{
            spacer.isUserInteractionEnabled = false
            spacer.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(spacer)
        }
        
        let viewDict = ["imageView": self.imageView, "titleLabel": titleLabel, "collectionView": collectionView, "pickerView": pickerView, "spacerView1": spacerView1, "spacerView2": spacerView2, "spacerView3": spacerView3, "spacerView4": spacerView4] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: self.pickerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.pickerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerView1(==spacerView2)][titleLabel(50)][spacerView2(==spacerView3)][collectionView(200)][spacerView3(==spacerView4)][pickerView(100)][spacerView4(==spacerView1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(object: NSManagedObject?){
        if object?.value(forKey: "image") != nil{
            self.imageView.sd_setImage(with: URL(string: object?.value(forKey: "image") as? String ?? ""), completed: nil)
        }
        else{
            self.imageView.image = UIImage()
        }
    }
}
