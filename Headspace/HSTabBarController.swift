//
//  HSTabBarController.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HSTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = HSColor.primary
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch (tabBar.items?.index(of: item))! {
        case 1:
            let navVC = self.viewControllers?[1] as? HSNavigationController
            let discoverVC  = navVC?.viewControllers[0] as? DiscoverController
            if discoverVC?.discoverView.segmentedControl.selectedSegmentIndex == 4{
                discoverVC?.discoverView.backgroundColor = HSColor.secondary
                discoverVC?.discoverView.segmentedControl.backgroundColor = HSColor.secondary
                discoverVC?.discoverView.segmentedControl.selectionIndicatorColor = HSColor.primary
                discoverVC?.discoverView.segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.white]
                self.tabBar.barTintColor = HSColor.secondary
            }
            else{
                discoverVC?.discoverView.backgroundColor = HSColor.quaternary
                discoverVC?.discoverView.segmentedControl.backgroundColor = HSColor.quaternary
                discoverVC?.discoverView.segmentedControl.selectionIndicatorColor = HSColor.secondary
                discoverVC?.discoverView.segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: HSColor.secondary]
                self.tabBar.barTintColor = .white
            }
            break
        default:
            self.tabBar.barTintColor = .white
            self.tabBar.tintColor = HSColor.primary
            break
        }
    }
    
    func showDiscoverTab(segmentedIndex: Int){
        let navVC = self.viewControllers?[1] as? HSNavigationController
        let discoverVC  = navVC?.viewControllers[0] as? DiscoverController
        if discoverVC?.discoverView.collectionView.numberOfItems(inSection: 0) ?? 0 > segmentedIndex{
            discoverVC?.discoverView.segmentedControl.selectedSegmentIndex = segmentedIndex
            discoverVC?.discoverView.collectionView.scrollToItem(at: IndexPath(item: segmentedIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        else{
            let discoverVC = DiscoverController()
            let discoverNavVC = HSNavigationController.init(rootViewController: discoverVC)
            self.viewControllers?[1] = discoverNavVC
        }
        self.selectedIndex = 1
    }
}
