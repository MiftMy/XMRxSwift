//
//  ViewController.swift
//  XMRxSwift
//
//  Created by 梁小迷 on 31/10/18.
//  Copyright © 2018年 mifit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import CLToast

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var requestVerifyCodeBtn: UIButton!
    @IBOutlet weak var loginBtn: BlueBGBtn!
    @IBOutlet weak var mvvmBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self .rxHandle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rxHandle() {
        
        // 获取验证码可点击监听
        self.phoneNum.rx.text.orEmpty.asObservable()
            .map { (str) -> Bool in
                return str.count == 11
            }
            .subscribe { (event) in
                self.requestVerifyCodeBtn.isEnabled = event.element!
        }
        
        // 登录按钮可点状态监听
        Observable.combineLatest(self.phoneNum.rx.text.orEmpty, self.verifyCode.rx.text.orEmpty, self.password.rx.text.orEmpty) {(str1, str2, str3) -> Bool in
            return str1.count == 11 && str2.count > 0 && str3.count >= 6
        }.bind(to: loginBtn.rx.isEnabled)
        .disposed(by: disposeBag)
        
        let loginInfo = Observable.combineLatest(self.phoneNum.rx.text.orEmpty.asObservable(), self.verifyCode.rx.text.orEmpty.asObservable(), self.password.rx.text.orEmpty.asObservable()) {($0, $1, $2)}
        
        //获取验证码
        requestVerifyCodeBtn.rx.tap.bind {
            [weak self] in
            self?.requestVerifyCode(phone: self?.phoneNum?.text)
        }.disposed(by: disposeBag)
        
        // 登录点击 方式一
//        loginBtn.rx.controlEvent([.touchUpInside]).asObservable().subscribe(onNext: { [weak self] in
//            self?.loginRequest()
//        }, onCompleted: {
//
//        }).disposed(by: disposeBag)
        
        /// 登录点击 方式二
        loginBtn.rx.controlEvent([.touchUpInside]).withLatestFrom(loginInfo).flatMap { (str1, str2, str3) -> Observable<String> in
            guard str1.count == 11 else {
                return Observable.just("密码位数不对")
            }
            guard str2.count > 0 else {
                return Observable.just("验证码为空")
            }
            guard str3.count >= 6 else {
                return Observable.just("密码少于6位")
            }
            return Observable.create({ (observer) -> Disposable in
                // 登录请求
                //...
                HUD.show(.progress)
                
                // 返回结果
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    observer.onNext("登录的结果")
                    observer.onCompleted()
                    HUD.hide()
                })
                return Disposables.create()
            })
        }.subscribe(onNext: { (result) in
            print("登录结果:"+result)
        }).disposed(by: disposeBag)
        
        mvvmBtn.rx.tap.bind {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController_MVVM")
            self .present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    func requestVerifyCode (phone: String?) {
        if let temPhone = phone {
            print("请求验证码 : "+temPhone)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            CLToast.cl_show(msg: "验证码已发送")
        }
    }
    
    func loginRequest() -> Observable<String> {
        print("登录请求")
        return Observable.create({
            (observer) -> Disposable in
            let val = arc4random() % 100
            DispatchQueue(label: "mifit.networ.queue").asyncAfter(deadline: .now()+3, execute: {
                if val < 50 {
                    observer.onNext("ok")
                } else {
                    let err = NSError(domain: "ErrorDumain", code: 1, userInfo: ["msg": "错误信息"])
                    observer.onError(err)
                }
                observer.onCompleted()
            })
            
            return Disposables.create()
        })
    }
    
    func showAert(msg: String) {
        let alertController = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            print("你点了确定按钮")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            print("你点了取消按钮")
        }
        alertController.addAction(sureAction)
        alertController.addAction(cancelAction)
        alertController.show(self, sender: nil)
    }
}

