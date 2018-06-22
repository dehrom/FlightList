//
//  DTOTranslator.swift
//  FlightList
//
//  Created by Валерий Коканов on 23.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation

extension DTOTranslator {
    enum Error: Swift.Error {
        case underlying(error: Swift.Error)
    }
}

class DTOTranslator: TranslatorProtocol {
    func translate(_ obj: Data) throws -> DTOModel {
        do {
            return try JSONDecoder().decode(DTOModel.self, from: obj)
        } catch {
            throw Error.underlying(error: error)
        }
    }
}
