//
//  Models.swift
//  NBAFastStats
//
//  Created by Tahsin Provath on 4/11/22.
//


import Foundation

class Stats{
    
    // stores segment selected standings
    @Published var conferenceselected = "Eastern"
    // For asset number
    @Published var standingTeamlogoURL = ""
    // Stores current date
    @Published var currentDate = ""
    // Stores if ReturnedGames array is empty or not
    @Published var ifanygames = true
    // Stores selected team for stats of fav team
    @Published var chosenteam = ""
    // Stores segment selected game details
    @Published var selectedTeam = 0
    // Stores selected team for headshots
    @Published var headshotselectedteam = ""
    
    let userDefaults = UserDefaults.standard
    
    // UPDATE IF TRIAL OVER
    var key = "d47e9c7c07774ad2b29650c8a04aed6f"
    
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
        var PlayerID: Int
        var Opponent: String
        var Minutes: Int
        var Team: String
        var Name: String
        var FantasyPoints: Double?
        var Points: Double?
        var Rebounds: Double?
        var Assists: Double?
    }
    
    struct PlayerHeadshots:Codable{
        var PlayerID: Int
        var PhotoUrl: String
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
    var playerheadshots: [PlayerHeadshots] = []
    var standings: [Returned] = []
    var players: [Players] = []
    var team =  [Teams]()
    var teamstats: [TeamStats] = []
    var teaminfo: [TeamInfo] = []
    
    
    // returns current date in x format
    func getcurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        currentDate = dateFormatter.string(from: date)
    }
    
    // returns whole number percent
    func getWholePercentage(made: Double, attempted: Double) -> String{
        let intodecimal = (made / attempted).truncatingRemainder(dividingBy: 1.0)
        let intopercentage = Int(intodecimal * 100.0)
        let intostring = String(intopercentage)
        return intostring
    }
    //https://api.sportsdata.io/v3/nba/scores/json/AreAnyGamesInProgress?key=d47e9c7c07774ad2b29650c8a04aed6f
    

    
    // Returns live games by current date
    func getLiveGames(completed: @escaping ()->()){
        //print (userDefaults.string(forKey: "favTeam"))

        //let urlString = "https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/\(self.currentDate)?key=\(self.key)"
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/\("2022-APR-25")?key=\(self.key)"
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
    
    // Returns player stats for a game
    func getGameDetailsByTeam(completed: @escaping ()->()){
        //let urlString = "https://api.sportsdata.io/v3/nba/stats/json/PlayerGameStatsByDate/\(self.currentDate)?key=\(self.key)"
        
        // FOR TESTING
        let urlString = "https://api.sportsdata.io/v3/nba/stats/json/PlayerGameStatsByDate/\("2022-APR-25")?key=\(self.key)"
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
    
    // Returns headshots for a team
    func getPlayersHeadShotsByTeam(completed: @escaping ()->()){
        
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Players/\(self.headshotselectedteam)?key=\(self.key)"
        
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

                self.playerheadshots = try JSONDecoder().decode([PlayerHeadshots].self, from: data!)
//                let decodedresponse = try JSONDecoder().decode([PlayerHeadshots].self, from: data!)
//                let filteredresponse = decodedresponse.filter {$0.Name == self.conferenceselected}
//                DispatchQueue.main.async {
//                    let filteredresponse = filteredresponse.sorted(by:{$0.Wins > $1.Wins})
//                    self.standings = filteredresponse
//                }
                //print ("Here is what we got back \(self.players)")
            }catch{
            print ("JSON Error: \(error.localizedDescription)")
            }
            
            completed()
        }
        task.resume()
    }
    
    // Returns standing data
    func getstandingsData(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Standings/2022?key=\(self.key)"
        
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
    
    // Returns all teams
    func getTeams(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/teams?key=\(self.key)"
        
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
                //print ("Here is what we got back \(self.team)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            
            completed()
        }
        task.resume()
    }

    // Returns player by saved team
    func getPlayersBySavedTeam(completed: @escaping ()->()){
        
        let favTeam = userDefaults.string(forKey: "favTeam") ?? "MIA"
        //let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Players/\(self.chosenteam)?key=\(self.key)"
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/Players/\(favTeam)?key=\(self.key)"
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
    
    // Returns stars for a saved fav team
    func getTeamStats(completed: @escaping ()->()){
        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/TeamSeasonStats/2022?key=\(self.key)"
        
        let favTeam = userDefaults.string(forKey: "favTeam") ?? "MIA"

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
    
    //Get team info by saved team
    func getTeamInfoBySavedTeam(completed: @escaping ()->()){
        
        let favTeam = userDefaults.string(forKey: "favTeam") ?? "MIA"

        let urlString = "https://api.sportsdata.io/v3/nba/scores/json/teams?key=\(self.key)"
        
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
                //print ("Here is what we got back \(self.teaminfo)")
            }catch{
                print ("JSON Error: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    
}


