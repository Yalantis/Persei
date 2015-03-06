// For License please refer to LICENSE file in the root of Persei project

import Foundation

@objc
public protocol MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) -> Void
}
