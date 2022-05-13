//
//  SettingsViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/22/22.
//

import UIKit

// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

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
        DispatchQueue.main.async {
            self.playersTableView.reloadData()
        }
    }
    
    
    @IBOutlet weak var teamLogoImage: UIImageView!
    @IBOutlet weak var teamColorImage: UIImageView!

    @IBOutlet weak var teamLabel: UILabel!

    @IBOutlet weak var fieldGoalPercentage: UILabel!
//    @IBOutlet weak var threePointPercentage: UILabel!
//    @IBOutlet weak var freeThrowPercentage: UILabel!
    
    @IBOutlet weak var playersTableView: UITableView!
    
    var stats = Stats()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        playersTableView.delegate = self
//        playersTableView.dataSource = self
//
//        stats.getPlayersbyTeam{
//            DispatchQueue.main.async {
//                self.playersTableView.reloadData()
//            }
//        }
//        stats.getTeamInfo{
//            DispatchQueue.main.async {[self] in
//                let logostring = String(self.stats.teaminfo[0].TeamID)
//                self.teamLogoImage.image = UIImage(named: logostring)
//                print ("#" + self.stats.teaminfo[0].PrimaryColor)
//                let logocolor = UIColor(hex: "#" + self.stats.teaminfo[0].PrimaryColor)
//                print (logocolor)
//                self.teamColorImage.backgroundColor = logocolor
//                //cell.logoImageView?.image = UIImage(named: String(stats.standings[indexPath.row].TeamID))
//            }
//        }
//
//        stats.getTeamStats {
//            DispatchQueue.main.async {[self] in
//
//                let fgp = stats.getWholePercentage(made: self.stats.teamstats[0].FieldGoalsMade, attempted: self.stats.teamstats[0].FieldGoalsAttempted)
//
//                let tgp = stats.getWholePercentage(made: self.stats.teamstats[0].ThreePointersMade, attempted: self.stats.teamstats[0].ThreePointersAttempted)
//
//                let ftp = stats.getWholePercentage(made: self.stats.teamstats[0].FreeThrowsMade, attempted: self.stats.teamstats[0].FreeThrowsAttempted)
//
//                self.fieldGoalPercentage.text = fgp + "%" + " " + tgp + "%" + " " + ftp + "%"
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playersTableView.delegate = self
        playersTableView.dataSource = self
        
        stats.getPlayersbyTeam{
            DispatchQueue.main.async {
                self.playersTableView.reloadData()
            }
        }
        stats.getTeamInfo{
            DispatchQueue.main.async {[self] in
                let logostring = String(self.stats.teaminfo[0].TeamID)
                self.teamLogoImage.image = UIImage(named: logostring)
                print ("#" + self.stats.teaminfo[0].PrimaryColor)
                let logocolor = UIColor(hex: "#" + self.stats.teaminfo[0].PrimaryColor)
                print (logocolor)
                self.teamColorImage.backgroundColor = logocolor
                //cell.logoImageView?.image = UIImage(named: String(stats.standings[indexPath.row].TeamID))
            }
        }
       
        stats.getTeamStats {
            DispatchQueue.main.async {[self] in
                
                let fgp = stats.getWholePercentage(made: self.stats.teamstats[0].FieldGoalsMade, attempted: self.stats.teamstats[0].FieldGoalsAttempted)

                let tgp = stats.getWholePercentage(made: self.stats.teamstats[0].ThreePointersMade, attempted: self.stats.teamstats[0].ThreePointersAttempted)
          
                let ftp = stats.getWholePercentage(made: self.stats.teamstats[0].FreeThrowsMade, attempted: self.stats.teamstats[0].FreeThrowsAttempted)
    
                self.fieldGoalPercentage.text = "FGP:" + fgp + "%" + " " + tgp + "%" + " " + ftp + "%"
            }
        }
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
        let mystring = stats.players[indexPath.row].FirstName + " " + stats.players[indexPath.row].LastName + "   " + stats.players[indexPath.row].Position + "  " + String(stats.players[indexPath.row].Jersey)
        cell.playerNameLabel.text = mystring
        //cell.playerNumberLabel.text = String(stats.players[indexPath.row].Jersey)
        //cell.playerPositionLabel.text = stats.players[indexPath.row].Position
        cell.playerImage.downloaded(from: stats.players[indexPath.row].PhotoUrl)
        
        return cell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}
