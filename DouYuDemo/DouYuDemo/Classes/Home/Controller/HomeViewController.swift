//
//  HomeViewController.swift
//  DouYuDemo
//
//  Created by duxiaoqiang on 17/1/11.
//  Copyright © 2017年 professional. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


//MARK: - 设置ui
extension HomeViewController{
    fileprivate func setupUI(){
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"logo"), style: .plain, target: self, action: nil)
        let size = CGSize(width: 40, height: 40)
        let historyBarBtn = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let scanBarBtn = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        let searchBarBtn = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        navigationItem.rightBarButtonItems = [historyBarBtn,scanBarBtn,searchBarBtn]

    }
}


//MARK: - 网络
extension HomeViewController
{

}
