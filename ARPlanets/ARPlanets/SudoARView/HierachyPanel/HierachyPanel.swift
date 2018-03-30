//
//  HierachyPanel.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit
import UIKit

protocol HierachyPanelDelegate: class, HasSelectedNode {
    func hierachyPanel(didSelectNode node: SCNNode)
}

class HierachyPanel: UIView {
    
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let functionalTableData = FunctionalTableData()
    
    private let iterator = HierachyIterator()

    weak var delegate: HierachyPanelDelegate?

    init(scene: SCNScene) {
        super.init(frame: CGRect.zero)
        iterator.delegate = self
        
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.constrainEdges(to: self)
        functionalTableData.tableView = tableView
        
        renderHierachy(for: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderHierachy(for scene: SCNScene) {
        iterator.createHierachyStates(rootNode: scene.rootNode)
    }
}

// MARK: Private

extension HierachyPanel: HierachyIteratorDelegate {
    func hierachyIterator(didChange hierachyStates: [HierachyState]) {
        render(nodeHierachies: hierachyStates)
    }
    
    private func render(nodeHierachies: [HierachyState]) {
        
        let selectedNode = delegate?.selectedSCNNode()
        
        var cells = [CellConfigType]()
        for hierachyState in nodeHierachies {
            let isNodeSelected = hierachyState.node == selectedNode
            let backgroundColor = isNodeSelected ? UIColor.uiControlColor.withAlphaComponent(0.6) : .clear
            let cell = HierachyCell(
                key: "node \(hierachyState.node.memoryAddress)",
                style: CellStyle(topSeparator: .full, bottomSeparator: .full, separatorColor: .white, backgroundColor: backgroundColor),
                actions: CellActions(selectionAction: { [weak self] _ in
                    self?.delegate?.hierachyPanel(didSelectNode: hierachyState.node)
                    return .deselected
                }),
                state: hierachyState)
            cells.append(cell)
        }
        
        let section = TableSection(key: "table section", rows: cells)
        functionalTableData.renderAndDiff([section])
    }
}
