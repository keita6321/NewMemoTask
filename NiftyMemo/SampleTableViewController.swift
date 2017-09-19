//
//  SampleTableViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/09/12.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit

class SampleTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let dogs = ["Sean","Hoku", "April", "Fido"]
    var filteredDogs = [String]()
    
    var searchController: UISearchController!
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self

        self.searchController.dimsBackgroundDuringPresentation = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredDogs = self.dogs.filter { (dogs: String) -> Bool in
            if dogs.lowercased().contains(self.searchController.searchBar.text!.lowercased()){
                return true
            }
            else{
                return false
            }
        }
        self.resultsController.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView{
            return self.dogs.count
        }
        else{
            return self.filteredDogs.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.tableView{
            cell.textLabel?.text = self.dogs[indexPath.row]
        }
        else{
            cell.textLabel?.text = self.filteredDogs[indexPath.row]
        }
        
        
        return cell
    }
    
    
}
