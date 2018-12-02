//
//  StoriesTableViewController.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import UIKit
import CoreData

class StoriesTableViewController: UITableViewController {
    
    var stories : [Story]!
    var filteredStories = [Story]()
    var searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        
        self.tableView.tableFooterView = UIView() // makes empty rows disappear
        setupSearchController()
//        searchController.searchResultsUpdater = self
//        searchController.hidesNavigationBarDuringPresentation = false
//       // searchController.obscuresBackgroundDuringPresentation = false
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Stories"
//        tableView.tableHeaderView = searchController.searchBar
//       // navigationItem.searchController = searchController
//        definesPresentationContext = true
        
    }
    
    func setupSearchController() {
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
        searchController.searchBar.placeholder = "Search by Story"
        searchController.hidesNavigationBarDuringPresentation = false
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath)
        let story : Story
        if isFiltering() {
            story = filteredStories[indexPath.row]
        }else{
            story = stories[indexPath.row]
        }
        var storyTitle = "\(story.title!)"
        if storyTitle == "" { storyTitle = story.seriesName! }
        cell.textLabel?.text = storyTitle
        return cell
    }

    
}

extension StoriesTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("delegate got the message")

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
