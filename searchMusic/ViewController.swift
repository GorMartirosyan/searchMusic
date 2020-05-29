//
//  ViewController.swift
//  searchMusic
//
//  Created by Gor on 4/19/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSourceArray = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
        cell?.setUp(with: dataSourceArray[indexPath.row])
        cell?.loadImage(with: dataSourceArray[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Dvc = Storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(Dvc, animated: true)
        for data in dataSourceArray {
            if (tableView.cellForRow(at: indexPath) as? TrackCell) != nil {
                Dvc.artworkArray.append(data.artworkUrl100)
                Dvc.previewArray.append(data.previewUrl)
                Dvc.cellNumber = indexPath.row
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil || searchBar.text != "" {
            DataService.instance.getTracks(searchRequest: searchBar.text!){ (requestedTracks) in
                self.dataSourceArray = requestedTracks.sorted(by: {$0.trackName < $1.trackName})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        searchBar.resignFirstResponder()
    }
}




