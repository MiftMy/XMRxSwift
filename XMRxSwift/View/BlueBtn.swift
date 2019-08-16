//
//  BlueBtn.swift
//  XMRxSwift
//
//  Created by 梁小迷 on 15/8/19.
//  Copyright © 2019年 mifit. All rights reserved.
//

import UIKit

class BlueBtn: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.defaultState()
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        self.defaultState()
    }
    
    func defaultState () {
        self.setTitleColor(UIColor.blue, for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .disabled)
    }
}
