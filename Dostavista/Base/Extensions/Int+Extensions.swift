//
//  Int+Extensions.swift
//  Helpers
//
//  Created by Abylaikhan Abilkayr on 05.11.2025.
//

import Foundation
import UIKit

extension Int {

    private var designSize: CGSize { CGSize(width: 390, height: 844) } /// Надо указать размер по дизайну
    
    private var screenSize: CGSize { UIScreen.main.bounds.size }
    
    var fitW: CGFloat {
        let ratio = screenSize.width / designSize.width
        return CGFloat(self) * ratio
    }
    
    var fitH: CGFloat {
        let ratio = screenSize.height / designSize.height
        return CGFloat(self) * ratio
    }
}
