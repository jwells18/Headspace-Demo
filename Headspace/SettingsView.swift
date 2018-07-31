//
//  SettingsView.swift
//  Headspace
//
//  Created by Justin Wells on 7/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class SettingsView: UIView{
    
    var tableView: UITableView!
    var tableViewFooter = SettingsViewTableFooter()
    
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
        
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTableView(){
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.tableView.backgroundColor = .white
        self.tableView.separatorInset = .zero
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableViewFooter.frame.size.height = 60
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.tableView)
    }
    
    func setupConstraints(){
        let viewDict = ["tableView": self.tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
