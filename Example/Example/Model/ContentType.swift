// For License please refer to LICENSE file in the root of Persei project

import UIKit

enum ContentType: String, CustomStringConvertible {
    
    case music = "content_music.png"
    case films = "content_films.png"

    func next() -> ContentType {
        switch self {
        case .music:
            return .films
        case .films:
            return .music
        }
    }
    
    var image: UIImage {
        let image =  UIImage(named: rawValue)!
        return image
    }
    
    var description: String {
        switch self {
        case .music:
            return "Music"
        case .films:
            return "Films"
        }
    }
}
