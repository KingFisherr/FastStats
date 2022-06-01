//
//  GameDetailsViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/25/22.
//

import UIKit

class GamesDetailTableViewCell: UITableViewCell{
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerStatsLabel: UILabel!
    @IBOutlet weak var playerName: UILabel!
}

class GameDetailsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var teamIcon: UIImageView!
    
    var stats = Stats()
    
    var awayTeamID = 0
    var homeTeamID = 0
    var awayTeamName = ""
    var homeTeamName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        //teamIcon.image = UIImage(named: String(awayTeamID))
        segmentedControl.setTitle(awayTeamName, forSegmentAt: 0)
        segmentedControl.setTitle(homeTeamName, forSegmentAt: 1)
        stats.getcurrentDate()
        stats.headshotselectedteam = awayTeamName
        stats.getGameDetailsByTeam{
            DispatchQueue.main.async { [self] in
                self.sortbyteam()
            }
        }
    }
    
    func sortbyteam(){
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            print ("Switch to Away Team")
            stats.selectedTeam = awayTeamID
            stats.headshotselectedteam = awayTeamName
            teamIcon.image = UIImage(named: String(awayTeamID))
            stats.getGameDetailsByTeam{
                DispatchQueue.main.async { [self] in
                    self.detailsTableView.reloadData()
                }
            }
            stats.getPlayersHeadShotsByTeam {
                DispatchQueue.main.async {
                    self.detailsTableView.reloadData()
                }
            }
        case 1:
            print ("Switch to Home Team")
            stats.selectedTeam = homeTeamID
            stats.headshotselectedteam = homeTeamName
            teamIcon.image = UIImage(named: String(homeTeamID))
            stats.getGameDetailsByTeam{
                DispatchQueue.main.async { [self] in
                    self.detailsTableView.reloadData()
                }
            }
            stats.getPlayersHeadShotsByTeam {
                DispatchQueue.main.async {
                    self.detailsTableView.reloadData()
                }
            }
        default:
            print ("This should never happen")
        }
    }
    
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        sortbyteam()
    }
    

}

extension GameDetailsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.gamedetailsbyteam.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! GamesDetailTableViewCell
        
    
        let player = stats.gamedetailsbyteam[indexPath.row].Name
        var components = player.components(separatedBy: " ")
        let firstName = components.removeFirst()
        let lastName = components.joined(separator: " ")
        let playern = String(firstName.prefix(1)+". " + lastName)
            
        
        let pts = String(Int(ceil(stats.gamedetailsbyteam[indexPath.row].Points ?? 0)))
        let rebs = String(Int(ceil(stats.gamedetailsbyteam[indexPath.row].Rebounds ?? 0)))
        let asts = String(Int(ceil(stats.gamedetailsbyteam[indexPath.row].Assists ?? 0)))
        
        cell.playerName.text = playern
        if stats.gamedetailsbyteam[indexPath.row].Minutes == 0{
            cell.playerStatsLabel.text = "DNP"
        }else{
            cell.playerStatsLabel.text = pts + "/" + rebs + "/" + asts
        }
        // we  need player id from gamedetailsbyteam
        let playerPhoto = stats.playerheadshots.filter { $0.PlayerID == stats.gamedetailsbyteam[indexPath.row].PlayerID}
        if playerPhoto.count > 0 {
            cell.playerImage.downloaded(from: playerPhoto[0].PhotoUrl)
        }
        return cell
        
    }
    
    // Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rTransfrom = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rTransfrom
        
        UIView.animate(withDuration: 0.5){
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
}
