//
//  TextStyle.swift
//  FlightList
//
//  Created by Валерий Коканов on 19.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import UIKit

struct TextStyle {
    static let styles: [StyleType: [NSAttributedStringKey: Any]] = [
        .title: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black,
        ],
        .text: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.black,
        ],
        .duration: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white,
        ],
        .like: [
            .font: UIFont.systemFont(ofSize: 13, weight: .heavy),
            .foregroundColor: UIColor.lightGray,
        ],
        .cost: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.customGreen,
        ],
        .option: [
            .font: UIFont.systemFont(ofSize: 13, weight: .thin),
            .foregroundColor: UIColor.black,
        ],
    ]

    enum StyleType {
        case title, text, duration, like, cost, option

        var style: [NSAttributedStringKey: Any] {
            return styles[self]!
        }
    }
}
