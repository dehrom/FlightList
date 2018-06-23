//
//  Interactor.swift
//  FlightList
//
//  Created by Валерий Коканов on 31.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation
import PromiseKit

typealias FetchDataResultType = (sections: [SectionViewModel], hasMorePages: Bool)

protocol ViewModelProtocol: class {
    func getFlights() -> Guarantee<FetchDataResultType>
}

class ViewModel: ViewModelProtocol {
    let service: ServiceProtocol
    let dtoTranslator: DTOTranslator
    let errorTranslator: ErrorTranslator
    let sectionViewModelTranslator: SectionViewModelTranslator

    init(
        service: ServiceProtocol = Service(),
        dtoTranslator: DTOTranslator = DTOTranslator(),
        errorTranslator: ErrorTranslator = ErrorTranslator(),
        sectionViewModelTranslator: SectionViewModelTranslator = SectionViewModelTranslator()
    ) {
        self.service = service
        self.dtoTranslator = dtoTranslator
        self.errorTranslator = errorTranslator
        self.sectionViewModelTranslator = sectionViewModelTranslator
    }

    func getFlights() -> Guarantee<FetchDataResultType> {
        return firstly {
            service.fetchData()
        }.then { data in
            self.dtoTranslator.translate(data)
        }.map { dto in
            (try self.sectionViewModelTranslator.translate(dto), dto.currentPage < dto.totalPage)
        }.recover { error in
            print(error)
            return .value(self.errorTranslator.translate(error, def: ([], false)))
        }
    }
}
