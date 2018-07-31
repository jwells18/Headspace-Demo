//
//  RunStreakController.swift
//  Headspace
//
//  Created by Justin Wells on 7/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class RunStreakController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    private let cellIdentifier = "cell"
    var runStreakView = RunStreakView()
    var badges = ["activeBadge1", "badge3", "badge10", "badge15", "badge30", "badge90", "badge180", "badge365"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide NavigationBar
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupView(){
        self.view.backgroundColor = HSColor.quaternary
        
        //Setup RunStreak View
        self.setupRunStreakView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    func setupRunStreakView(){
        self.runStreakView.collectionView.dataSource = self
        self.runStreakView.collectionView.delegate = self
        self.runStreakView.collectionView.register(RunStreakCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.runStreakView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: .touchUpInside)
        self.runStreakView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(runStreakView)
    }
    
    func setupConstraints(){
        let viewDict = ["runStreakView": runStreakView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[runStreakView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[runStreakView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.width-240)/3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RunStreakCell
        //Setting manually for demo purposes
        cell.configure(image: UIImage(named: badges[indexPath.row]))
        return cell
    }
    
    //Button Delegates
    func cancelButtonPressed(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
