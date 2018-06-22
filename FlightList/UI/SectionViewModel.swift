//
//  ViewModel.swift
//  FlightList
//
//  Created by Валерий Коканов on 30.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import UIKit

struct SectionViewModel {
    let title: String?
    let rows: [RowType]

    enum RowType {
        case data(RowViewModel)
        case message(NSAttributedString)
    }

    struct RowViewModel {
        let `default`: DefaultData
        let extended: [ExtendedData]
        let selectionStyle: UITableViewCellSelectionStyle

        struct DefaultData {
            let time: NSAttributedString
            let duration: NSAttributedString
            let companyImage: UIImage
            let companyName: NSAttributedString
            let likePercent: NSAttributedString
            let cost: NSAttributedString
        }

        struct ExtendedData {
            let title: NSAttributedString
            let date: NSAttributedString
            let time: NSAttributedString
            let duration: NSAttributedString
            let options: [NSAttributedString]
            let companyImage: UIImage
            let companyName: NSAttributedString
        }
    }
}
