//
//  TitleView.swift
//  FlightList
//
//  Created by Валерий Коканов on 30.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import UIKit

extension TitleView {
    struct Appearance {
        let titleFont = UIFont.systemFont(ofSize: 12)
        let titleColor = UIColor.black
        let titleInset: CGFloat = 5
        let viewCornerRadius: CGFloat = 5
        let viewBorderWidth: CGFloat = 1
        let viewBorderColor = UIColor.black.cgColor
    }
}

class TitleView: UIView {
    private let appearance: Appearance

    private lazy var titleLabel: UILabel = {
        var view = UILabel()
        view.font = appearance.titleFont
        view.textColor = appearance.titleColor
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: NSAttributedString) {
        titleLabel.attributedText = text
        titleLabel.sizeToFit()
    }

    private func setupViews() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            .init(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self,
                  attribute: .left, multiplier: 1, constant: appearance.titleInset),
            .init(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self,
                  attribute: .top, multiplier: 1, constant: appearance.titleInset),
            .init(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: self,
                  attribute: .right, multiplier: 1, constant: -appearance.titleInset),
            .init(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self,
                  attribute: .bottom, multiplier: 1, constant: -appearance.titleInset),
        ])

        layer.cornerRadius = appearance.viewCornerRadius
        layer.borderWidth = appearance.viewBorderWidth
        layer.borderColor = appearance.viewBorderColor
    }
}
