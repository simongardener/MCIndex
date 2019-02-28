//
//  SearchingTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 28/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//

import UIKit

class SearchingTableViewController: UITableViewController {

    var searchController = UISearchController(searchResultsController: nil)
    let initialSearchBarOffset = 56.0
    let cancelSearchBarOffset = -8.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
      
    }
    // MARK: search
    
    func setupSearchController() {
        hideSearchBar(yAxisOffset: initialSearchBarOffset)
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
        searchController.searchBar.placeholder = "Search by Artist"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    //filtering methods
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
      fatalError("must override")
    }
    fileprivate func hideSearchBar(yAxisOffset : Double){
        self.tableView.contentOffset = CGPoint(x:0.0, y:yAxisOffset)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        fatalError("must override")
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("must override")
        return 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("must override")

        return UITableViewCell()
        
    }
    
}
extension SearchingTableViewController : UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        hideSearchBar(yAxisOffset: cancelSearchBarOffset)
    }
}

extension SearchingTableViewController    : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
