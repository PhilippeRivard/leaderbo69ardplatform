//
//  ViewController.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/3/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import AVFoundation

class LeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var highScore: String?
    var currentPlayerName: String?
    var counter = 0
    var players = [Player]()
    var numberOfNodes: Int?
    var backwardsArrayFinished = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urmom").setValue(16)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urdad").setValue(12)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urbro").setValue(1)
 */
 
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            self.numberOfNodes = Int(snapshot.childrenCount)
            
            self.tableView.reloadData()
        })
        
        DataService.ds.REF_BASE.childByAppendingPath("LCC").queryOrderedByValue().observeEventType(.ChildAdded, withBlock: { snapshot in
            //print("The \(snapshot.key) dinosaur's score is \(snapshot.value)")
            
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
        })
        
        
        
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell", forIndexPath: indexPath) as? RankingCell {
            let player: Player!
            
            if players.count == numberOfNodes {
                if backwardsArrayFinished == false {
                    players = players.reverse()
                    backwardsArrayFinished = true
                }
                
                player = players[indexPath.row]
                print("not nil")
                cell.configureCell(player, number: indexPath.row)
                print(players[indexPath.row].highscore)
            }
            
            
          
            
            
            
            return cell
        }
            
        
        else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

