//
//  NSAttributedString+UIImage.swift
//  FlightList
//
//  Created by Валерий Коканов on 20.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import UIKit

extension NSAttributedString {
    convenience init(image: UIImage, string: String, attributedStyle: TextStyle.StyleType) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: (attributedStyle.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let resultString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        resultString.append(NSAttributedString(string: " "))
        resultString.append(NSAttributedString(string: string, attributedStyle: attributedStyle))
        self.init(attributedString: resultString)
    }

    convenience init(string: String, attributedStyle: TextStyle.StyleType) {
        self.init(string: string, attributes: attributedStyle.style)
    }
}

private extension TextStyle.StyleType {
    var capHeight: CGFloat {
        return (style[.font] as? UIFont)?.capHeight ?? 0
    }
}
