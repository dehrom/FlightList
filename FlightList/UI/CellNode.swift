//
//  TableNodeView.swift
//  FlightList
//
//  Created by Валерий Коканов on 30.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import AsyncDisplayKit

class CellNode: ASCellNode {
    let viewModel: SectionViewModel.RowViewModel
    var isInExpandedMode = false
    
    var flightDurationNode: ASTextNode {
        let flightDurationNode = ASTextNode()
        flightDurationNode.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        flightDurationNode.textContainerInset = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        flightDurationNode.cornerRadius = 5
        flightDurationNode.clipsToBounds = true
        flightDurationNode.attributedText = viewModel.default.duration
        flightDurationNode.tintColor = UIColor.white
        return flightDurationNode
    }
    
    var airlineImageNode: ASImageNode {
        let airlineImageNode = ASImageNode()
        return airlineImageNode
    }
    
    var airlineTitleNode: ASTextNode {
        let airlineTitleNode = ASTextNode()
        return airlineTitleNode
    }
    
    lazy var likesPercentNode: ASTextNode = {
        let likesPercentNode = ASTextNode()
        likesPercentNode.attributedText = viewModel.default.likePercent
        return likesPercentNode
    }()
    
    lazy var costNode: ASTextNode = {
        let costNode = ASTextNode()
        costNode.textContainerInset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        costNode.cornerRadius = 12
        costNode.borderColor = UIColor.customGreen.cgColor
        costNode.borderWidth = 2.0
        costNode.attributedText = viewModel.default.cost
        return costNode
    }()
    
    lazy var backgroundNode: ASDisplayNode = {
        let backgroundNode = ASDisplayNode()
        backgroundNode.shadowColor = UIColor.lightGray.cgColor
        backgroundNode.borderWidth = 1
        backgroundNode.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        backgroundNode.cornerRadius = 5
        backgroundNode.shadowOffset = CGSize(width: 2.0, height: 2.0)
        backgroundNode.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return backgroundNode
    }()
    
    lazy var arrowDownNode: ASImageNode = {
        let arrowDownNode = ASImageNode()
        arrowDownNode.image = UIImage(named: "arrow_down")?.resizeImage(newWidth: 15)
        return arrowDownNode
    }()
    
    let textNodeBlock: (NSAttributedString) -> ASTextNode = {
        let textNode = ASTextNode()
        textNode.attributedText = $0
        return textNode
    }
    
    init(viewModel: SectionViewModel.RowViewModel) {
        self.viewModel = viewModel
        super.init()
        selectionStyle = viewModel.selectionStyle
        automaticallyManagesSubnodes = true
    }
 
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec.vertical()
        verticalStackSpec.spacing = 20
        verticalStackSpec.justifyContent = .start
        verticalStackSpec.alignItems = .start
        verticalStackSpec.style.flexGrow = 1
        
