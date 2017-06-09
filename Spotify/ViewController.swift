//
//  ViewController.swift
//  Spotify
//
//  Created by devMachine on 6/8/17.
//  Copyright © 2017 devMachine. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation

class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    
    /* Initialized in either updateAfterFirstLogin: (if first time login) or in viewDidLoad
       (when there is a check for a session */
    
    var player: SPTAudioStreamingController?
    var loginURL: URL?
    
    // OUTLETS
    
    @IBOutlet var loginButton: UIButton!
    
    
    
    // METHODS
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSucessful"), object: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setup() {
        
        let redirectURL = "spotify-login://callback"
        let clientID = "75446d76f0e9434b98d850c96fa15185"
        auth.redirectURL = URL(string: redirectURL)
        auth.clientID = ""
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginURL = auth.spotifyAppAuthenticationURL()

//        
//        
//        SPTAuth.defaultInstance().clientID = "75446d76f0e9434b98d850c96fa15185"
//        SPTAuth.defaultInstance().redirectURL = URL(string:"spotify-login://callback")
//        loginURL = SPTAuth.defaultInstance().spotifyAppAuthenticationURL()
        
    }

    

//    @IBAction func loginBtnPressed(_ sender: Any) {
//        
//        print("Button pressed")
//        
//        if UIApplication.shared.openURL(loginURL!){
//            
//            print("at step 2")
//            
//            if auth.canHandle(auth.redirectURL){
//                // To do = build in error handling
//            }
//        }
//        
//        
//        
//    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
    
            if UIApplication.shared.canOpenURL(loginURL!){
                UIApplication.shared.open(loginURL!, options: [:], completionHandler: nil)
                  if auth.canHandle(auth.redirectURL){
                        // To do = build in error handling
                        print("test")
                  }
            }

            else{
                    print("couldn't open")
            }
    
        UIApplication.shared.open(loginURL!, options: [:], completionHandler: nil)

    
    }
    
    
    
    
    func updateAfterFirstLogin () {
        
        loginButton.isHidden = true
        let userDefaults = UserDefaults.standard
        
        if let sessionObj: AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with:sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
            loginButton.isHidden = true
        }
    }
    
    
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            
        }
    }
    
    
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!){
        
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method is called
        
        print("logged in")
        
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            
            if(error != nil){
                
                print("playing!")
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

