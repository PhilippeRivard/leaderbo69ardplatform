//
//  SchoolLeaderboardVC.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/15/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class SchoolLeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var rankingStaticLabel: UILabel!
    
    @IBOutlet weak var playerStaticLabel: UILabel!
    
    @IBOutlet weak var scoreStaticLabel: UILabel!
    
    @IBOutlet weak var schoolSignUpBtn: UIButton!
    
    
    var highScore: String?
    var currentPlayerName: String?
    var counter = 0
    var players = [Player]()
    var numberOfNodes: Int?
    var backwardsArrayFinished = false
    var childWasAdded = false
    var mySchool: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.hidden = true
        schoolNameLabel.hidden = true
        rankingStaticLabel.hidden = true
        playerStaticLabel.hidden = true
        scoreStaticLabel.hidden = true
        print("gay")
        
        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("school").observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("pussy")
            if snapshot.value as? String != nil {
                print("there is a school")
                self.schoolSignedUp()
                self.mySchool = snapshot.value as! String
                self.schoolNameLabel.text = snapshot.value as! String
                DataService.ds.REF_BASE.childByAppendingPath(self.mySchool).observeSingleEventOfType(.Value, withBlock: {
                    snapshot in
                    self.numberOfNodes = Int(snapshot.childrenCount)
                    print("number of nodes: \(self.numberOfNodes)")
                })
                self.redoPopulate()
                
            }
            else {
                self.noSchoolSignedUp()
            }
            print(String(snapshot.value))
            /*
             if snapshot.value != nil {
             self.tableView.hidden = false
             }
             */
        })
        
        print("fag")
        if mySchool != nil {
            DataService.ds.REF_BASE.childByAppendingPath(mySchool).observeEventType(.ChildChanged, withBlock: { snapshot in
                
                self.childWasAdded = true
                self.redoPopulate()
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                DataService.ds.REF_BASE.childByAppendingPath(mySchool).removeAllObservers()
                
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
    
    func redoPopulate() {
        players.removeAll()
        backwardsArrayFinished = false
        DataService.ds.REF_BASE.childByAppendingPath(mySchool).observeEventType(.ChildAdded, withBlock: { snapshot in
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
            
        })
    }
    @IBAction func onFriendsBtnPressed(sender: AnyObject) {
    }
    
    @IBAction func onLocationBtnPressed(sender: AnyObject) {
    }
    
    
    @IBAction func onSchoolSignUpBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("PickSchoolVC", sender: nil)
        
    }
    
    
    func noSchoolSignedUp() {
        tableView.hidden = true
        schoolNameLabel.hidden = true
        rankingStaticLabel.hidden = true
        playerStaticLabel.hidden = true
        scoreStaticLabel.hidden = true
        schoolSignUpBtn.hidden = false
    }
    func schoolSignedUp() {
        tableView.hidden = false
        schoolNameLabel.hidden = false
        rankingStaticLabel.hidden = false
        playerStaticLabel.hidden = false
        scoreStaticLabel.hidden = false
        schoolSignUpBtn.hidden = true
    }
    

}
