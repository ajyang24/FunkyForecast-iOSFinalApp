//
//  DetailViewController.swift
//  FunkyForecast
//
//  Created by Andrew Yang on 6/29/17.
//  Copyright © 2017 Andrew Yang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, SideBarDelegate
{
    var sideBar:SideBar = SideBar()

    @IBOutlet var moreInfoView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var effect:UIVisualEffect!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        moreInfoView.layer.cornerRadius = 5
        
        
        imageView.image = UIImage(named: "image2")
        sideBar = SideBar(sourceView: self.view, menuItems: ["first item", "second item", "funny item", "another item"])
        sideBar.delegate = self

    }

    func animateIn()
    {
        self.view.addSubview(moreInfoView)
        moreInfoView.center = self.view.center
        
        moreInfoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        moreInfoView.alpha = 0
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.4)
        {
            self.visualEffectView.effect = self.effect
            self.moreInfoView.alpha = 1
            self.moreInfoView.transform = CGAffineTransform.identity

        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.moreInfoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.moreInfoView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.moreInfoView.removeFromSuperview()
        }
    }
    
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        visualEffectView.alpha = 1
        animateIn()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        visualEffectView.alpha = 0
        animateOut()
    }
    
    
    func sideBarDidSelectButtonAtIndex(_ index: Int) {
        if index == 0{
            imageView.backgroundColor = UIColor.red
            imageView.image = nil
        } else if index == 1{
            imageView.backgroundColor = UIColor.clear
            imageView.image = UIImage(named: "image2")
        }
    }


}
