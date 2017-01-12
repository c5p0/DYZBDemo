//
//  PageContentView.swift
//  DouYuDemo
//
//  Created by duxiaoqiang on 17/1/12.
//  Copyright © 2017年 professional. All rights reserved.
//

import UIKit
protocol PageContentViewDelegate: class {
    func pageContentView(_ pageContentView : PageContentView, progress: CGFloat , sourceIndex : Int, targetIndex : Int)
}
private let contentCellId = "contentCellId"
private var forbidScrollFlag = false
class PageContentView: UIView {
    
    fileprivate lazy var collectionView: UICollectionView = {[weak self] in
        // 初始化一个布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 初始化一个UICollection
        let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectView.showsHorizontalScrollIndicator = false
        collectView.isPagingEnabled = true
        collectView.bounces = false
        collectView.dataSource = self
        collectView.delegate = self
        collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellId)
        return collectView
    }()
    weak var delegate : PageContentViewDelegate?
    // 子控制器
    fileprivate var childVcs: [UIViewController]
    // 记录开始滑动偏移量
    fileprivate var startOffSetX: CGFloat = 0
    // 父控制器(防止循环引用)
    fileprivate weak var parentVc:  UIViewController?
    init(frame: CGRect, childvcs: [UIViewController], parentVc: UIViewController?) {
        self.childVcs = childvcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - 初始化UI
extension PageContentView{
    fileprivate func setupUI(){
        // 把子控制器添加到父控制器里面
        for childVc in childVcs{
            parentVc?.addChildViewController(childVc)
        }
        // 添加一个CollectionView
        addSubview(collectionView)
        collectionView.frame = bounds
        
    }
}

//MARK: - UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellId, for: indexPath)
        // 循环引用移除多次在ContentView添加View
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        cell.contentView.addSubview(childVcs[indexPath.item].view)
        return cell
    }
}

extension PageContentView: UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffSetX = scrollView.contentOffset.x
        forbidScrollFlag = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if forbidScrollFlag{return}
        let currentOffSetX = scrollView.contentOffset.x
        // 原始位置角标
        var sourceIndex = 0
        // 目标位置角标
        var targetIndex = 0
        // 滑动进度
        var progress: CGFloat = 0
        let scrollViewW = scrollView.bounds.width
        // 左滑
        if currentOffSetX > startOffSetX{
            sourceIndex = Int(currentOffSetX / scrollViewW)
            targetIndex = sourceIndex + 1;
            
            if targetIndex >= childVcs.count{
               targetIndex = childVcs.count - 1
             }
            let ratio = currentOffSetX / scrollViewW
            progress = ratio - floor(ratio)
            if  currentOffSetX - startOffSetX == scrollViewW{
                progress = 1.0
                targetIndex = sourceIndex
            }
        }else{ // 右滑
            targetIndex = Int(currentOffSetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            let ratio = currentOffSetX / scrollViewW
            progress = CGFloat(1) - (ratio - floor(ratio))
        }
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK: - 暴露给外部用的方法
extension PageContentView{
    func setPageContentOffset(index : Int){
        forbidScrollFlag = true
        let offsetX = collectionView.bounds.width * CGFloat(index)
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
