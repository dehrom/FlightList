//
//  TableController.swift
//  FlightList
//
//  Created by Валерий Коканов on 30.05.2018.
//  Copyright © 2018 mynight. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import PromiseKit

protocol TableControllerDelegate: class {
    func fetchData() -> Promise<FetchDataResultType>
}

extension TableController {
    struct Configuration {
        var nodeMinHeight: CGFloat = 100
        var nodeMaxHeight: CGFloat = .greatestFiniteMagnitude
    }
}

class TableController: NSObject {
    private let configuration: Configuration
    private var models: [SectionViewModel] = []
    weak var delegate: TableControllerDelegate?
    
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].title
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard let cellNode = tableNode.nodeForRow(at: indexPath) as? CellNode else { return }
        DispatchQueue.main.async {
            cellNode.isInExpandedMode = !cellNode.isInExpandedMode
            cellNode.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)            
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return nodeSize
    }
    
    func shouldBatchFetch(for CellNode: ASTableNode) -> Bool {
        return true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        let block: ([SectionViewModel]) -> (IndexSet) = { [models] data in
            let totalSectionsCountRange = (models.count ..< models.count + data.count)
            return .init(integersIn: totalSectionsCountRange)
        }
        context.beginBatchFetching()
        delegate?.fetchData().done(on: .main) { response in
            self.models.append(contentsOf: response.models)
            tableNode.insertSections(block(response.models), with: .none)
            context.completeBatchFetching(response.hasMorePages)
        }.catch {
            print($0.localizedDescription)
            context.completeBatchFetching(false)
        }
    }
}

extension TableController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return models[section].rows.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [viewModel = models[indexPath.section].rows[indexPath.row]] in
            return CellNode(viewModel: viewModel)
        }
    }
}
