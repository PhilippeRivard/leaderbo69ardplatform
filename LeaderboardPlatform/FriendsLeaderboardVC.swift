//
//  ViewController.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/3/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class FriendsLeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var highScore: String?
    var currentPlayerName: String?
    var counter = 0
    var players = [Player]()
    var numberOfNodes: Int?
    var backwardsArrayFinished = false
    var childWasAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urmom").setPriority(16)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urdad").setPriority(12)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urbro").setPriority(1)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("queef").setPriority(71)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("faggot").setPriority(5)
         
 */
        
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.Value, withBlock: { snapshot in
            self.players = []
            self.backwardsArrayFinished = false
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    let player = Player(playerName: snap.key, highscore: (snap.value as? Int)!)
                    self.players.append(player)
                    
                }
            }
            self.players = self.players.reverse()
            self.tableView.reloadData()
        })
        
        
        
        
        tableView.hidden = false
        /*
        DataService.ds.REF_USERS.childByAppendingPath("facebook:10209204778739230").childByAppendingPath("school").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value as? String != nil {
                self.tableView.hidden = false
                
            }
            print(String(snapshot.value))
            /*
            if snapshot.value != nil {
                self.tableView.hidden = false
            }
 */
        })
 */
        /*
 
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            self.numberOfNodes = Int(snapshot.childrenCount)
            
            self.tableView.reloadData()
        })
 */
        
        
        //IM NOT SURE IF I SHOULD USE QUERYORDEREDBYVALUE OR JUST REGULAR OBSERVE EVENT???????
        
        
        
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").queryOrderedByValue().observeEventType(.ChildAdded, withBlock: { snapshot in
            //print("The \(snapshot.key) dinosaur's score is \(snapshot.value)")
            
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
        })
        */
        
        //self.redoPopulate()
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.ChildAdded, withBlock: { snapshot in
            self.counter += 1
            if self.counter == self.numberOfNodes {
                self.redoPopulate()
            }
            
        })
         
         */
 
        
        /*
        
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.ChildChanged, withBlock: { snapshot in
            self.childWasAdded = true
            self.redoPopulate()
            
            
        })
 
        */
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let player = players[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell") as? RankingCell {
            cell.configureCell(player, number: indexPath.row)
             
            return cell
            
            
        }
 
        
        
        /*
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell", forIndexPath: indexPath) as? RankingCell {
            let player: Player!
            
            if players.count == numberOfNodes {
                if backwardsArrayFinished == false {
                    players = players.reverse()
                    backwardsArrayFinished = true
                }
                DataService.ds.REF_BASE.childByAppendingPath("LCC").removeAllObservers()
                
                player = players[indexPath.row]
                print("not nil")
                cell.configureCell(player, number: indexPath.row)
                print(players[indexPath.row].highscore)
            }
            
            
          
            
            
            
            return cell
        }
 */
            
        
        else {
            return RankingCell()
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
    
    func redoPopulate() {
        players.removeAll()
        backwardsArrayFinished = false
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.ChildAdded, withBlock: { snapshot in
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
            
        })
    }
    
    @IBAction func onSchoolBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("FriendsToSchool", sender: nil)
        
    }
    
    @IBAction func onLocationBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("FriendsToLocation", sender: nil)
    }
    


}

