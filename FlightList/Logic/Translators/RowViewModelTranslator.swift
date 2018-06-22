//
//  RowViewModelTranslator.swift
//  FlightList
//
//  Created by Валерий Коканов on 20.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import UIKit

class RowViewModelTranslator: TranslatorProtocol {
    func translate(_ obj: DTOModel.RawData) throws -> SectionViewModel.RowViewModel {
        let durationImage = image(for: "clock", width: 15, fillColor: .white)
        
        let defaultData = SectionViewModel.RowViewModel.DefaultData(
            time: NSAttributedString(string: "\(obj.time.from) - \(obj.time.to)", attributedStyle: .title),
            duration: .init(image: durationImage, string: obj.duration, attributedStyle: .duration),
            companyImage: image(for: obj.companyName, width: 40),
            companyName: NSAttributedString(string: obj.companyName, attributedStyle: .title),
            likePercent: attributedString(for: obj.likePercent),
            cost: NSAttributedString(string: "$\(obj.cost)", attributedStyle: .cost))
        
        let extendedData = obj.details.map { detail -> SectionViewModel.RowViewModel.ExtendedData in
            return .init(
                title: NSAttributedString(string: detail.title, attributedStyle: .title),
                date: NSAttributedString(string: detail.date, attributedStyle: .text),
                time: NSAttributedString(string: "\(detail.time.from) - \(detail.time.to)", attributedStyle: .text),
                duration: .init(image: durationImage, string: detail.duration, attributedStyle: .duration),
                options: attributedStrings(for: detail.options),
                companyImage: image(for: detail.companyName, width: 40),
                companyName: NSAttributedString(string: detail.companyName, attributedStyle: .title))
        }
        return .init(default: defaultData, extended: extendedData, selectionStyle: .none)
    }

    private func image(for companyName: String, width: CGFloat, fillColor: UIColor? = nil) -> UIImage {
        guard var sizedImage = UIImage(named: companyName.lowercased())?.resizeImage(newWidth: width) else { return UIImage() }
        sizedImage = fillColor.map(sizedImage.apply(color:)) ?? sizedImage
        return sizedImage
    }

    private func attributedString(for likeCount: Int?) -> NSAttributedString {
        guard let likeCount = likeCount else { return NSAttributedString() }
        let image = self.image(for: "like", width: 13, fillColor: .gray)
        return .init(image: image, string: "\(likeCount)%", attributedStyle: .like)
    }

    private func attributedStrings(for options: [DTOModel.Option]) -> [NSAttributedString] {
        return options.map {
            let color = $0.avaliable ? UIColor.black.withAlphaComponent(0.9) : UIColor.lightGray
            let image = self.image(for: $0.name, width: 16, fillColor: color)
            return .init(image: image, string: $0.description, attributedStyle: .option)
        }
    }
}
