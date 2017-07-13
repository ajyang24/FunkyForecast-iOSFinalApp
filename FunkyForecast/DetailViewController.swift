//
//  DetailViewController.swift
//  FunkyForecast
//
//  Created by Andrew Yang on 6/29/17.
//  Copyright © 2017 Andrew Yang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class DetailViewController: UIViewController, SideBarDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate
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
    
    
    

    var sideBar:SideBar = SideBar()
    var dailyInfo = [[String: String]]()
    var hourlyInfo = [[String: String]]()
    var tempF = 0.0
    var tempC = 0.0
    var weather = ""
    var dewpointF = 0.0
    var dewpointC = 0.0
    var humidity = ""
    var fullName = ""
    var country = ""
    var zip = ""
    var latitude = ""
    var longitude = ""
    var elevation = ""
    var windString = ""
    var windDir = ""
    var windMph = 0.0
    var windKph = 0.0
    var windchillF = ""
    var windchillC = ""
    var feelsLikeF = ""
    var feelsLikeC = ""
    var visibilityMi = ""
    var visibilityKm = ""
    var uv = ""
    var lastUpdatedInfo = ""
    
    
    
    
    
    @IBOutlet weak var windchill: UILabel!
    @IBOutlet weak var uvIndex: UILabel!
    @IBOutlet weak var dewpoint: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var relativeHumidity: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var windDirection: UILabel!

    @IBOutlet var moreInfoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var stateLabel: UITextField!
    
    @IBOutlet weak var townLabel: UITextField!

    @IBOutlet weak var settingsView: UIView!
    
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var locationsView: UIView!

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var swipeRightImage: UIImageView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var weatherName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var lastUpdatedInfoLabel: UILabel!
    @IBOutlet weak var gifSwipeRightImageView: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    var locationsArray : [String] = []

    var state = ""
    var town = ""
    var townURL = ""
    
    var effect:UIVisualEffect!
    
    let manager = CLLocationManager()


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil
            {
                print ("THERE WAS AN ERROR")
            }
            else
            {
                if let place = placemark?[0]
                {
                    if place.subThoroughfare != nil
                    {
                        self.locationLabel.text = "\(place.locality!), \(place.administrativeArea!)"
                        self.state = place.administrativeArea!
                        self.town = place.locality!
                        self.townURL = self.town.replacingOccurrences(of: " ", with: "_")
                        

                    }
                }
            }
        }
    }

    var currentWeatherURL = ""
    var hourlyWeatherURL = ""
    var sevenDayForecastURL = ""
    var imageArray = [UIImage(named: "Clear"), UIImage(named: "Cloudy"), UIImage(named: "Fog"), UIImage(named: "Mostly Cloudy"), UIImage(named: "Partly Cloudy"), UIImage(named: "Rain"), UIImage(named: "snow")]
    var timeLabelArray = ["11AM", "12PM", "1PM", "2PM", "3PM", "4PM", "5PM", "6PM"]
    
    var tempLabelArray = ["75º", "72º", "71º", "72º", "81º", "70º", "76º","80º"]
    
    
    var image2Array = [UIImage(named: "Clear"), UIImage(named: "Cloudy"), UIImage(named: "fog"), UIImage(named: "Mostly Cloudy"), UIImage(named: "Partly Cloudy"), UIImage(named: "Rain"), UIImage(named: "snow")]
    
    var dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var dailyTempLowArray = ["75º", "72º", "71º", "72º", "81º", "70º", "76º"]
    
    var dailyTempHighArray = ["78º", "79º", "72º", "82º", "93º", "81º", "87º"]
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        let partlyCloudyQuoteArray = ["Cloudy with a chance of meatballs.", "Half and half.", "Look up."]
        let randomIndex = Int(arc4random_uniform(UInt32(partlyCloudyQuoteArray.count)))
        print(partlyCloudyQuoteArray[randomIndex])
        
        let overcastQuoteArray = ["Dark and cloudy.", "Gloomy. Hey at least it's not raining.", "Cheer up! Or be a grump."]
        let randomIndex1 = Int(arc4random_uniform(UInt32(overcastQuoteArray.count)))
        print(overcastQuoteArray[randomIndex])
        
        let sunnyQuoteArray = ["Finally. Sun.", "Stop checking the weather and get outside!", "Free tans!"]
        let randomIndex2 = Int(arc4random_uniform(UInt32(sunnyQuoteArray.count)))
        print(sunnyQuoteArray[randomIndex])
        
        let thunderQuoteArray = ["Boomshakalaka.", "Get inside!", "1 in 700,000."]
        let randomIndex3 = Int(arc4random_uniform(UInt32(thunderQuoteArray.count)))
        print(thunderQuoteArray[randomIndex3])
        
        let snowQuoteArray = ["Look outside.", "Where's my present?", "Who said Global Warming was real?"]
        let randomIndex4 = Int(arc4random_uniform(UInt32(snowQuoteArray.count)))
        print(snowQuoteArray[randomIndex4])
        
        let rainQuoteArray = ["Pitter patter.", "Don't forget your umbrella.", "Hey, free showers!"]
        let randomIndex5 = Int(arc4random_uniform(UInt32(rainQuoteArray.count)))
        print(rainQuoteArray[randomIndex5])
        
        let fogQuoteArray = ["Can't even see 100 feet ahead.", "Is it overcast? Or fog? Or both?", "What is fog?"]
        let randomIndex6 = Int(arc4random_uniform(UInt32(fogQuoteArray.count)))
        print(fogQuoteArray[randomIndex6])
        
        let windySunnyQuoteArray = ["Breezy, but nice.", "Don't get carried away!", "Perfect weather."]
        let randomIndex7 = Int(arc4random_uniform(UInt32(windySunnyQuoteArray.count)))
        print(windySunnyQuoteArray[randomIndex7])
        
        let windyOvercastQuoteArray = ["Breezy and cloudy.", "Don't get carried away!", "Gloomy and cloudy. Boohoo."]
        let randomIndex8 = Int(arc4random_uniform(UInt32(windySunnyQuoteArray.count)))
        print(windySunnyQuoteArray[randomIndex8])
        
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        currentWeatherURL = "https://api.wunderground.com/api/bf7798dd77b9bf97/conditions/q/\(state)/\(townURL).json"
        hourlyWeatherURL = "https://api.wunderground.com/api/bf7798dd77b9bf97/hourly/q/\(state)/\(townURL).json"
        sevenDayForecastURL = "https://api.wunderground.com/api/bf7798dd77b9bf97/forecast7day/q/\(state)/\(townURL).json"
        
        
        
        if let url1 = URL(string: currentWeatherURL)
        {
            if let myData = try? Data(contentsOf: url1, options: [])
            {
                let json = JSON(myData)
                parse(myData: json)
            }
        }
        
        if let url2 = URL(string: hourlyWeatherURL)
        {
            if let myData2 = try? Data(contentsOf: url2, options: [])
            {
                let json = JSON(myData2)
                parse2(myData2: json)
            }
        }
        
        if let url3 = URL(string: sevenDayForecastURL)
        {
            if let myData3 = try? Data(contentsOf: url3, options: [])
            {
                let json = JSON(myData3)
                parse3(myData3: json)
            }
        }

        visualEffectView.alpha = 0
        aboutView.alpha = 0
        locationsView.alpha = 0
        settingsView.alpha = 0
      
        imageView.image = UIImage(named: "image2")
        sideBar = SideBar(sourceView: self.view, menuItems: [ "Weather", "Locations", "Settings", "About ⓘ"])
        sideBar.delegate = self
        
        currentTemp.text = String(format: "%.0fºF", arguments: [tempF])
        print(lastUpdatedInfo)
        lastUpdatedInfoLabel.text = lastUpdatedInfo
        
        
        //locationLabel.text = fullName
        weatherName.text = weather
        
        
        windDirection.text = "Wind Direction: " + windDir
        visibility.text = "Visibility: " + visibilityMi + " Miles"
        feelsLike.text = "It Feels Like: " + feelsLikeF + "ºF"
        relativeHumidity.text = "Relative Humidity: " + humidity
        windSpeed.text = "Wind Speed: " + String(windMph) + " Mph"
        dewpoint.text = String(format: "Dewpoint: %.0fºF", arguments: [dewpointF])
        uvIndex.text! = "UV Index: " + uv
        if windchillF == "NA"
        {
            windchill.text = "Windchill: " + "NA"
        }
        else
        {
            windchill.text = "Windchill: " + windchillF + "ºF"
        }
        
        if weather .contains("Thunder") == true
        {
            weatherIcon.image = #imageLiteral(resourceName: "Thunderstorm")
        }
        else if weather.contains("Rain") == true
        {
            weatherIcon.image = #imageLiteral(resourceName: "Rain")
        }
        else
        {
        weatherIcon.image = UIImage(named: weather)
        } 
        self.hideKeyboardWhenTappedAround()

    }
   
    @IBAction func currentLocationButton(_ sender: Any)
    {
        
        let fullNameArr = locationLabel.text?.components(separatedBy: ", ")
        
        town = (fullNameArr?[0])!
        
        state = (fullNameArr?[1])!
        
        print(state + town)
        
        townURL = town.replacingOccurrences(of: " ", with: "_")
        //do something here after running your function
        
        UIView.animate(withDuration: 0.5, animations: {
        self.viewDidAppear(true)})
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = locationsArray[indexPath.row]
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == hourlyCollectionView
        {
            print(hourlyInfo.count)
            return hourlyInfo.count
            
        }
        else
        {
            print(dailyInfo.count)
            return dailyInfo.count
        }
        
    
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print("it worke")
        
        
        if collectionView == hourlyCollectionView
        {
            
            
            let cellA = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            
            
            
            let hourly = hourlyInfo[indexPath.row]
            
            if hourly["condition"]! .contains("Thunderstorm")
            {
            cellA.imgImage?.image = #imageLiteral(resourceName: "Thunderstorm")
            }
            
            else
            {
            cellA.imgImage?.image = UIImage(named: hourly["condition"]!)
            }
            
            var twelveHourTime: Int = Int(hourly["hour"]!)!
            
            if twelveHourTime>12
            {
                twelveHourTime -= 12
                cellA.hourlyTimeLabel?.text = String(twelveHourTime)
            }
            else if twelveHourTime == 0
            {
                twelveHourTime += 12
                cellA.hourlyTimeLabel?.text = String(twelveHourTime)
            }
            else
            {
                cellA.hourlyTimeLabel?.text = hourly["hour"]
            }
            cellA.hourlyTempLabel?.text = hourly["english"]!
                cellA.pmLabel?.text = hourly["ampm"]
            return cellA
            
            
        }
            
            
        else
        {
            print("Hello")
            let cellB = dailyCollectionView.dequeueReusableCell(withReuseIdentifier: "Image2CollectionViewCell", for: indexPath) as! Image2CollectionViewCell
            
            
            let daily = dailyInfo[indexPath.row]
            if daily["conditions"]! .contains("Thunder") == true
            {
                cellB.imgImage2?.image = #imageLiteral(resourceName: "Thunderstorm")
            }
            else
            {
            cellB.imgImage2?.image = UIImage(named: daily["conditions"]!)
            }
            cellB.dailyDayLabel?.text = daily["weekday"]
            cellB.dailyTempLowLabel?.text = daily["fahrenheitL"]
            cellB.dailyTempHighLabel?.text = daily["fahrenheitH"]
               
        
            
            return cellB
        }

        
       

    }
    
    

    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       

        
        
        

        
        

        
        


        
        
        AppUtility.lockOrientation(.portrait)
        
        print(lastUpdatedInfo)
        lastUpdatedInfoLabel.text = lastUpdatedInfo
        
        locationLabel.text = town + ", " + state
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        print(state)
        
        currentWeatherURL = "https://api.wunderground.com/api/bf7798dd77b9bf97/conditions/q/\(state)/\(townURL).json"
        hourlyWeatherURL = "https://api.wunderground.com/api/bf7798dd77b9bf97/hourly/q/\(state)/\(townURL).json"
        sevenDayForecastURL = "https://api.wunderground.com/api/bf7798dd77b9bf97/forecast7day/q/\(state)/\(townURL).json"
        
        
        
        if let url1 = URL(string: currentWeatherURL)
        {
            if let myData = try? Data(contentsOf: url1, options: [])
            {
                let json = JSON(myData)
                parse(myData: json)
            }
        }
        
        if let url2 = URL(string: hourlyWeatherURL)
        {
            if let myData2 = try? Data(contentsOf: url2, options: [])
            {
                let json = JSON(myData2)
                parse2(myData2: json)
            }
        }
        
        if let url3 = URL(string: sevenDayForecastURL)
        {
            if let myData3 = try? Data(contentsOf: url3, options: [])
            {
                let json = JSON(myData3)
                parse3(myData3: json)
            }
        }
        
        visualEffectView.alpha = 0
        aboutView.alpha = 0
        locationsView.alpha = 0
        settingsView.alpha = 0
        
        imageView.image = UIImage(named: "image2")
        sideBar = SideBar(sourceView: self.view, menuItems: [ "Weather", "Locations", "Settings", "About ⓘ"])
        sideBar.delegate = self
        
        currentTemp.text = String(format: "%.0fºF", arguments: [tempF])
        
        
        //locationLabel.text = fullName
        quoteLabel.text = "Dangerous Precipitation: A Rain of Terror"
        weatherName.text = weather
        weatherName.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        weatherName.adjustsFontForContentSizeCategory = true
        weatherName.adjustsFontSizeToFitWidth = true
        weatherName.numberOfLines = 2
        
        
        windDirection.text = "Wind Direction: " + windDir
        visibility.text = "Visibility: " + visibilityMi + " Miles"
        feelsLike.text = "It Feels Like: " + feelsLikeF + "ºF"
        relativeHumidity.text = "Relative Humidity: " + humidity
        windSpeed.text = "Wind Speed: " + String(windMph) + " Mph"
        dewpoint.text = String(format: "Dewpoint: %.0fºF", arguments: [dewpointF])
        uvIndex.text! = "UV Index: " + uv
        if windchillF == "NA"
        {
            windchill.text = "Windchill: " + "NA"
        }
        else
        {
            windchill.text = "Windchill: " + windchillF + "ºF"
        }
        
        
        if weatherName.text? .contains("Thunder") == true
        {
            weatherIcon.image = #imageLiteral(resourceName: "Thunderstorm")
        }
        else
        {
        weatherIcon.image = UIImage(named: weather)
        }
        
        
        let partlyCloudyQuoteArray = ["Cloudy with a chance of meatballs.", "Half and half.", "Look up."]
        let randomIndex = Int(arc4random_uniform(UInt32(partlyCloudyQuoteArray.count)))
        print(partlyCloudyQuoteArray[randomIndex])
        
        let overcastQuoteArray = ["Dark and cloudy.", "Gloomy. Hey at least it's not raining.", "Cheer up! Or be a grump."]
        let randomIndex1 = Int(arc4random_uniform(UInt32(overcastQuoteArray.count)))
        print(overcastQuoteArray[randomIndex])
        
        let sunnyQuoteArray = ["Finally. Sun.", "Stop checking the weather and get outside!", "Free tans!"]
        let randomIndex2 = Int(arc4random_uniform(UInt32(sunnyQuoteArray.count)))
        print(sunnyQuoteArray[randomIndex])
        
        let thunderQuoteArray = ["Boomshakalaka.", "Get inside!", "1 in 700,000."]
        let randomIndex3 = Int(arc4random_uniform(UInt32(thunderQuoteArray.count)))
        print(thunderQuoteArray[randomIndex3])
        
        let snowQuoteArray = ["Look outside.", "Where's my present?", "Who said Global Warming was real?"]
        let randomIndex4 = Int(arc4random_uniform(UInt32(snowQuoteArray.count)))
        print(snowQuoteArray[randomIndex4])
        
        let rainQuoteArray = ["Pitter patter.", "Don't forget your umbrella.", "Hey, free showers!"]
        let randomIndex5 = Int(arc4random_uniform(UInt32(rainQuoteArray.count)))
        print(rainQuoteArray[randomIndex5])
        
        let fogQuoteArray = ["Can't even see 100 feet ahead.", "Is it overcast? Or fog? Or both?", "What is fog?"]
        let randomIndex6 = Int(arc4random_uniform(UInt32(fogQuoteArray.count)))
        print(fogQuoteArray[randomIndex6])
        
        let windySunnyQuoteArray = ["Breezy, but nice.", "Don't get carried away!", "Perfect weather."]
        let randomIndex7 = Int(arc4random_uniform(UInt32(windySunnyQuoteArray.count)))
        print(windySunnyQuoteArray[randomIndex7])
        
        let windyOvercastQuoteArray = ["Breezy and cloudy.", "Don't get carried away!", "Gloomy and cloudy. Boohoo."]
        let randomIndex8 = Int(arc4random_uniform(UInt32(windySunnyQuoteArray.count)))
        print(windySunnyQuoteArray[randomIndex8])
        
        
        
        
        if weatherName.text == "Partly Cloudy" || weatherName.text == "Mostly Cloudy"{
            quoteLabel.text = partlyCloudyQuoteArray[randomIndex]
            backgroundImageView.image = UIImage(named: "PartlyCloudyImage")
        }
        
        if weatherName.text == "Overcast" {
            quoteLabel.text = overcastQuoteArray[randomIndex1]
            backgroundImageView.image = UIImage(named: "OvercastImage")
        }
        
        if weatherName.text == "Sunny" || weatherName.text == "Clear" {
            quoteLabel.text = sunnyQuoteArray[randomIndex2]
            backgroundImageView.image = UIImage(named: "SunnyImage")
        }
        
        if weatherName.text? .contains("Thunder") == true || weatherName.text? .contains("Thunderstorm") == true  {
            quoteLabel.text = thunderQuoteArray[randomIndex3]
            backgroundImageView.image = UIImage(named: "ThunderImage")
            
        }
        
        if weatherName.text? .contains("Snow") == true  {
            quoteLabel.text = snowQuoteArray[randomIndex4]
            backgroundImageView.image = UIImage(named: "SnowImage")
            
        }
        if weatherName.text? .contains("Rain") == true  {
            quoteLabel.text = rainQuoteArray[randomIndex5]
            backgroundImageView.image = UIImage(named: "RainImage")
            
        }
        
        if weatherName.text? .contains("Fog") == true  {
            quoteLabel.text = fogQuoteArray[randomIndex6]
            backgroundImageView.image = UIImage(named: "FogImage")
            
        }
        
        if weatherName.text? .contains("Windy") == true && windMph>20 && (weatherIcon == UIImage(named: "Clear")! || weatherIcon == UIImage(named: "Sunny")!)   {
            quoteLabel.text = windySunnyQuoteArray[randomIndex7]
            backgroundImageView.image = UIImage(named: "WindySunnyImage")
            
        }
        
        if weatherName.text? .contains("Windy") == true && windMph>20 && (weatherIcon == UIImage(named: "Overcast")! || weatherIcon == UIImage(named: "Fog")!)   {
            quoteLabel.text = windyOvercastQuoteArray[randomIndex8]
            backgroundImageView.image = UIImage(named: "WindyOvercastImage")
            
        }
        
        
        self.hideKeyboardWhenTappedAround()

        
    }
    
    
    
    
    
    
    @IBAction func enterLocationButton(_ sender: Any)
    {
        print("hi")
        
        locationsArray.append(townLabel.text! + ", " + stateLabel.text!)
        let string = stateLabel.text! + townLabel.text!
        let character = " "
        if string.contains(character)
        {
            let myAlert = UIAlertController(title: "ERROR", message: "Your information may have been fomatted incorrectly.", preferredStyle: UIAlertControllerStyle.alert)
            let dismissButton = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            myAlert.addAction(dismissButton)
            present(myAlert, animated: true, completion: nil)
        }
        else
        {
            
            
            state = stateLabel.text!
            townURL = townLabel.text!
            town = (townLabel.text?.replacingOccurrences(of: "_", with: " "))!
            
            locationLabel.text = town + ", " + state

            UIView.animate(withDuration: 0.5, animations:
            {
                self.viewDidAppear(true)

            })
            
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func temperatureUnitSwitch(_ sender: Any)
    {
        
        if currentTemp.text ==  String(format: "%.0fºF", arguments: [tempF])
        {
            currentTemp.text = String(format: "%.0fºC", arguments: [tempC])
            dewpoint.text = String(format: "Dewpoint: %.0fºC", arguments: [dewpointC])
            feelsLike.text = "It Feels Like: " + feelsLikeC + "ºC"
            if windchillC == "NA"
            {
                windchill.text = "Windchill: " + "NA"
            }
            else
            {
                windchill.text = "Windchill: " + windchillC + "ºC"
            }
        }
            
            
            
            
            
        else if currentTemp.text == String(format: "%.0fºC", arguments: [tempC])
        {
            currentTemp.text = String(format: "%.0fºF", arguments: [tempF])
            dewpoint.text = String(format: "Dewpoint: %.0fºF", arguments: [dewpointF])
            windchill.text = "Windchill: " + windchillF + "ºF"
            feelsLike.text = "It Feels Like: " + feelsLikeF + "ºF"
            if windchillC == "NA"
            {
                windchill.text = "Windchill: " + "NA"
            }
            else
            {
                windchill.text = "Windchill: " + windchillF + "ºF"
            }
        }
        
    }
    
    
    
    
    
    @IBAction func distanceUnitSwitch(_ sender: Any)
    {
        if visibility.text == "Visibility: " + visibilityMi + " Miles"
        {
            visibility.text = "Visibility: " + visibilityKm + " Kilometers"
            windSpeed.text = "Wind Speed: " + String(windKph) + " Kph"
        }
            
            
            
        else if visibility.text == "Visibility: " + visibilityKm + " Kilometers"
        {
            visibility.text = "Visibility: " + visibilityMi + " Miles"
            windSpeed.text = "Wind Speed: " + String(windMph)  + " Mph"
        }

    }
    
    
    
    
    
    func parse(myData:JSON)
    {
        fullName = myData["current_observation"]["display_location"]["full"].stringValue
        country = myData["current_observation"]["display_location"]["country"].stringValue
        zip = myData["current_observation"]["display_location"]["zip"].stringValue
        latitude = myData["current_observation"]["display_location"]["latitude"].stringValue
        longitude = myData["current_observation"]["display_location"]["longitude"].stringValue
        elevation = myData["current_observation"]["display_location"]["elevation"].stringValue
        tempC = myData["current_observation"]["temp_c"].doubleValue
        tempF = myData["current_observation"]["temp_f"].doubleValue
        humidity = myData["current_observation"]["relative_humidity"].stringValue
        weather = myData["current_observation"]["weather"].stringValue
        windString = myData["current_observation"]["wind_string"].stringValue
        windDir = myData["current_observation"]["wind_dir"].stringValue
        windMph = myData["current_observation"]["wind_mph"].doubleValue
        windKph = myData["current_observation"]["wind_kph"].doubleValue
        dewpointF = myData["current_observation"]["dewpoint_f"].doubleValue
        dewpointC = myData["current_observation"]["dewpoint_c"].doubleValue
        windchillF = myData["current_observation"]["windchill_f"].stringValue
        windchillC = myData["current_observation"]["windchill_c"].stringValue
        feelsLikeF = myData["current_observation"]["feelslike_f"].stringValue
        feelsLikeC = myData["current_observation"]["feelslike_c"].stringValue
        visibilityMi = myData["current_observation"]["visibility_mi"].stringValue
        visibilityKm = myData["current_observation"]["visibility_km"].stringValue
        uv = myData["current_observation"]["UV"].stringValue
        lastUpdatedInfo = myData["current_observation"]["observation_time"].stringValue
        
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
            let amPm = j["FCTTIME"]["ampm"].stringValue
            
            let obj = ["civil": hourlyAmPmTime, "hour": hourly24Time, "english": hourlyTempF, "metric": hourlyTempC, "condition": hourlyCondition, "wx": hourlyCondition2, "ampm": amPm]
            hourlyInfo.append(obj)
            
            
        }
        hourlyCollectionView.reloadData()
        
    }

    func parse3(myData3:JSON)
    {
        for k in myData3["forecast"]["simpleforecast"]["forecastday"].arrayValue
        {
            let day = k["date"]["weekday"].stringValue
            let dailyHighF = k["high"]["fahrenheit"].stringValue
            let dailyLowF = k["low"]["fahrenheit"].stringValue
            let dailyHighC = k["high"]["celsius"].stringValue
            let dailyLowC = k["low"]["celsius"].stringValue
            let dailyConditions = k["conditions"].stringValue
            
            let obj2 = ["weekday": day, "fahrenheitH": dailyHighF, "celsiusH": dailyHighC, "fahrenheitL": dailyLowF, "celsiusL": dailyLowC, "conditions": dailyConditions]
            
            dailyInfo.append(obj2)
  
        }
        dailyCollectionView.reloadData()
    }
    
    
    func animateIn()
    {

        moreInfoView.layer.cornerRadius = 10
        
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
            self.moreInfoView.alpha = 1
            self.moreInfoView.transform = CGAffineTransform.identity
        }
        visualEffectView.alpha = 1

    }
    
    func animateOut()
    {
        UIView.animate(withDuration: 0.5, animations:
            {self.moreInfoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.visualEffectView.alpha = 0
            self.moreInfoView.alpha = 0})
        { (success:Bool) in
            self.moreInfoView.removeFromSuperview()
            
        }
    }
    
    
    @IBAction func moreInfoButtonPressed(_ sender: Any)
    {
        animateIn()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        animateOut()
    }
    @IBAction func testButtonForScrollView(_ sender: Any) {
        print("Epic")
    }
    
    
    func sideBarDidSelectButtonAtIndex(_ index: Int) {
        
        if index == 0
        {
            aboutView.alpha = 0
            locationsView.alpha = 0
            settingsView.alpha = 0
            
        }
            
        else if index == 1
        {
            locationsView.alpha = 1
            settingsView.alpha = 0
            aboutView.alpha = 0
            

        }
        else if index == 2
        {
            settingsView.alpha = 1
            aboutView.alpha = 0
            locationsView.alpha = 0
        }
        else if index == 3
        {
            aboutView.alpha = 1
            locationsView.alpha = 0
            settingsView.alpha = 0
            
        }
    }


}
