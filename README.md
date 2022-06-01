# NBA FastStats

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema/Walkthrough](#Schema)

## Overview
### Description
NBA FASTSTATS is an iOS Application providing real time and historial NBA statistics via sportsdata.io API

### App Evaluation

- **Category:** Sports/Betting
- **Mobile:** This app would be primarily developed for mobile but would be as functional on the web, similar to ESPN and HULU. Functionality wouldn’t be limited to mobile devices; however, the mobile version allows users to have portability view games almost anywhere and at any time. 
- **Story:** NBA FASTSTATS starts with the current date live games to show users what they want to see first, other screens include game details, standings, myTEAM and other details.
- **Habit:** Users will find the NBA FASTSTATS fast and intuitie, easy to use just by pulling up the app and finding what you want in 5 taps or less. 
- **Scope:** NBA FASTSTATS is geared to allow users to easily browse and find the games they wish to see. Users will be able to quickly see if their favorite team is playing, the score, the details of the game, etc.

## Product Spec

### 2. Screen Archetypes

* Live Games Screen
   * Shows if any games are live at the moment, retrieves live game scores, live game time, and teams . 
* Live Game Details Screen
   * Shows the user the details of live games for both away and home team.
* Standings Screen
   * Shows the user the live NBA Standings of the current season by date. 
* MyTeam Screens
   * Shows the user selected and saved team details and the player details by team.
* Picker Screen
   * Users can choose any team from this picker screen.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Live Games
* NBA Standings
* MyTEAMS

## Wireframes
**Digital Mockup:**
###  Digital Wireframes & Mockups
<img src='https://i.imgur.com/Juvg4oQ.png'
 width=600>

## Schema

### Models

| Property | Type | Description |
| -------- | -------- | -------- |
| gameID  |string| unique game ID 
| playerID| string| unique player ID
| teamID| string| unique team ID
| LiveGames|array| Holds all live games for a certain date
|PlayersByTeam| array| Holds all players for a certain team
|LiveGameDetails|array|Holds all game stats for a certain game
|LogoByTeam|array|Holds logos for a certain game
|TeamStats|array|Holds all team stats for a certain team

### Networking (requests by screen)

#### Live Games Screen
    -(READ/GET) Queries the live games given by getCurrentDate()
            
    func getLiveGames(completed: @escaping ()->()){

        let urlString = API
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
    -(READ/GET) Queries the team logo

#### Live Game Details Screen
    -(READ/GET) Queries the live games details given by given gameID
    -(READ/GET) Queries the player headshots
    -(READ/GET) Queries the player stats
    -(READ/GET) Queries the team logo    

#### Standings Screen
    -(READ/GET) Queries the live standings
    -(READ/GET) Queries the team logo             
#### MyTeams Screen
    -(READ/GET) Queries team info by teamID
    -(READ/GET) Queries the team logo    
    -(READ/GET) Queries the player headshots
    -(READ/GET) Queries the player stats   

## Live Games and Game Details Walkthrough

<img src='https://i.imgur.com/wPpdvLq.gif' title='Video Walkthrough' width='200' alt='Video Walkthrough' />

## Standings Walkthrough


<img src='https://i.imgur.com/yHlhP3y.gif' title='Video Walkthrough' width='200' alt='Video Walkthrough' />



## MyTeams Walkthrough

<img src='https://i.imgur.com/bmX9Pp4.gif' title='Video Walkthrough' width='200' alt='Video Walkthrough' />