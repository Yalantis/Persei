// For License please refer to LICENSE file in the root of Persei project

import Foundation

@objc public protocol MenuViewDelegate {
    
    func menu(_ menu: MenuView, didSelectItemAt index: Int) -> Void
}
