//
//  ViewController_MVVM.swift
//  XMRxSwift
//
//  Created by 梁小迷 on 16/8/19.
//  Copyright © 2019年 mifit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import CLToast


class ViewController_MVVM: UIViewController {
 
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var requestVerifyCodeBtn: UIButton!
    @IBOutlet weak var loginBtn: BlueBGBtn!
    
    var signUpVM: ViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signUpVM = ViewModel(phone: phoneNum.rx.text.orEmpty.asObservable(), vCode: verifyCode.rx.text.orEmpty.asObservable(), pwd: password.rx.text.orEmpty.asObservable(), vTap: requestVerifyCodeBtn.rx.controlEvent([.touchUpInside]).asObservable(), lTap: loginBtn.rx.controlEvent([.touchUpInside]).asObservable())
        self .rxHandle()
    }
    
    func rxHandle() {
        signUpVM?.dealRxHandle()
        
        // 获取验证码可点击监听
        signUpVM?.verifyCodeEnable?.subscribe(onNext: { [weak self](enable) in
            self?.requestVerifyCodeBtn.isEnabled = enable
        }).disposed(by: disposeBag)
        
        
        // 登录按钮可点状态监听
        signUpVM?.loginEnable?.subscribe(onNext: { [weak self](enable) in
            self?.loginBtn.isEnabled = enable
        }).disposed(by: disposeBag)
        
        // 登录结果
        signUpVM?.loginResult?.subscribe(onNext: { (str) in
            print("登录结果： "+str)
        }).disposed(by: disposeBag)
        
        // 获取验证码结果
        signUpVM?.verifyCodeResult?.subscribe(onNext: { (str) in
            print("验证码结果： "+str)
        }).disposed(by: disposeBag)
    }
    
}
