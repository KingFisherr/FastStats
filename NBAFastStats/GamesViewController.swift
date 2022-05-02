//
//  GamesViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/25/22.
//

import UIKit

var minutesremains = ""


class GamesTableViewCell: UITableViewCell{
    
    @IBOutlet weak var awayteamImage: UIImageView!
    
    @IBOutlet weak var hometeamimage: UIImageView!
    
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    @IBOutlet weak var homeScoreLabel: UILabel!
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    
}

class GamesViewController: UIViewController {

    @IBOutlet weak var GamesTableView: UITableView!
    
    var stats = Stats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GamesTableView.delegate = self
        GamesTableView.dataSource = self
        // check for live games, then update bool ifanygames var in models
        stats.getcurrentDate()
        stats.getLiveGames {
            DispatchQueue.main.async {
                self.GamesTableView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }

}

extension GamesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (stats.ifanygames == false){
            self.GamesTableView.isHidden = true
        }
        return stats.livegames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamesCell", for: indexPath) as! GamesTableViewCell
        
        cell.awayScoreLabel?.text = String(stats.livegames[indexPath.row].AwayTeamScore ?? 0)
        cell.homeScoreLabel?.text = String(stats.livegames[indexPath.row].HomeTeamScore ?? 0)
        
        
        if let minutesremain = stats.livegames[indexPath.row].TimeRemainingMinutes{
            minutesremains = String(minutesremain)
        }else{
            cell.gameStatusLabel?.text = "FINAL"
        }
        
       if let secondsremain = stats.livegames[indexPath.row].TimeRemainingSeconds{
            cell.gameStatusLabel?.text = minutesremains + ":" + String(secondsremain)
       }else{
           cell.gameStatusLabel?.text = "FINAL"
       }
    
//
//        stats.getTeamLogo(teamID: stats.standings[indexPath.row].TeamID)
//        cell.logoImageView?.downloaded(from: stats.standingTeamlogoURL)
     
        return cell
    }

}
