//
//  Models.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/11/22.
//

// Create class Stats which will hold variables for whole app (first try standings)
// Implement methods in this class to be used in other views




import Foundation

class Stats{
    
    @Published var conferenceselected = "Eastern"
    @Published var standingTeamlogoURL = ""
    @Published var currentDate = ""
    @Published var ifanygames = false
    var chosenteam = "MIA"
    
    struct ReturnedGames: Codable{
        var AwayTeam: String?
        var HomeTeam: String?
        var AwayTeamScore: Int?
        var HomeTeamScore: Int?
        var GlobalGameID: Int?
        var TimeRemainingMinutes: Int?
        var TimeRemainingSeconds: Int?
        var Status: String?
    }
    
    struct Returned: Codable{
        var TeamID: Int
        var Name: String
        var Conference: String
        var Wins: Int
        var Losses: Int
    }
    
    struct Teams: Decodable{
        var TeamID: Int
        var Key: String
        var City: String
        var Name: String
        var WikipediaLogoUrl: String
    }
    
    struct Players: Decodable{
        var FirstName: String
        var LastName: String
        var PhotoUrl: String
        var Position: String
        var Jersey: Int
        //
        
    }
    
    struct Teamslogo: Decodable{
        var TeamID: Int
        var Key: String
        var City: String
        var Name: String
        var WikipediaLogoUrl: String
    }
    
    
    var livegames: [ReturnedGames] = []
    var standings: [Returned] = []
    var teamslogo: [Teamslogo] = []
    var players: [Players] = []
    var team =  [Teams]()
    
    func getcurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        currentDate = dateFormatter.string(from: date)
    }
    
    func getLiveGames(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/\(self.currentDate)?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        
        print ("We are accessing \(urlString)")
        
        
        guard let url = URL(string: urlString) else{
            print ("Error: Could not create a URL from \(urlString)")
            completed()
            return
        }
        
        // Create url session
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error{
                print ("Error: \(error.localizedDescription)")
            }
            // Deal with data
            do{
                //self.livegames = try JSONDecoder().decode([ReturnedGames].self, from: data!)
                let decodedresponse = try JSONDecoder().decode([ReturnedGames].self, from: data!)
                let filteredresponse = decodedresponse.filter {$0.AwayTeamScore != nil}
               DispatchQueue.main.async {
                    self.livegames = filteredresponse
                }
                //print ("Here is what we got back \(self.standings)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
    func getstandingsData(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Standings/2022?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        
        //print ("We are accessing \(urlString)")
        
        
        guard let url = URL(string: urlString) else{
            print ("Error: Could not create a URL from \(urlString)")
            completed()
            return
        }
        
        // Create url session
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error{
                print ("Error: \(error.localizedDescription)")
            }
            // Deal with data
            do{
                //self.standings = try JSONDecoder().decode([Returned].self, from: data!)
                let decodedresponse = try JSONDecoder().decode([Returned].self, from: data!)
                let filteredresponse = decodedresponse.filter {$0.Conference == self.conferenceselected}
                DispatchQueue.main.async {
                    self.standings = filteredresponse
                }
                //print ("Here is what we got back \(self.standings)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
    func getTeams(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/teams?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        
        //print ("We are accessing \(urlString)")
        
        
        guard let url = URL(string: urlString) else{
            print ("Error: Could not create a URL from \(urlString)")
            completed()
            return
        }
        
        // Create url session
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error{
                print ("Error: \(error.localizedDescription)")
            }
            // Deal with data
            do{
                self.team = try JSONDecoder().decode([Teams].self, from: data!)
                //let decodedresponse = try JSONDecoder().decode([Returned].self, from: data!)
                //let filteredresponse = decodedresponse.filter {$0.Conference == self.conferenceselected}
                //DispatchQueue.main.async {
                //    self.standings = filteredresponse
                //}
                print ("Here is what we got back \(self.team)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            
            completed()
        }
        task.resume()
    }

    func getPlayersbyTeam(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Players/\(self.chosenteam)?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        
        //print ("We are accessing \(urlString)")
        
        
        guard let url = URL(string: urlString) else{
            print ("Error: Could not create a URL from \(urlString)")
            completed()
            return
        }
        
        // Create url session
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error{
                print ("Error: \(error.localizedDescription)")
            }
            // Deal with data
            do{
                self.players = try JSONDecoder().decode([Players].self, from: data!)
                //let decodedresponse = try JSONDecoder().decode([Returned].self, from: data!)
                //let filteredresponse = decodedresponse.filter {$0.Conference == self.conferenceselected}
                //DispatchQueue.main.async {
                //    self.standings = filteredresponse
                //}
                print ("Here is what we got back \(self.players)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            
            completed()
        }
        task.resume()
    }
    func getTeamLogo(teamID: Int){
        
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/teams?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        
        //print ("We are accessing \(urlString)")
        
        
        guard let url = URL(string: urlString) else{
            print ("Error: Could not create a URL from \(urlString)")
            return
        }
        
        // Create url session
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error{
                print ("Error: \(error.localizedDescription)")
            }
            // Deal with data
            do{
                //self.standings = try JSONDecoder().decode([Returned].self, from: data!)
                let decodedresponse = try JSONDecoder().decode([Teamslogo].self, from: data!)
                let filteredresponse = decodedresponse.filter {$0.TeamID == teamID}
                
                DispatchQueue.main.async {
                    self.teamslogo = filteredresponse
                    for team in self.teamslogo{
                        self.standingTeamlogoURL = team.WikipediaLogoUrl
                    }
                    //self.standingTeamlogoURL = filteredresponse
                }
                //print ("Here is what we got back \(self.teamslogos)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}

