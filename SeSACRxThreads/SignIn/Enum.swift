//
//  Enum.swift
//  SeSACRxThreads
//
//  Created by 홍수만 on 2023/11/05.
//

import UIKit

enum ColorType {
    case blue
    case red
    
    var returnColor: UIColor {
        switch self {
        case .blue:
            return UIColor.blue
        case .red:
            return UIColor.red
        }
    }
}
