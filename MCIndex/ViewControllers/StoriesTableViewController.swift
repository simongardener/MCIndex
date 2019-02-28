//
//  StoriesTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 26/02/2019.
//  Copyright © 2019 Simon Gardener. All rights reserved.
//


import UIKit
import CoreData

class StoriesTableViewController: UITableViewController {
    
    var stories : [Story]!
    var filteredStories = [Story]()
    var searchController = UISearchController(searchResultsController: nil)
    let initialSearchBarOffset = 56.0
    let cancelSearchBarOffset = -8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        
        self.tableView.tableFooterView = UIView() // makes empty rows disappear
        if stories.count > 12 {
            setupSearchController()
        }
    }
    
    func setupSearchController() {
        hideSearchBar(yAxisOffset: initialSearchBarOffset)
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
        searchController.searchBar.placeholder = "Search by Story"
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
        print(" infilterCOntentforsearchText")
        filteredStories = stories.filter({(story: Story) -> Bool in
            let title = story.title!.isEmpty == false ?  story.title! : story.seriesName!
            return title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredStories.count
        }
        return stories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryBySeriesCell
        
        let story : Story
        if isFiltering() {
            story = filteredStories[indexPath.row]
        }else{
            story = stories[indexPath.row]
        }
        cell.configure(with: story)
        return cell
    }
    
    fileprivate func hideSearchBar(yAxisOffset : Double){
        self.tableView.contentOffset = CGPoint(x:0.0, y:yAxisOffset)
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? StoryDetailViewController else { fatalError("Didnt get a StoryDetailViewController")}
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("cant get this")}
        if isFiltering() {
            vc.story = filteredStories[indexPath.row]
        }else {
            vc.story = stories[indexPath.row]
            
        }
    }
}

extension StoriesTableViewController : UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        hideSearchBar(yAxisOffset: cancelSearchBarOffset)
    }
}
extension StoriesTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension StoriesTableViewController : Injectable {
    func assertDependencies() {
        assert(stories != nil)
    }
    
    func inject(_ allStory: [Story]) {
        stories = allStory
    }
    
    
    
    typealias T = [Story]
    
}
