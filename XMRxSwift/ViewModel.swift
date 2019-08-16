//
//  ViewModel.swift
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

class ViewModel {
    // 可以传入Observable；有其他用途，可传入传入rx。
    private let phoneRx: Observable<String>
    private let verifyCodeRx: Observable<String>
    private let passwordRx: Observable<String>
    private let loginBtnRx: Observable<()>
    private let verifyBtnRx: Observable<()>
    
    var verifyCodeEnable: Observable<Bool>?
    var loginEnable: Observable<Bool>?
    
    var loginResult: Observable<String>?
    var verifyCodeResult: Observable<String>?
    
    private let disposeBag = DisposeBag()
    
    required init(phone: Observable<String>, vCode: Observable<String>, pwd: Observable<String>, vTap: Observable<()>, lTap: Observable<()>) {
        phoneRx = phone
        verifyCodeRx = vCode
        passwordRx = pwd
        loginBtnRx = lTap
        verifyBtnRx = vTap
        
    }
    
    func dealRxHandle() {
        // 按钮使能逻辑
        verifyCodeEnable = phoneRx.asObservable().map { (str) -> Bool in
            return str.count == 11
        }
        
        // 按钮使能逻辑
        loginEnable = Observable.combineLatest( phoneRx, verifyCodeRx, passwordRx) {
            (str1, str2, str3) -> Bool in
            return str1.count == 11 && str2.count > 0 && str3.count >= 6
        }
        
        // 获取验证码
        verifyCodeResult = verifyBtnRx.withLatestFrom(phoneRx).flatMap {
            (str) -> Observable<String> in
            return self.verifyCodeAction(phone: str)
        }
        
        // 登录请求
        let loginInfo = Observable.combineLatest( phoneRx, verifyCodeRx, passwordRx) {($0, $1, $2)}
        loginResult = loginBtnRx.withLatestFrom(loginInfo).flatMap {
            (str1, str2, str3) -> Observable<String> in
            return self.loginAction(phone: str1, vCode: str2, pwd: str3)
        }
    }
    
    
    private func verifyCodeAction (phone: String) -> Observable<String> {
        return Observable.create({ (observer) -> Disposable in
            // 请求验证码
            // ...
            HUD.show(.progress)
            
            // 请求完毕回调
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                HUD.hide()
                observer.onNext("请求验证码结果")
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    private func loginAction (phone: String, vCode:String, pwd: String) -> Observable<String> {
        guard phone.count == 11 else {
            return Observable.just("密码位数不对")
        }
        guard vCode.count > 0 else {
            return Observable.just("验证码为空")
        }
        guard pwd.count >= 6 else {
            return Observable.just("密码少于6位")
        }
        return Observable.create({ (observer) -> Disposable in
            // 登录请求
            //...
            HUD.show(.progress)
            
            // 返回结果
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                HUD.hide()
                observer.onNext("登录的结果")
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}
