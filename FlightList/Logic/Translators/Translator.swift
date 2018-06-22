//
//  DTOTranslator.swift
//  FlightList
//
//  Created by Валерий Коканов on 22.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation
import PromiseKit

protocol TranslatorProtocol: class {
    associatedtype InputType
    associatedtype OutputType

    func translate(_ obj: InputType) throws -> OutputType
}

extension TranslatorProtocol {
    func translate(_ obj: InputType) -> Promise<OutputType> {
        return Promise { seal in
            do {
                let result = try translate(obj)
                seal.fulfill(result)
            } catch {
                seal.reject(error)
            }
        }
    }

    func translate(_ obj: InputType, def: OutputType) -> OutputType {
        return (try? translate(obj)) ?? def
    }
}
