//
//  ViewController.swift
//  FlightList
//
//  Created by Валерий Коканов on 30.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import AsyncDisplayKit
import PromiseKit
import UIKit

class ViewController: ASViewController<ASTableNode> {
    let tableController: TableController
    let tableNode: ASTableNode
    let viewModel: ViewModelProtocol

    init(tableController: TableController = TableController(), viewModel: ViewModelProtocol = ViewModel()) {
        self.tableController = tableController
        self.viewModel = viewModel
        tableNode = ASTableNode(style: .grouped)
        tableNode.view.separatorStyle = .none
        tableNode.delegate = tableController
        tableNode.dataSource = tableController
        tableNode.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        super.init(node: tableNode)
        self.tableController.delegate = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        let titleView = TitleView()
        let text = NSAttributedString(
            image: UIImage(named: "magnifying-glass")!.resizeImage(newWidth: 15),
            string: "RCB - NSA, 1 Apr",
            attributedStyle: .title
        )
        titleView.configure(with: text)
        navigationItem.titleView = titleView
    }
}

extension ViewController: TableControllerDelegate {
    func fetchData() -> Guarantee<FetchDataResultType> {
        return viewModel.getFlights()
    }
}
