//
//  SinglesMinisIntroController.swift
//  Headspace
//
//  Created by Justin Wells on 7/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreData

class SinglesMinisIntroController: UIViewController{
    
    var singlesMinisIntroView = SinglesMinisIntroView()
    var singleMini: NSManagedObject!
    
    convenience init(singleMini: NSManagedObject?) {
        self.init()
        self.singleMini = singleMini
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup SinglesMinisIntro View
        self.setupSinglesMinisIntroView()
        
        //SetupConstraints
        self.setupConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupSinglesMinisIntroView(){
        self.singlesMinisIntroView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for:.touchUpInside)
        self.singlesMinisIntroView.mainButton.addTarget(self, action: #selector(mainButtonPressed(sender:)), for:.touchUpInside)
        self.singlesMinisIntroView.mainSubButton.addTarget(self, action: #selector(mainSubButtonPressed(sender:)), for:.touchUpInside)
        self.singlesMinisIntroView.configure(singleMini: self.singleMini)
        self.singlesMinisIntroView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(singlesMinisIntroView)
    }
    
    func setupConstraints(){
        let viewDict = ["singlesMinisIntroView": singlesMinisIntroView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[singlesMinisIntroView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[singlesMinisIntroView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //Button Delegates
    func cancelButtonPressed(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func mainButtonPressed(sender: UIButton){
        if singleMini.value(forKey: "isPremium") as? NSNumber == 0{
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
            /*
            let playerVC = HSPlayerController(object: singleMini)
            let navVC = UINavigationController(rootViewController: playerVC)
            self.present(navVC, animated: true)*/
        }
        else{
            let subscribeVC = SubscribeController()
            self.present(subscribeVC, animated: true)
        }
    }
    
    func mainSubButtonPressed(sender: UIButton){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
}
