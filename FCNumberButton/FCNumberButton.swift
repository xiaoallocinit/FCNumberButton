//
//  FCNumberButton.swift
//  FCNumberButton
//
//  Created by 肖志斌 on 2019/8/29.
//  Copyright © 2019 肖志斌. All rights reserved.
//

import UIKit

/// 定义一个闭包
public typealias ResultClosure = (_ number: String)->()

public protocol FCNumberButtonDelegate: NSObjectProtocol {
    func numberButtonResult(_ numberButton: FCNumberButton, number: String)
}
open class FCNumberButton: UIView {
    weak var delegate: FCNumberButtonDelegate?  // 代理
    var numberResultClosure: ResultClosure?     // 闭包
    var decreaseBtn: UIButton!     // 减按钮
    var increaseBtn: UIButton!     // 加按钮
    var textField: UITextField!    // 数量展示/输入框
    var timer: Timer!              // 快速加减定时器
    public var _minValue = 1                 // 最大值
    public var _maxValue = Int.max           // 最大值
    public var shakeAnimation: Bool = false  // 是否打开抖动动画
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        //整个控件的默认尺寸(和某宝上面的按钮同样大小)
        if frame.isEmpty {self.frame = CGRect(x: 0, y: 0, width: 110, height: 30)}
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    //设置UI布局
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 3.0
        clipsToBounds = true
        
        decreaseBtn = setupButton(title: "－")
        increaseBtn = setupButton(title: "＋")
        
        textField = UITextField.init()
        textField.text = "1"
        textField.font = UIFont.boldSystemFont(ofSize: 15)
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textAlignment = NSTextAlignment.center
        self.addSubview(textField)
    }
    // MARK: - 重新布局UI
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let height = frame.size.height
        let width = frame.size.width
        decreaseBtn.frame = CGRect(x: 0, y: 0, width: height, height: height)
        increaseBtn.frame = CGRect(x: width - height, y: 0, width: height, height: height)
        textField.frame = CGRect(x: height, y: 0, width: width - 2.0*height, height: height)
    }
    
    //设置加减按钮的公共方法
    fileprivate func setupButton(title:String) -> UIButton {
        let button = UIButton.init();
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(UIColor.gray, for: UIControl.State())
        button.addTarget(self, action:#selector(self.touchDown(_:)) , for: UIControl.Event.touchDown)
        button.addTarget(self, action:#selector(self.touchUp) , for:UIControl.Event.touchUpOutside)
        button.addTarget(self, action:#selector(self.touchUp) , for:UIControl.Event.touchUpInside)
        button.addTarget(self, action:#selector(self.touchUp) , for:UIControl.Event.touchCancel)
        self.addSubview(button)
        return button
    }
    
    // MARK: - 加减按钮点击响应
    //点击按钮: 单击逐次加减,长按连续加减
    @objc fileprivate func touchDown(_ button: UIButton) {
        textField.endEditing(false)
        if button == decreaseBtn {
            timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.decrease), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.increase), userInfo: nil, repeats: true)
        }
        timer.fire()
    }
    
    //松开按钮:清除定时器
    @objc fileprivate func touchUp()  {
        cleanTimer()
    }
    
    // MARK: - 减运算
    @objc fileprivate func decrease() {
        if (textField.text?.count)! == 0 || Int(textField.text!)! <= _minValue {
            textField.text = "\(_minValue)"
        }
        
        let number = (Int(textField.text!)! - 1)
        if number >= _minValue {
            textField.text = "\(number)"
            
            //闭包回调
            numberResultClosure?("\(number)")
            //delegate的回调
            delegate?.numberButtonResult(self, number: "\(number)")
        } else {
            //添加抖动动画
            if shakeAnimation {shakeAnimationFunc()}
            print("数量不能小于\(_minValue)")
        }
    }
    
    // MARK: - 加运算
    @objc fileprivate func increase() {
        if (textField.text?.count)! == 0 || Int(textField.text!)! <= _minValue {
            textField.text = "\(_minValue)"
        }
        let number = (Int(textField.text!)! + 1)
        
        if number <= _maxValue {
            textField.text = "\(number)";
            //闭包回调
            numberResultClosure?("\(number)")
            //delegate的回调
            delegate?.numberButtonResult(self, number: "\(number)")
        } else {
            //添加抖动动画
            if shakeAnimation {shakeAnimationFunc()}
            print("已超过最大数量\(_maxValue)");
        }
        
        
    }
    
    // MARK: - 抖动动画
    fileprivate func shakeAnimationFunc() {
        let animation = CAKeyframeAnimation.init(keyPath: "position.x")
        //获取当前View的position坐标
        let positionX = layer.position.x
        //设置抖动的范围
        animation.values = [(positionX-10),(positionX),(positionX+10)]
        //动画重复的次数
        animation.repeatCount = 3
        //动画时间
        animation.duration = 0.07
        //设置自动反转
        animation.autoreverses = true
        //将动画添加到layer
        layer.add(animation, forKey: nil)
    }
    
    fileprivate func cleanTimer() {
        if ((timer?.isValid) != nil) {
            timer.invalidate()
            timer = nil;
        }
    }
    
    deinit {
        cleanTimer()
    }
    
}

