//
//  FacebookOrEmailVC.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/5/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookOrEmailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.ds.REF_BASE.childByAppendingPath("LCC").queryOrderedByValue().queryLimitedToLast(3).observeEventType(.ChildAdded, withBlock: { snapshot in
            print("The \(snapshot.key) dinosaur's score is \(snapshot.value)")
            print("nigger")
        })
        /*DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("993").childByAppendingPath("highscore").setValue("12")
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("993").childByAppendingPath("playerName").setValue("nigger")
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("994").childByAppendingPath("highscore").setValue("15")
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("994").childByAppendingPath("playerName").setValue("faggot")
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FacebookButton(sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        
    facebookLogin.logInWithReadPermissions(["email"]) {
            (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
        
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            }
            else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Login failed. \(error)")
                    }
                    else {
                        //get the name and email of whoever locked in through facebook
                        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken, version: nil, HTTPMethod: "GET")
                        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                            if(error == nil)
                            {
                                print("result \(result)")
                                print(result.valueForKey("name") as! String)
                            }
                            else
                            {
                                print("error \(error)")
                            }
                        })
                        //end of getting email and name with accesstoken through facebook
                        DataService.ds.REF_USERS.childByAppendingPath(authData.uid).childByAppendingPath("pickedSchool").observeSingleEventOfType(.Value, withBlock: { snapshot in
                            if snapshot.value as? Bool == true {
                                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                                self.performSegueWithIdentifier("logInNoNeedForSchoolPick", sender: nil)
                                print("worked")
                            }
                            else {
                                DataService.ds.REF_USERS.childByAppendingPath(authData.uid).childByAppendingPath("pickedSchool").setValue(false)
                                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                                self.performSegueWithIdentifier("fbFirstTime", sender: nil)
                            }
                        })
                    }
                    
                })
            }
        }
        
        
        
    }
    
   

}
