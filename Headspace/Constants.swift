//
//  Constants.swift
//  Headspace
//
//  Created by Justin Wells on 7/21/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

//Custom Colors
struct HSColor{
    static let primary = UIColorFromRGB(0xF47D31)
    static let secondary = UIColorFromRGB(0x5A6175)
    static let tertiary = UIColorFromRGB(0x559AD1)
    static let quaternary = UIColorFromRGB(0xF5F3EE)
    static let faintGray = UIColor(white: 0.95, alpha: 1)
    static let mustard = UIColorFromRGB(0xFFDEA6)
}

public func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//Test User Credentials
var testUserEmail = "johnsmith@gmail.com"
var testUserPassword = "password1"

//Database Constants
let headspaceDatabase = "HSHeadspace"
let usersDatabase = "HSUsers"
let packsDatabase = "HSPacks"
let singlesDatabase = "HSSingles"
let minisDatabase = "HSMinis"
let animationsDatabase = "HSAnimations"
let plansDatabase = "HSPlans"

//Arrays
var discoverSegmentedTitles = ["packs".localized().uppercased(), "singles".localized().uppercased(), "minis".localized().uppercased(), "kids".localized().uppercased(), "animations".localized().uppercased()]
var profileSegmentedTitles = ["myStats".localized().uppercased(), "myJourney".localized().uppercased()]

//Feature Not Available
public func featureUnavailableAlert() -> UIAlertController{
    //Show Alert that this feature is not available
    let alert = UIAlertController(title: "sorry".localized(), message: "featureUnavailableMessage".localized(), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
    return alert
}

//Masking Views
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
