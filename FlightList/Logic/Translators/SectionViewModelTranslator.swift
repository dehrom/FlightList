//
//  SectionViewModelTranslator.swift
//  FlightList
//
//  Created by Валерий Коканов on 23.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation

class SectionViewModelTranslator: TranslatorProtocol {
    let rowViewModelTranslator: RowViewModelTranslator

    init(sectionTranslator: RowViewModelTranslator = RowViewModelTranslator()) {
        rowViewModelTranslator = sectionTranslator
    }

    func translate(_ obj: DTOModel) throws -> [SectionViewModel] {
        return try [
            .init(title: "Best match", rows: transform(items: obj.data.best)),
            .init(title: "Other", rows: transform(items: obj.data.other)),
        ]
    }

    private func transform(items: [DTOModel.RawData]) throws -> [SectionViewModel.RowType] {
        return try items.map { .data(try rowViewModelTranslator.translate($0)) }
    }
}
