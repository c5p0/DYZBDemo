//
//  HomeViewController.swift
//  DouYuDemo
//
//  Created by duxiaoqiang on 17/1/11.
//  Copyright © 2017年 professional. All rights reserved.
//

import UIKit

private let kPageTitleH : CGFloat = 40
class HomeViewController: UIViewController {
    
    //MARK: - lazy
    fileprivate lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame: CGRect = CGRect(x: 0, y: kStatusH + kNavigationH, width: kScreenW, height: kPageTitleH)
        let titles: [String] = ["推荐","游戏","娱乐","瞎玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    fileprivate lazy var pageContentView: PageContentView = {[weak self] in
        let contentH = kScreenH - kStatusH - kNavigationH - kPageTitleH
        let contentFrame = CGRect(x: 0, y:kStatusH + kNavigationH + kPageTitleH, width: kScreenW, height: contentH)
        // 初始化子控制器
        var childVcs: [UIViewController] = [UIViewController]()
        for _ in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childvcs: childVcs, parentVc: self)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


//MARK: - 设置ui
extension HomeViewController{
    fileprivate func setupUI(){
        // UIScrollView 在导航栏存在下默认有一个内边距
        automaticallyAdjustsScrollViewInsets = false
        // 1. 初始化导航栏
        setupNavigationBar()
        // 2. 添加PageTitleView
        view.addSubview(pageTitleView)
        // 3. 添加PageContentView
        view.addSubview(pageContentView)
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


//MARK: - PageTitleDelegate
extension HomeViewController: PageTitleViewDelegate{
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setPageContentOffset(index: index)
    }
}

//MARK: - PageContentViewDelegate
extension HomeViewController: PageContentViewDelegate{
    func pageContentView(_ pageContentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setCurrentIndex(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK: - 网络
extension HomeViewController
{

}
