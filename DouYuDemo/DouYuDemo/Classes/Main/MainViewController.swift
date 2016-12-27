//
//  MainViewController.swift
//  DouYuDemo
//
//  Created by duxiaoqiang on 16/12/27.
//  Copyright © 2016年 professional. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildController(vcName: "Home");
        addChildController(vcName: "Live");
        addChildController(vcName: "Care");
        addChildController(vcName: "Profile");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addChildController(vcName :String)
    {
        let vc  = UIStoryboard(name: vcName, bundle: nil).instantiateInitialViewController()!;
        addChildViewController(vc);
    }

}