        switch isInExpandedMode {
        case false:
            let stack11 = ASStackLayoutSpec.horizontal()
            stack11.spacing = 6
            stack11.justifyContent = .start
            stack11.alignItems = .center
            let flightDurationNode = self.flightDurationNode
            flightDurationNode.attributedText = viewModel.default.duration
            stack11.children = [textNodeBlock(viewModel.default.time), flightDurationNode]
            
            let stack12 = ASStackLayoutSpec.horizontal()
            stack12.spacing = 6
            stack12.justifyContent = .start
            stack12.alignItems = .start
            stack12.children = [arrowDownNode]
            
            let stack1Line = ASStackLayoutSpec.horizontal()
            stack1Line.style.width = ASDimension(unit: .fraction, value: 1)
            stack1Line.justifyContent = .spaceBetween
            stack1Line.alignItems = .center
            stack1Line.children = [stack11, stack12]
            
            let stack21 = ASStackLayoutSpec.horizontal()
            stack21.spacing = 6
            stack21.justifyContent = .start
            stack21.alignItems = .center
            let airlineImageNode = self.airlineImageNode
            airlineImageNode.image = viewModel.default.companyImage
            let airlineTitleNode = self.airlineTitleNode
            airlineTitleNode.attributedText = viewModel.default.companyName
            stack21.children = [airlineImageNode, airlineTitleNode]
            
            let stack22 = ASStackLayoutSpec.horizontal()
            stack22.spacing = 6
            stack22.justifyContent = .start
            stack22.alignItems = .center
            stack22.children = [likesPercentNode, costNode]
            
            let stack2Line = ASStackLayoutSpec.horizontal()
            stack2Line.style.width = ASDimension(unit: .fraction, value: 1)
            stack2Line.justifyContent = .spaceBetween
            stack2Line.alignItems = .center
            stack2Line.children = [stack21, stack22]
            
            verticalStackSpec.children = [
                stack1Line,
                stack2Line
            ]
        case true:
            let rowStacks = viewModel.extended.enumerated().map { index, row -> ASStackLayoutSpec in
                let stack1Line = ASStackLayoutSpec.horizontal()
                stack1Line.spacing = 6
                stack1Line.justifyContent = .start
                stack1Line.alignItems = .center
                
                if index == 0 {
                    stack1Line.spacing = 0
                    stack1Line.style.width = ASDimension(unit: .fraction, value: 1)
                    stack1Line.justifyContent = .spaceBetween
                    
                    let stack12 = ASStackLayoutSpec.horizontal()
                    stack12.spacing = 6
                    stack12.justifyContent = .start
                    stack12.alignItems = .start
                    stack12.children = [arrowDownNode]
                    
                    let stack11 = ASStackLayoutSpec.horizontal()
                    stack11.justifyContent = .start
                    stack11.alignItems = .start
                    stack11.children = [textNodeBlock(row.title)]
                    
                    stack1Line.children = [stack11, stack12]
                } else {
                    stack1Line.children = [textNodeBlock(row.title)]
                }
                
                let stack21 = ASStackLayoutSpec.horizontal()
                stack21.spacing = 5
                stack21.alignItems = .center
                let flightDurationNode = self.flightDurationNode
                flightDurationNode.attributedText = row.duration
                stack21.children = [textNodeBlock(row.time), flightDurationNode]
                
                let stack31 = ASStackLayoutSpec.vertical()
                stack31.spacing = 3
                stack31.children = row.options.map(textNodeBlock)
                
                let stack41 = ASStackLayoutSpec.horizontal()
                stack41.spacing = 6
                stack41.justifyContent = .start
                stack41.alignItems = .center
                let airlineImageNode = self.airlineImageNode
                airlineImageNode.image = row.companyImage
                let airlineTitleNode = self.airlineTitleNode
                airlineTitleNode.attributedText = row.companyName
                stack41.children = [airlineImageNode, airlineTitleNode]
                
                let rowStack = ASStackLayoutSpec.vertical()
                rowStack.spacing = 6
                rowStack.justifyContent = .start
                rowStack.alignItems = .start
                rowStack.style.width = ASDimension(unit: .fraction, value: 1)
                rowStack.children = [
                    stack1Line,
                    stack21,
                    stack31,
                    stack41
                ]
                
                return rowStack
            }
            
            verticalStackSpec.children = rowStacks
        }
        
        let innerInsetLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12), child: verticalStackSpec)
        let backgroundSpec = ASBackgroundLayoutSpec(child: innerInsetLayoutSpec, background: backgroundNode)
        let spec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16), child: backgroundSpec)
        return spec
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        UIView.animate(
            withDuration: defaultLayoutTransitionDuration,
            delay: defaultLayoutTransitionDelay,
            options: defaultLayoutTransitionOptions,
            animations: {
                switch self.isInExpandedMode {
                case false:
                    self.arrowDownNode.transform = CATransform3DIdentity
                case true:
                    self.arrowDownNode.transform = CATransform3DRotate(self.arrowDownNode.transform, .pi, 0, 0, 1)
                }
                context.completeTransition(true)
                self.setNeedsLayout()
        })
    }
}
