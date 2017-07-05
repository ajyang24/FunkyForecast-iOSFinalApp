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
    var locations = [[String: String]]()

    @IBOutlet var moreInfoView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var locationsView: UIView!

    
    @IBOutlet weak var todayLow: UILabel!
    @IBOutlet weak var todayHigh: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    
    
    var effect:UIVisualEffect!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let location = locations[]
//        quoteLabel.text = "Test"
//        currentTemp.text = location["temp_f"]
        
        let currentWeatherUrl = "https://api.wunderground.com/api/bf7798dd77b9bf97/conditions/q/IL/Barrington.json"
        let hourlyWeatherUrl = "https://api.wunderground.com/api/bf7798dd77b9bf97/hourly/q/IL/Barrington.json"
        let sevenDayForecastUrl = "https://api.wunderground.com/api/bf7798dd77b9bf97/forecast7day/q/IL/Chicago.json"
        
        if let url1 = URL(string: currentWeatherUrl)
        {
            if let myData = try? Data(contentsOf: url1, options: [])
            {
                let json = JSON(myData)
                parse(myData: json)
            }
        }
        
        if let url2 = URL(string: hourlyWeatherUrl)
        {
            if let myData2 = try? Data(contentsOf: url2, options: [])
            {
                let json = JSON(myData2)
                parse2(myData2: json)
            }
        }
        
        if let url3 = URL(string: sevenDayForecastUrl)
        {
            if let myData3 = try? Data(contentsOf: url3, options: [])
            {
                let json = JSON(myData3)
                parse3(myData3: json)
            }
        }

        
//        effect = visualEffectView.effect
//        visualEffectView.effect = nil
        visualEffectView.alpha = 0
//        moreInfoView.layer.cornerRadius = 5
//        
//        
        imageView.image = UIImage(named: "image2")
        sideBar = SideBar(sourceView: self.view, menuItems: ["Locations", "Settings", "About"])
        sideBar.delegate = self
        
        locationsView.alpha = 0

    }
    
    func parse(myData:JSON)
    {
        for i in myData["current_observation"].arrayValue
        {
            let fullName = i["full"].stringValue
            let country = i["country"].stringValue
            let zip = i["zip"].stringValue
            let latitude = i["latitude"].stringValue
            let longitude = i["longitude"].stringValue
            let elevation = i["elevation"].stringValue
            let tempF = i["temp_f"].stringValue
            let tempC = i["temp_c"].stringValue
            let humidity = i["relative_humidity"].stringValue
            let weather = i["weather"].stringValue
            let windString = i["wind_string"].stringValue
            let windDir = i["wind_dir"].stringValue
            let windMph = i["wind_mph"].stringValue
            let windKph = i["wind_kph"].stringValue
            let dewpointF = i["dewpoint_f"].stringValue
            let dewpointC = i["dewpoint_C"].stringValue
            let windchillF = i["windchill_f"].stringValue
            let windchillC = i["windchill_c"].stringValue
            let feelsLikeF = i["feelslike_f"].stringValue
            let feelsLikeC = i["feelslike_c"].stringValue
            let visibilityMi = i["visibility_mi"].stringValue
            let visibilityKm = i["visibility_km"].stringValue
            let uvIndex = i["UV"].stringValue
            
            let obj = ["full": fullName, "country": country, "zip": zip, "latitude": latitude, "longitude": longitude, "elevation": elevation, "temp_f": tempF, "temp_c": tempC, "relative_humidity": humidity, "weather": weather, "wind_string": windString, "wind_dir": windDir, "wind_mph": windMph, "wind_kph": windKph, "dewpoint_f": dewpointF, "dewpoint_c": dewpointC, "windchill_f": windchillF, "windchill_c": windchillC, "feelslike_f": feelsLikeF, "feelslike_c": feelsLikeC, "visibility_mi": visibilityMi, "visibility_km": visibilityKm, "UV": uvIndex]
            locations.append(obj)
        }
    }
    
    func parse2(myData2:JSON)
    {
        for j in myData2["hourly_forecast"].arrayValue
        {
            let hourlyAmPmTime = j["FCTTIME"]["civil"].stringValue
            let hourly24Time = j["FCTTIME"]["hour"].stringValue
            let hourlyTempF = j["temp"]["english"].stringValue
            let hourlyTempC = j["temp"]["metric"].stringValue
            let hourlyCondition = j["condition"].stringValue
            let hourlyCondition2 = j["wx"].stringValue
            
            let obj2 = ["civil": hourlyAmPmTime, "hour": hourly24Time, "english": hourlyTempF, "metric": hourlyTempC, "condition": hourlyCondition, "condition2": hourlyCondition2]
            locations.append(obj2)
            
            
        }
    }

    func parse3(myData3:JSON)
    {
        for k in myData3["simpleforecast"]["forecastday"].arrayValue
        {
            let day = k["weekday"].stringValue
            let dailyHighF = k["high"]["fahrenheit"].stringValue
            let dailyHighC = k["high"]["celsius"].stringValue
            let dailyLowF = k["low"]["fahrenheit"].stringValue
            let dailyLowC = k["low"]["celsius"].stringValue
            let dailyConditions = k["conditions"].stringValue
            
            let obj3 = ["weekday": day, "fahrenheit": dailyHighF, "celsius": dailyHighC, "fahrenheit": dailyLowF, "celsius": dailyLowC, "conditions": dailyConditions]
            
            locations.append(obj3)
  
        }
    }
    
    func animateIn()
    {

        moreInfoView.layer.cornerRadius = 5
        
        self.view.addSubview(moreInfoView)
        moreInfoView.center = self.view.center
        
        moreInfoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        moreInfoView.alpha = 0
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.4)
        {
            self.effect = self.visualEffectView.effect
            self.visualEffectView.effect = nil
            self.visualEffectView.effect = self.effect
            self.visualEffectView.alpha = 1
            self.moreInfoView.alpha = 1
            self.moreInfoView.transform = CGAffineTransform.identity

        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.5, animations: {
            self.moreInfoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.moreInfoView.alpha = 0
            self.visualEffectView.alpha = 0

            
        }) { (success:Bool) in
            self.moreInfoView.removeFromSuperview()
        }
    }
    
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        animateOut()
    }
    
    
    func sideBarDidSelectButtonAtIndex(_ index: Int) {
        if index == 0{
            locationsView.alpha = 1
        } else if index == 1{
            view.tintColor = UIColor.black
        }
    }


}
