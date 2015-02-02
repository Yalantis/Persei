//
// Created by zen on 31/01/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation

@objc
public protocol MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) -> Void
}
