//
//  HSNavigationController.swift
//  Headspace
//
//  Created by Justin Wells on 7/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HSNavigationController: UINavigationController{
    
    override func viewDidLoad() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = HSColor.faintGray
        self.navigationBar.tintColor = .darkGray
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin), NSForegroundColorAttributeName: UIColor.darkGray]
    }
}
