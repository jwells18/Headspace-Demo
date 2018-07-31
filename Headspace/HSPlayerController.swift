//
//  HSPlayerController.swift
//  Headspace
//
//  Created by Justin Wells on 7/30/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class HSPlayerController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate{
    
    private let cellIdentifier = "cell"
    var object: NSManagedObject!
    var playerView = HSPlayerView()
    var sessions = 0
    var sessionLengths = [String]()
    
    convenience init(object: NSManagedObject?) {
        self.init()
        self.object = object
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
        
        //Setup Data
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin), NSForegroundColorAttributeName: UIColor.white]
        
        //Setup Navigation Items
        let title = self.object?.value(forKey: "name") as? String
        self.navigationItem.title = title?.uppercased()
        
        let infoButton = UIBarButtonItem(image: UIImage(named: "info"), style: .plain, target: self, action: #selector(infoButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem = infoButton
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain, target: self, action: #selector(cancelButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup Player View
        self.setupPlayerView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    func setupPlayerView(){
        self.playerView.collectionView.dataSource = self
        self.playerView.collectionView.delegate = self
        self.playerView.collectionView.register(HSPlayerCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.playerView.pickerView.dataSource = self
        self.playerView.pickerView.delegate = self
        self.playerView.configure(object: self.object)
        self.playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
    }
    
    func setupConstraints(){
        let viewDict = ["playerView": playerView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[playerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[playerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func setupData(){
        let sessionCount = self.object.value(forKey: "sessions") as? Int
        if sessionCount != nil{
            self.sessions = sessionCount!
            self.playerView.collectionView.reloadData()
        }
        
        let sessionLengthStringArray = self.object.value(forKey: "sessionLengths") as? String
        let sessionLengthArray = sessionLengthStringArray?.components(separatedBy: ",")
        if sessionLengthArray != nil{
            self.sessionLengths = sessionLengthArray!
            self.playerView.pickerView.reloadAllComponents()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessions
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let verticalInset = (collectionView.frame.height-200)/2
        let horizontalInset = (collectionView.frame.width-200)/2
        return UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.width-230)/2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HSPlayerCell
        return cell
    }
    
    //UIPicker DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sessionLengths.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleString = String(format: "%@ %@", sessionLengths[row], "min".localized().uppercased())
        let title = NSAttributedString(string: titleString, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 10),NSForegroundColorAttributeName:UIColor.white])
        return title
    }
    
    //PickerView Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    /*
    //ScrollView Delegates
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Scroll CollectionView cell into place when scrolling
        //NOTE: Enabling paging is preferred, but not possible given we want to show a preview of the next cell in the collectionView
        if scrollView == collectionView{
            let itemWidth = Float(collectionView.frame.width-60)
            let itemSpacing = Float(15)
            
            let pageWidth = Float(itemWidth + itemSpacing)
            let targetXContentOffset = Float(targetContentOffset.pointee.x)
            let contentWidth = Float(collectionView.contentSize.width  )
            var newPage = Float(self.pageControl.currentPage)
            
            if velocity.x == 0 {
                newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
            } else {
                newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
                if newPage < 0 {
                    newPage = 0
                }
                if (newPage > contentWidth / pageWidth) {
                    newPage = ceil(contentWidth / pageWidth) - 1.0
                }
            }
            
            self.pageControl.currentPage = Int(newPage)
            let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
            targetContentOffset.pointee = point
        }
    }*/
    
    //Button Delegates
    func cancelButtonPressed(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func infoButtonPressed(sender: UIButton){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
}
