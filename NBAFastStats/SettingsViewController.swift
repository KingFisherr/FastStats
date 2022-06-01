//
//  SettingsViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/22/22.
//

import UIKit

// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

// https://mobiraft.com/ios/swift/swift-recipe/convert-hex-colour-to-uicolor/
extension UIColor {
    convenience init?(_ string: String) {
        let hex = string.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        if #available(iOS 13, *) {
            //If your string is not a hex colour String then we are returning white color. you can change this to any default colour you want.
            guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return nil }

            let a, r, g, b: Int32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }

            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)

        } else {
            var int = UInt32()

            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }

            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        }
    }
}

// StackOverflow
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
        

        stats.getPlayersBySavedTeam{
            DispatchQueue.main.async {
                self.playersTableView.reloadData()
            }
        }
        stats.getTeamInfoBySavedTeam{
            DispatchQueue.main.async {[self] in
                let logostring = String(self.stats.teaminfo[0].TeamID)
                self.teamLogoImage.image = UIImage(named: logostring)
                
                let selectedteam = (stats.teaminfo[0].City + " " + stats.teaminfo[0].Name).uppercased()
                teamLabel.text = selectedteam
                
                //print ("#" + self.stats.teaminfo[0].PrimaryColor)
                let hexcode = "#" + self.stats.teaminfo[0].PrimaryColor
                let teambackcolor = UIColor(hexcode)
                //let logocolor = UIColor(hex: "#" + self.stats.teaminfo[0].PrimaryColor)?.cgColor
                //print (logocolor)
                self.teamColorImage.backgroundColor = teambackcolor
                //cell.logoImageView?.image = UIImage(named: String(stats.standings[indexPath.row].TeamID))
            }
        }
       
        stats.getTeamStats {
            DispatchQueue.main.async {[self] in
                
                let fgp = stats.getWholePercentage(made: self.stats.teamstats[0].FieldGoalsMade, attempted: self.stats.teamstats[0].FieldGoalsAttempted)

                let tgp = stats.getWholePercentage(made: self.stats.teamstats[0].ThreePointersMade, attempted: self.stats.teamstats[0].ThreePointersAttempted)
          
                let ftp = stats.getWholePercentage(made: self.stats.teamstats[0].FreeThrowsMade, attempted: self.stats.teamstats[0].FreeThrowsAttempted)
    
                self.fieldGoalPercentage.text = fgp + "%" + "|" + tgp + "%" + "|" + ftp + "%"
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
        cell.playerImage.downloaded(from: stats.players[indexPath.row].PhotoUrl)
        
        return cell
    }
    // Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rTransfrom = CATransform3DTranslate(CATransform3DIdentity, 0, 75, 0)
        cell.layer.transform = rTransfrom
        cell.alpha = 0.0
        
        UIView.animate(withDuration: 0.7){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
