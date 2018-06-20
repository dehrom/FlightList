//
//  UIImage+Utils.swift
//  FlightList
//
//  Created by Валерий Коканов on 07.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
    
    func apply(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard
            let context = UIGraphicsGetCurrentContext(),
            let cgImage = cgImage
        else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        context.clip(to: rect, mask: cgImage)
        color.setFill()
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
