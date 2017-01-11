//
//  UIBarButtonItem+Extension.swift
//  DouYuDemo
//
//  Created by duxiaoqiang on 17/1/11.
//  Copyright © 2017年 professional. All rights reserved.
//

import UIKit
extension UIBarButtonItem
{
    convenience init(imageName: String, highImageName: String = "",size: CGSize = CGSize.zero) {
        // 创建btn 
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        if highImageName != "" {
             btn.setImage(UIImage(named:highImageName), for: .highlighted)
        }
        if size == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView:btn)
    }
}
