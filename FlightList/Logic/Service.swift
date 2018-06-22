//
//  Service.swift
//  FlightList
//
//  Created by Валерий Коканов on 18.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation
import PromiseKit

protocol ServiceProtocol: class {
    func fetchData() -> Promise<Data>
}

extension Service {
    enum Error: Swift.Error {
        case invalidPath(String)
        case underlying(error: Swift.Error)

        var localizedDescription: String {
            switch self {
            case let .invalidPath(message):
                return message
            case let .underlying(error: error):
                return error.localizedDescription
            }
        }
    }
}

class Service: ServiceProtocol {
    func fetchData() -> Promise<Data> {
        return Promise<Data> { seal in
            do {
                guard let path = Bundle.main.path(forResource: "json", ofType: "txt") else {
                    seal.reject(Error.invalidPath("The path for resource is nil"))
                    return
                }
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                seal.fulfill(data)
            } catch {
                seal.reject(Error.underlying(error: error))
            }
        }
    }
}
