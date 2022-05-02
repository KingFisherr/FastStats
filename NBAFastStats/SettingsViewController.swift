//
//  SettingsViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/22/22.
//

import UIKit
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class PlayersTableViewCell: UITableViewCell{

    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerPositionLabel: UILabel!
    
    @IBOutlet weak var playerNumberLabel: UILabel!
    
}

class SettingsViewController: UIViewController, NewFavTeam {

    func passDataBack(data: String) {
        teamLabel.text = data
    }
    
    @IBOutlet weak var teamlogoImage: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var playersTableView: UITableView!
    
    var stats = Stats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersTableView.delegate = self
        playersTableView.dataSource = self
        stats.getPlayersbyTeam{
            DispatchQueue.main.async {
                self.playersTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectNewTeam(_ sender: Any) {
        performSegue(withIdentifier: "selectNewTeam", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectNewTeam"{
            let pickerVC = segue.destination as! SettingsPickerViewController
            pickerVC.delegate = self
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.players.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayersTableViewCell
        
        cell.playerNameLabel.text = stats.players[indexPath.row].FirstName + " " + stats.players[indexPath.row].LastName
        cell.playerNumberLabel.text = String(stats.players[indexPath.row].Jersey)
        cell.playerPositionLabel.text = stats.players[indexPath.row].Position
        cell.playerImage.downloaded(from: stats.players[indexPath.row].PhotoUrl)
        
        return cell
    }

}
