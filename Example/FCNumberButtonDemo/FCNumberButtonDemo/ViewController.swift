//
//  ViewController.swift
//  FCNumberButtonDemo
//
//  Created by 肖志斌 on 2019/8/30.
//  Copyright © 2019 肖志斌. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let numberButton = FCNumberButton.init(frame: CGRect(x: 100, y: 220, width: 150, height: 44))
        //设置加减按钮的标题
        numberButton.setTitle(decreaseTitle: "减", increaseTitle: "加")
        //设置加减按钮标题的字体大小
        numberButton.buttonTitleFont(UIFont.systemFont(ofSize: 15))
        //开启抖动动画
        numberButton.shakeAnimation = true
        //加减按钮的闭包回调
        numberButton.numberResult { (number) in
            
            print(number)
        }
        
        view.addSubview(numberButton)
    }


}

