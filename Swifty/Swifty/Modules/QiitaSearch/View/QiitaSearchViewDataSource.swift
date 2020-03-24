//
//  QiitaSearchViewDataSource.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

enum QiitaSearchTableViewSection: Int, CaseIterable {
    case qiitaItems
    case loading
}

final class QiitaSearchViewDataSource: NSObject {
    
    weak var qiitaSearchCelldelegate: QiitaSearchTableViewCellDelegate?
    
    init(qiitaSearchCelldelegate: QiitaSearchTableViewCellDelegate) {
        self.qiitaSearchCelldelegate = qiitaSearchCelldelegate
    }
    
    private var isLoading = false
    private(set) var qiitaItems = [QiitaItem]()
    
    func set(newItems: [QiitaItem]) {
        self.qiitaItems = newItems
    }
    
    func append(additionalItems: [QiitaItem]) {
        self.qiitaItems.append(contentsOf: additionalItems)
    }
    
    func startLoading() {
        isLoading = true
    }
    
    func stopLoading() {
        isLoading = false
    }
}

extension QiitaSearchViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading {
            return QiitaSearchTableViewSection.allCases.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let qiitaSearchSection = QiitaSearchTableViewSection(rawValue: section)
        switch qiitaSearchSection {
            case .qiitaItems:
                return self.qiitaItems.count
            
            case .loading:
                return 1
            
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let qiitaSearchSection = QiitaSearchTableViewSection(rawValue: indexPath.section)
        switch qiitaSearchSection {
            case .qiitaItems:
                let cell: QiitaSearchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.set(qiitaItem: qiitaItems[indexPath.row], indexPath: indexPath, delegate: qiitaSearchCelldelegate)
                return cell
            
            case .loading:
                let cell: LoadingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.startAnimating()
                return cell
            
            default:
                return UITableViewCell()
        }
    }
}

