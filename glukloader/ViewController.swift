//
//  ViewController.swift
//  glukloader
//
//  Created by Alex Normand on 6/21/18.
//  Copyright © 2018 Alex Normand. All rights reserved.
//

import UIKit
import OAuth2

class ViewController: UIViewController {
    var loader: OAuth2DataLoader?
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": GlukitSecrets.clientId,
        "client_secret": GlukitSecrets.clientSecret,
        "consumer_key": GlukitSecrets.clientId,
        "consumer_secret": GlukitSecrets.clientSecret,
        "authorize_uri": "https://glukit.appspot.com/authorize",
        "token_uri": "https://glukit.appspot.com/token",
        "scope": "",
        "redirect_uris": ["x-glukloader://oauth/callback"],
        "keychain": true
        ] as OAuth2JSON)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.authorizeContext = self
        oauth2.logger = OAuth2DebugLogger(.trace)
        oauth2.authorize(callback:{ authParameters, error in
            if let params = authParameters {
                print("Authorized! Access token is in `oauth2.accessToken`")
                print("Authorized! Additional parameters: \(params)")
            }
            else {
                print("Authorization was canceled or went wrong: \(String(describing: error))")   // error will not be nil
            }
        })
    }
    
    func didGetUserdata(dict: [String: Any], loader: OAuth2DataLoader?) {
        print("Got data: \(dict)")
    }
    
    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

