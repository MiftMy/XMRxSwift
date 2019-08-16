//
//  BlueBGBtn.swift
//  XMRxSwift
//
//  Created by 梁小迷 on 15/8/19.
//  Copyright © 2019年 mifit. All rights reserved.
//

import UIKit

class BlueBGBtn: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.bgColorWithEnable(isEnabled)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    func defaultState() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.bgColorWithEnable(true)
    }
    
    func bgColorWithEnable(_ isEnable: Bool) {
        if isEnable {
            self.backgroundColor = UIColor.blue
        } else {
            self.backgroundColor = UIColor.lightGray
        }
    }
}
