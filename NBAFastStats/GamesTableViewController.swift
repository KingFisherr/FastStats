//
//  GamesTableViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/12/22.
// This should be all live games
// Logo, name, v logo, name and score if live (all teams maybe)

import UIKit

class GamesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "TEstt"
        
        return cell
    }

}
