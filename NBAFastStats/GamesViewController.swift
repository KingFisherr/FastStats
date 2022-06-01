//
//  GamesViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/25/22.
//

import UIKit
import AVFoundation
var audioPlayer: AVAudioPlayer!
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
        stats.getcurrentDate()
        stats.getLiveGames {
            DispatchQueue.main.async {
                self.GamesTableView.reloadData()
                // Checks if any live games are availiable
                if self.stats.livegames.count > 0 {
                    self.stats.ifanygames = true
                }else{
                    self.stats.ifanygames = false
                }
                // If none available show NO GAMES
                if self.stats.ifanygames == false{
                    self.GamesTableView.isHidden = true
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.GamesTableView.indexPathForSelectedRow{
            self.GamesTableView.deselectRow(at: index, animated: true)
        }
    }
    
}


extension GamesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if (stats.ifanygames == false){
           // self.GamesTableView.isHidden = true
        //}
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
    
        cell.awayteamImage.image = UIImage(named: String(stats.livegames[indexPath.row].AwayTeamID))
        cell.hometeamimage.image = UIImage(named: String(stats.livegames[indexPath.row].HomeTeamID))
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameDetails") as? GameDetailsViewController
        let pathToSound = Bundle.main.path(forResource: "mixkit-basketball-ball-hitting-the-net-2084", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        catch
        {
            print (error)
        }
        vc?.awayTeamID = stats.livegames[indexPath.row].AwayTeamID
        vc?.homeTeamID = stats.livegames[indexPath.row].HomeTeamID
        vc?.awayTeamName = stats.livegames[indexPath.row].AwayTeam!
        vc?.homeTeamName = stats.livegames[indexPath.row].HomeTeam ?? ""
        navigationController?.pushViewController(vc!, animated: true)
    }
    // Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rTransfrom = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rTransfrom
        
        UIView.animate(withDuration: 1.0){
            cell.layer.transform = CATransform3DIdentity
        }
    }

}
