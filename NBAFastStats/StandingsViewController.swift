//
//  ViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/3/22.
// We need to add logo for each team
// We need to sep east and west upon clicking of segmentcontrol


import UIKit


class StandingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var teamnameLabel: UILabel!
    
    @IBOutlet weak var winsLabel: UILabel!
    
    @IBOutlet weak var lossesLabel: UILabel!
    
}


class StandingsViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // Var stats gets access to all vars and methods from games class
    // So we should call stats and call method stats.fetchgames, somewhere here we can modify the curr date for api endpoint call
    
    
    var stats = Stats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        stats.getstandingsData {
            DispatchQueue.main.async { [self] in
                //self.tableView.reloadData()
                self.sortbyconference()
                print(self.stats.standingTeamlogoURL)

            }
        }
    }
    
    func sortbyconference(){
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            print ("Switch to Eastern")
            stats.conferenceselected = "Eastern"
            stats.getstandingsData {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        case 1:
            print ("Switch to western")
            stats.conferenceselected = "Western"
            stats.getstandingsData{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        default:
            print ("This should never happen")
        }
        //self.tableView.reloadData()
    }

    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        sortbyconference()
    }
    
}


extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingsCell", for: indexPath) as! StandingsTableViewCell
        
        cell.teamnameLabel?.text = stats.standings[indexPath.row].Name
        cell.winsLabel?.text = String(stats.standings[indexPath.row].Wins)
        cell.lossesLabel?.text = String(stats.standings[indexPath.row].Losses)
        
        //stats.getTeamLogo(teamID: stats.standings[indexPath.row].TeamID)
        //cell.logoImageView?.downloaded(from: stats.standingTeamlogoURL)
     
        return cell
    }

}

