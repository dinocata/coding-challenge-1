import UIKit

enum Colors {
    case background
    case container
    
    var color: UIColor {
        switch self {
        case .background: return .systemBackground
        case .container: return .secondarySystemBackground
        }
    }
}
