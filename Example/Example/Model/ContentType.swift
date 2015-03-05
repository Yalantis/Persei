// For License please refer to LICENSE file in the root of Persei project

import Foundation

import UIKit

enum ContentType: String, Printable {
    case Music = "content_music"
    case Films = "content_films"

    func next() -> ContentType {
        switch self {
        case .Music:
            return .Films
        case .Films:
            return .Music
        }
    }
    
    var image: UIImage {
        return UIImage(named: rawValue)!
    }
    
    var description: String {
        switch self {
        case .Music:
            return "Music"
        case .Films:
            return "Films"
        }
    }
}