extension FCNumberButton: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count)! == 0 || Int(textField.text!)! < _minValue {
            textField.text = "\(_minValue)"
        }
        if Int(textField.text!)! > _maxValue {
            textField.text = "\(_maxValue)"
        }
        //闭包回调
        numberResultClosure?("\(textField.text!)")
        //delegate的回调
        delegate?.numberButtonResult(self, number: "\(textField.text!)")
        
    }
    
}

// MARK: - 自定义UI接口
public extension FCNumberButton {
    
    /**
     输入框中的内容
     */
    var currentNumber: String? {
        get {
            return (textField.text!)
        }
        set {
            textField.text = newValue
        }
    }
    /**
     设置最小值
     */
    var minValue: Int {
        get {
            return _minValue
        }
        set {
            _minValue = newValue
            textField.text = "\(newValue)"
        }
    }
    /**
     设置最大值
     */
    var maxValue: Int {
        get {
            return _maxValue
        }
        set {
            _maxValue = newValue
        }
    }
    
    /**
     加减按钮的响应闭包回调
     */
    func numberResult(_ finished: @escaping ResultClosure) {
        numberResultClosure = finished
    }
    
    /**
     输入框中的字体属性
     */
    func inputFieldFont(_ inputFieldFont: UIFont) {
        textField.font = inputFieldFont;
    }
    
    /**
     加减按钮的字体属性
     */
    func buttonTitleFont(_ buttonTitleFont: UIFont) {
        increaseBtn.titleLabel!.font = buttonTitleFont;
        decreaseBtn.titleLabel!.font = buttonTitleFont;
    }
    
    /**
     设置按钮的边框颜色
     */
    func borderColor(_ borderColor: UIColor) {
        layer.borderColor = borderColor.cgColor;
        decreaseBtn.layer.borderColor = borderColor.cgColor;
        increaseBtn.layer.borderColor = borderColor.cgColor;
        
        layer.borderWidth = 0.5;
        decreaseBtn.layer.borderWidth = 0.5;
        increaseBtn.layer.borderWidth = 0.5;
    }
    
    //注意:加减号按钮的标题和背景图片只能设置其中一个,若全部设置,则以最后设置的类型为准
    
    /**
     设置加/减按钮的标题
     
     - parameter decreaseTitle: 减按钮标题
     - parameter increaseTitle: 加按钮标题
     */
    func setTitle(decreaseTitle: String, increaseTitle: String) {
        decreaseBtn.setBackgroundImage(nil, for: UIControl.State())
        increaseBtn.setBackgroundImage(nil, for: UIControl.State())
        
        decreaseBtn.setTitle(decreaseTitle, for: UIControl.State())
        increaseBtn.setTitle(increaseTitle, for: UIControl.State())
    }
    
    /**
     设置加/减按钮的背景图片
     
     - parameter decreaseImage: 减按钮背景图片
     - parameter increaseImage: 加按钮背景图片
     */
    func setImage(decreaseImage: UIImage, increaseImage: UIImage) {
        decreaseBtn.setTitle(nil, for: UIControl.State())
        increaseBtn.setTitle(nil, for: UIControl.State())
        
        decreaseBtn.setBackgroundImage(decreaseImage, for: UIControl.State())
        increaseBtn.setBackgroundImage(increaseImage, for: UIControl.State())
    }
    
}
