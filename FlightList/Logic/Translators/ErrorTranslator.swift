//
//  ErrorTranslator.swift
//  FlightList
//
//  Created by Валерий Коканов on 23.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation

class ErrorTranslator: TranslatorProtocol {
    func translate(_ obj: Error) throws -> FetchDataResultType {
        var errorString: String!
        switch obj {
        case is Service.Error:
            errorString = "Failed to obtain data"
        case is DTOTranslator.Error:
            errorString = "Failed to parse data"
        default:
            errorString = "Unknown error"
        }

        let result: SectionViewModel.RowType = .message(NSAttributedString(string: errorString, attributedStyle: .error))
        return (
            [.init(title: nil, rows: [result])],
            false
        )
    }
}
