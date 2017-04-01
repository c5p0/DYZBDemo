//
//  PageTitleView.swift
//  DouYuDemo
//  头部滚动View
//  Created by duxiaoqiang on 17/1/11.
//  Copyright © 2017年 professional. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate: class{
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
}
private let kscrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (51, 51, 51)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 153, 0)
private var currentIndex : Int = 0
class PageTitleView: UIView {
    
    weak var delegate : PageTitleViewDelegate?
    //MARK: - 定义一些属性
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLineLabel: UILabel = {
        let scrollLineLabel = UILabel()
        return scrollLineLabel
    }()
    // 存放多个titleLabel
    fileprivate var titleLabels : [UILabel] = [UILabel]()
    fileprivate var titles: [String]
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension PageTitleView {
    fileprivate func setupUI(){
        addSubview(scrollView)
        scrollView.frame = bounds
        // 1. 添加UILabel
        setupTitleLabel()
        // 2. 添加scrollview底部横线
        setupScrollLine()
        
    }
    
    private func setupTitleLabel(){
        let labelW  = bounds.width / CGFloat(4)
        let labelH  = bounds.height - kscrollLineH
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated(){
            let labelX = CGFloat(index) * labelW
            let label = UILabel()
            label.tag = index
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: 85, g: 85, b: 85)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabelClick(_:))))
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
    }
    
    private func setupScrollLine(){
        // 添加底部灰线
        let kGrayLineH : CGFloat = 0.5
        let grayLabel = UILabel()
        grayLabel.backgroundColor = UIColor.gray
        grayLabel.frame = CGRect(x: 0, y: bounds.height - kGrayLineH, width: bounds.width, height: kGrayLineH)
        addSubview(grayLabel)
        
        // 添加底部黄色线
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: 255, g: 128, b: 0)
        scrollLineLabel.backgroundColor = UIColor(r: 255, g: 128, b: 0)
        scrollLineLabel.frame = CGRect(x: 0, y: bounds.height - kscrollLineH, width:firstLabel.bounds.width, height: kscrollLineH)
        addSubview(scrollLineLabel)
        
    }
}


//MARK: - label的点击
extension PageTitleView{
    @objc fileprivate func tapLabelClick(_ tapGes : UITapGestureRecognizer){
        guard let currentLabel = tapGes.view as? UILabel else{return}
        // 获取旧的label
        let oldLabel = titleLabels[currentIndex]
        // 设置label颜色
        currentLabel.textColor = UIColor.orange
        oldLabel.textColor = UIColor.darkGray
        currentIndex = currentLabel.tag
        // 设置滚动线位置
        let scrollLineX = CGFloat(currentLabel.tag) * oldLabel.bounds.width
        UIView.animate(withDuration: 0.25, animations:{
            self.scrollLineLabel.frame.origin.x = scrollLineX
        });
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

//MARK: - 对外部暴露的方法
extension PageTitleView{
    func setCurrentIndex(progress : CGFloat, sourceIndex : Int, targetIndex : Int){
        // 移动黄色角标
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        let marginW = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = marginW * progress
        scrollLineLabel.frame.origin.x = sourceLabel.frame.origin.x  + moveX
        
        // 设置渐变颜色
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        print(kSelectColor.2 - colorDelta.2 * progress);
        print(kSelectColor.1 - colorDelta.1 * progress);
        print(kSelectColor.2 - colorDelta.2 * progress);
        
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        currentIndex = targetIndex
    }
}
