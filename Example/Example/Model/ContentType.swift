//
//  Copyright © 2014 Yalantis
//

import Foundation

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
    
    var description: String {
        switch self {
        case .Music:
            return "Music"
        case .Films:
            return "Films"
        }
    }
}