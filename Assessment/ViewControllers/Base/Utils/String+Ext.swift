//
//  String+Ext.swift
//  Assessment
//
//  Created by Sushil K Mishra on 17/02/23.
//

import Foundation
import UIKit
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func getYearFromDateStr(format: String  = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date =  dateFormatter.date(from: self) {
            let yearFormat = "yyyy"
            dateFormatter.dateFormat = yearFormat
            let yearStr = dateFormatter.string(from: date)
            return yearStr
        }
        return ""
    }
    
    func attrbutedStr(attribute: [NSAttributedString.Key : Any]?) -> NSMutableAttributedString {
        let myAttrString = NSMutableAttributedString(string: self, attributes: attribute)
        return myAttrString
    }
    
    
}
