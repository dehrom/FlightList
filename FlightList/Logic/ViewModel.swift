//
//  Interactor.swift
//  FlightList
//
//  Created by Валерий Коканов on 31.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation
import PromiseKit

typealias FetchDataResultType = (models: [SectionViewModel], hasMorePages: Bool)

protocol ViewModelProtocol: class {
    func getFlights() -> Promise<FetchDataResultType>
}

class ViewModel: ViewModelProtocol {
    let service: ServiceProtocol
    let worker: FormatWorkerProtocol

    init(service: ServiceProtocol = Service(), worker: FormatWorkerProtocol = FormatWorker()) {
        self.service = service
        self.worker = worker
    }

    func getFlights() -> Promise<FetchDataResultType> {
        return service.fetchFlights().map(on: .global(qos: .utility)) { dto -> FetchDataResultType in
            (self.transform(dto: dto), dto.currentPage < dto.totalPage)
        }
    }

    private func transform(dto: DTOModel) -> [SectionViewModel] {
        return [
            .init(title: "Best match", rows: dto.data.best.map(worker.transform(rawData:))),
            .init(title: "Others", rows: dto.data.other.map(worker.transform(rawData:))),
        ]
    }
}
