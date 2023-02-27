//
//  FontTheme.swift
//  Assessment
//
//  Created by Sushil K Mishra on 17/02/23.
//

import Foundation
import UIKit
class FontAttribute {
    class func getAttribute(typeStyle: LabelAttributeStyle) -> [NSAttributedString.Key : Any] {
        if typeStyle == .nameDetail {
            return [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: getFontNameWithSize(type: .bold, size: 24.0) ]
        } else if typeStyle == .yearDetail {
            return [ NSAttributedString.Key.foregroundColor: UIColor(red: 20.0/255 , green: 28.0/255, blue: 37.0/255, alpha: 0.7), NSAttributedString.Key.font: getFontNameWithSize(type: .regular, size: 24.0) ]
        }  else if typeStyle == .lightTitleHome {
            return [ NSAttributedString.Key.foregroundColor: UIColor(red: 20.0/255 , green: 28.0/255, blue: 37.0/255, alpha: 1.0), NSAttributedString.Key.font: getFontNameWithSize(type: .regular, size: 12.0)]
        }  else if typeStyle == .boldTitleHome {
            return [ NSAttributedString.Key.foregroundColor: UIColor(red: 20.0/255 , green: 28.0/255, blue: 37.0/255, alpha: 1.0), NSAttributedString.Key.font: getFontNameWithSize(type: .bold, size: 12.0)]
        } else {
            return [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: getFontNameWithSize(type: .bold, size: 24.0)]
        }
    }
    
    class func getFontNameWithSize(type: FontType = .regular, size: CGFloat) -> UIFont {
        if type == .bold {
            return UIFont(name: "SF Pro Text Bold", size: size)!
        } else if type == .light {
            return UIFont(name: "SF Pro Text Light", size: size)!
        } else if type == .semiBold {
            return UIFont(name: "SF Pro Text SemiBold", size: size)!
        } else if type == .heavy {
            return UIFont(name: "SF Pro Text Heavy", size: size)!
        } else if type == .medium {
            return UIFont(name: "SF Pro Text Medium", size: size)!
        } else {
            return UIFont(name: "SF Pro Text Regular", size: size)!
        }
    }
}
