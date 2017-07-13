//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/23/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class ViewController : UIViewController
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
    
    
    @IBOutlet weak var startLabel: UILabel!
   
    @IBOutlet weak var titelLabel: UILabel!
    
    

    override func viewDidLoad()
    {
        startLabel.alpha = 0
        
        
        UIView.animate(withDuration: 3.3, animations: {
            self.startLabel.alpha = 1})
        
        UIView.animate(withDuration: 3.3, animations: {
            self.startLabel.alpha = 0})
        
        UIView.animate(withDuration: 3.3, animations: {
            self.startLabel.alpha = 1})
        
        
    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    
    
    
}




