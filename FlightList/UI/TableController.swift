//
//  TableController.swift
//  FlightList
//
//  Created by Валерий Коканов on 30.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import AsyncDisplayKit
import Foundation
import PromiseKit

protocol TableControllerDelegate: class {
    func fetchData() -> Guarantee<FetchDataResultType>
}

extension TableController {
    struct Configuration {
        var nodeMinHeight: CGFloat = 100
        var nodeMaxHeight: CGFloat = .greatestFiniteMagnitude
    }
}

class TableController: NSObject {
    private let configuration: Configuration
    weak var delegate: TableControllerDelegate?
    private var sections: [SectionViewModel] = []

    private lazy var nodeSize: ASSizeRange = {
        let width = UIScreen.main.bounds.width
        let minSize = CGSize(width: width, height: configuration.nodeMinHeight)
        let maxSize = CGSize(width: width, height: configuration.nodeMaxHeight)
        return .init(min: minSize, max: maxSize)
    }()

    init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }
}

extension TableController: ASTableDelegate {
    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard let cellNode = tableNode.nodeForRow(at: indexPath) as? DataCellNode else { return }
        cellNode.isInExpandedMode = !cellNode.isInExpandedMode
        cellNode.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }

    func tableNode(_: ASTableNode, constrainedSizeForRowAt _: IndexPath) -> ASSizeRange {
        return nodeSize
    }

    func shouldBatchFetch(for _: ASTableNode) -> Bool {
        return true
    }

    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        let block: ([SectionViewModel]) -> IndexSet = { [sections] data in
            let totalSectionsCountRange = (sections.count ..< sections.count + data.count)
            return .init(integersIn: totalSectionsCountRange)
        }

        context.beginBatchFetching()
        delegate?.fetchData().done { data in
            self.sections.append(contentsOf: data.sections)
            tableNode.insertSections(block(data.sections), with: .none)
            context.completeBatchFetching(data.hasMorePages)
        }
    }
}

extension TableController: ASTableDataSource {
    func numberOfSections(in _: ASTableNode) -> Int {
        return sections.count
    }

    func tableNode(_: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    func tableNode(_: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let viewModel = self.sections[indexPath.section].rows[indexPath.row]
            switch viewModel {
            case let .data(rowViewModel):
                return DataCellNode(viewModel: rowViewModel)
            case let .message(errorMessage):
                return ErrorCellNode(errorMessage: errorMessage)
            }
        }
    }
}
