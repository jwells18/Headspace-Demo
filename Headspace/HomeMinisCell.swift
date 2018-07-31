//
//  HomeMinisCell.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

protocol HomeMinisCellDelegate {
    func didPressHomeMinisCell(sectionIndexPath: IndexPath?, indexPath: IndexPath)
}

class HomeMinisCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HomeMinisCollectionCellDelegate{
    
    var homeMinisCellDelegate: HomeMinisCellDelegate!
    private let cellIdentifier = "cell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    var pageControl = UIPageControl()
    var minis = [NSManagedObject]()
    
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
        self.clipsToBounds = false
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Page Control
        self.setupPageControl()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCollectionView(){
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(HomeMinisCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupPageControl(){
        self.pageControl.currentPageIndicatorTintColor = HSColor.secondary
        self.pageControl.pageIndicatorTintColor = .lightGray
        self.pageControl.currentPage = 0
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.pageControl)
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = true
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerView)
        
        let viewDict = ["collectionView": collectionView, "pageControl": pageControl, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageControl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView(126@750)][spacerView][pageControl(20@750)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(minis: [NSManagedObject]?){
        if minis != nil{
            self.minis = minis!
            self.pageControl.numberOfPages = Int(ceil(Double(Double(self.minis.count)/Double(3))))
            self.collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(ceil(Double(Double(self.minis.count)/Double(3))))
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeMinisCollectionCell
        cell.homeMinisCollectionCellDelegate = self
        let startingIndex = indexPath.item*3
        let endingIndex = startingIndex+3
        
        //TODO: Fix this algorithm
        let minisArray = Array(self.minis[safe: startingIndex..<endingIndex]!)
        cell.configure(minis: minisArray)
        return cell
    }
    
    //CollectionView Delegate
    func relayDidPressHomeMinisCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        let sectionIndexPath = self.collectionView.indexPath(for: cell)
        self.homeMinisCellDelegate.didPressHomeMinisCell(sectionIndexPath: sectionIndexPath, indexPath: indexPath)
    }
    
    //ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.collectionView){
            //Change SegmentedControl index to match CollectionView index
            let pageWidth = scrollView.frame.size.width;
            let page = Int(scrollView.contentOffset.x / pageWidth)
            self.pageControl.currentPage = page
        }
    }
}

extension Array {
    subscript(safe range: Range<Index>) -> ArraySlice<Element>? {
        if range.upperBound > endIndex {
            if range.lowerBound >= endIndex {return nil}
            else {return self[range.lowerBound..<endIndex]}
        }
        else {
            return self[range]
        }
    }
}
