//
//  ViewController.swift
//  FCNumberButton
//
//  Created by 肖志斌 on 2019/8/29.
//  Copyright © 2019 肖志斌. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let numberButton = FCNumberButton.init(frame: CGRect(x: 100, y: 300, width: 100, height: 30))
        
        //设置加减按钮的自定义图片
        numberButton.setImage(decreaseImage: UIImage.init(named: "fjl_join_minus")!, increaseImage: UIImage.init(named: "fjl_join_add")!)
        
        //开启抖动动画
        numberButton.shakeAnimation = true
        //加减按钮的闭包回调
        numberButton.numberResult { (number) in
            
            print(number)
        }
        
        view.addSubview(numberButton)
    }


}

