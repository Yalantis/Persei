// For License please refer to LICENSE file in the root of Persei project

import Foundation

import UIKit

enum ContentType: String, CustomStringConvertible {
    case Music = "content_music.png"
    case Films = "content_films.png"

    func next() -> ContentType {
        switch self {
        case .Music:
            return .Films
        case .Films:
            return .Music
        }
    }
    
    var image: UIImage {
        let image =  UIImage(named: rawValue)!
        return image
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