//
//  Models.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/11/22.
//


import Foundation

class Stats{
    
    @Published var conferenceselected = "Eastern"
    @Published var standingTeamlogoURL = ""
    @Published var currentDate = ""
    @Published var ifanygames = true
    @Published var chosenteam = ""
    @Published var selectedTeam = 0
    let userDefaults = UserDefaults.standard

    struct ReturnedGames: Codable{
        var AwayTeam: String?
        var HomeTeam: String?
        var AwayTeamScore: Int?
        var HomeTeamScore: Int?
        var GlobalGameID: Int?
        var TimeRemainingMinutes: Int?
        var TimeRemainingSeconds: Int?
        var Status: String?
        var AwayTeamID: Int
        var HomeTeamID: Int
    }
    
    struct GameDetailsByTeam: Codable{
        var TeamID: Int
        var Name: String
        var FantasyPoints: Double?
        var Points: Double?
        var Rebounds: Double?
        var Assists: Double?
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
    }
    
    struct TeamStats: Decodable{
        var TeamID: Int
        var Team: String
        var Name: String
        var FieldGoalsMade: Double
        var FieldGoalsAttempted: Double
        var ThreePointersMade: Double
        var ThreePointersAttempted: Double
        var FreeThrowsMade: Double
        var FreeThrowsAttempted: Double
    }
    
    struct TeamInfo: Decodable{
        var TeamID: Int
        var Key: String
        var City: String
        var Name: String
        var PrimaryColor: String
        var SecondaryColor: String
        var WikipediaLogoUrl: String
    }
    
    
    var livegames: [ReturnedGames] = []
    var gamedetailsbyteam: [GameDetailsByTeam] = []
    var standings: [Returned] = []
    var players: [Players] = []
    var team =  [Teams]()
    var teamstats: [TeamStats] = []
    var teaminfo: [TeamInfo] = []
    
    func getcurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        currentDate = dateFormatter.string(from: date)
    }
    
    func getWholePercentage(made: Double, attempted: Double) -> String{
        let intodecimal = (made / attempted).truncatingRemainder(dividingBy: 1.0)
        let intopercentage = Int(intodecimal * 100.0)
        let intostring = String(intopercentage)
        return intostring
    }
    
    
    func checkForLiveGames(){
        // Call api to check if any live games are currently on
        // Return bool to ifanygames var
    }
    
    func getLiveGames(completed: @escaping ()->()){
        print (userDefaults.string(forKey: "favTeam"))

        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/\(self.currentDate)?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        //let urlString = "https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/\("2022-May-11")?key=5e6b9e63f405447dae1e7e39bbb02b3a"
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
    
    func getGameDetailsByTeam(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/stats/json/PlayerGameStatsByDate/\(self.currentDate)?key=5e6b9e63f405447dae1e7e39bbb02b3a"
      
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
                let decodedresponse = try JSONDecoder().decode([GameDetailsByTeam].self, from: data!)
                let filteredresponse = decodedresponse.filter {$0.TeamID == self.selectedTeam}
               DispatchQueue.main.async {
                    self.gamedetailsbyteam = filteredresponse
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
                    let filteredresponse = filteredresponse.sorted(by:{$0.Wins > $1.Wins})
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
        
        let favTeam = userDefaults.string(forKey: "favTeam")!
        //let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Players/\(self.chosenteam)?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Players/\(favTeam)?key=5e6b9e63f405447dae1e7e39bbb02b3a"
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
                //print ("Here is what we got back \(self.players)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            
            completed()
        }
        task.resume()
    }
    
    func getTeamStats(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/TeamSeasonStats/2022?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        
        let favTeam = userDefaults.string(forKey: "favTeam")!

        print (favTeam)
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
                let decodedresponse = try JSONDecoder().decode([TeamStats].self, from: data!)
                self.teamstats = decodedresponse.filter {$0.Team == favTeam}
                
                //print ("Here is what we got back \(self.teamstats)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
    func getTeamInfo(completed: @escaping ()->()){
        
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/teams?key=5e6b9e63f405447dae1e7e39bbb02b3a"
        
        let favTeam = userDefaults.string(forKey: "favTeam")!

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
                let decodedresponse = try JSONDecoder().decode([TeamInfo].self, from: data!)
                let filteredresponse = decodedresponse.filter {$0.Key == favTeam}
                
                DispatchQueue.main.async {
                    self.teaminfo = filteredresponse
                }
                print ("Here is what we got back \(self.teaminfo)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
}


