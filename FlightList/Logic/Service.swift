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
    func fetchFlights() -> Promise<DTOModel>
}

extension Service {
    enum Error: Swift.Error {
        case noData
        case underlying(error: Swift.Error)
    }
}

class Service: ServiceProtocol {
    func fetchFlights() -> Promise<DTOModel> {
        return Promise { seal in
            seal.fulfill(try getData())
        }.then { (data: Data) -> Promise<DTOModel> in
            .value(try self.transform(data))
        }.recover {
            Promise(error: Error.underlying(error: $0))
        }
    }

    private func getData() throws -> Data {
        guard let path = Bundle.main.path(forResource: "json", ofType: "txt") else { throw Error.noData }
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }

    private func transform(_ data: Data) throws -> DTOModel {
        return try JSONDecoder().decode(DTOModel.self, from: data)
    }
}
