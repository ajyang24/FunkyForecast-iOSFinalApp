//
//  ViewController.swift
//  FunkyForecast
//
//andrew was here
//  Created by Andrew Yang on 6/28/17.
//  Copyright © 2017 Andrew Yang. All rights reserved.
//  Changed 6/28/17 on 1:02:11 PM

import UIKit

class ViewController: UIViewController
{

    struct AppUtility
    {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask)
        {
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate
            {
                delegate.orientationLock = orientation
            }
        }
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    
    
 


}

