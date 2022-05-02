//
//  SettingsPickerViewController.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/29/22.
//

import UIKit

protocol NewFavTeam{
    func passDataBack(data:String)
}

class SettingsPickerViewController: UIViewController {
    
    @IBOutlet weak var teamsPicker: UIPickerView!
    @IBOutlet weak var teamPicked: UILabel!
    
    var stats = Stats()
    var delegate: NewFavTeam?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsPicker.delegate = self
        teamsPicker.dataSource = self
        
        stats.getTeams {
            DispatchQueue.main.async { [self] in
                //self.teamsPicker.reloadAllComponents()
                self.teamsPicker.reloadComponent(0)
            }
        }
    }
    
    @IBAction func passSavedTeamBack(_ sender: Any) {
        delegate?.passDataBack(data: teamPicked.text!)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension SettingsPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stats.team.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stats.team[row].Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedteam = stats.team[row].Name
        teamPicked.text = selectedteam
    }
    
}
