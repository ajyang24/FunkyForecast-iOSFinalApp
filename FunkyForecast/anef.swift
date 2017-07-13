//
//  Sai.swift
//  Breakout
//
//  Created by Sai Girap on 6/21/17.
//  Copyright © 2017 Sai Girap. All rights reserved.
//



protocol Alertable { }
extension Alertable where Self: DetailViewController {
    
    
    
    func showAlert(withTitle title: String, message: String)
    {
        
        
        var alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in  }
        alertController.addAction(okAction)
        
        
        view?.window?.rootViewController?.present(alertController, animated: true)
        
    }
    
    func gameOverAlert(withTitle title: String, message: String)
        {
            
            func playGame()
            {
                scene?.view?.isPaused = false
            }
            
            
            var alertController2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .cancel) { (action) -> Void in playGame() }
            alertController2.addAction(restartAction)
            
            
            view?.window?.rootViewController?.present(alertController2, animated: true)
    
        }
    
    func nextLevelAlert(withTitle title: String, message: String)
    {
        
        func playGame()
        {
            scene?.view?.isPaused = false
        }
        
        
        var alertController3 = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let nextLevel = UIAlertAction(title: "Next Level", style: .cancel) { (action) -> Void in playGame()
        }
        alertController3.addAction(nextLevel)
        
        
        view?.window?.rootViewController?.present(alertController3, animated: true)
        
    }
    
    

}
