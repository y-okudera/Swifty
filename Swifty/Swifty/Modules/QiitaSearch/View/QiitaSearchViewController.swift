//
//  QiitaSearchViewController.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class QiitaSearchViewController: UIViewController {
    
    private let initSearchWord = "iOS"

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = presenter.dataSource
            tableView.delegate = self
        }
    }
    
    private lazy var searchController: UISearchController! = {
        return UISearchController(searchResultsController: nil)
    }()
    
    var presenter: QiitaSearchPresentable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupNavigationItem()
        initSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach {
                tableView.deselectRow(at: $0, animated: true)
            }
        }
    }
    
    private func initSearch() {
        navigationItem.title = initSearchWord
        presenter.tappedSearchButton(query: initSearchWord)
    }
    
    private func registerNib() {
        QiitaSearchTableViewCell.register(tableView: self.tableView)
        LoadingTableViewCell.register(tableView: self.tableView)
    }
    
    private func setupNavigationItem() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension QiitaSearchViewController: QiitaSearchView {
    
    func reloadView() {
        tableView.reloadData()
    }
    
    func showAlert(error: Error) {
        UIAlertController.show(error: error, sender: self)
    }
    
    func showAlert(nsError: NSError) {
        UIAlertController.show(nsError: nsError, sender: self)
    }
}

extension QiitaSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(indexPath: indexPath)
    }
}

extension QiitaSearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !presenter.isRequesting && tableView.isNearBottomEdge() {
            presenter.scrollViewIsNearBottomEdge()
        }
    }
}

extension QiitaSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        print(debug: "検索", searchText)
        navigationItem.title = searchText
        presenter.tappedSearchButton(query: searchText)
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

