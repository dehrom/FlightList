//
//  ErrorNode.swift
//  FlightList
//
//  Created by Валерий Коканов on 22.06.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import AsyncDisplayKit
import Foundation

class ErrorNode: ASCellNode {
    lazy var textNode = ASTextNode()

    init(errorMessage: NSAttributedString) {
        super.init()
        textNode.attributedText = errorMessage
        automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
        let spec = ASRelativeLayoutSpec()
        spec.children = [textNode]
        spec.horizontalPosition = .center
        spec.verticalPosition = .end
        return spec
    }
}
