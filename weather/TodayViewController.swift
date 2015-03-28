//
//  TodayViewController.swift
//  weather
//
//  Created by Мялин Валентин on 3/22/15.
//  Copyright (c) 2015 Мялин Валентин. All rights reserved.
//

import Cocoa
import NotificationCenter
import Foundation

class TodayViewController: NSViewController, NCWidgetProviding  {
    
    
    @IBOutlet weak var tempStr: NSTextField!
    @IBOutlet weak var pressureStr: NSTextField!
    @IBOutlet weak var sunriseStr: NSTextField!
    @IBOutlet weak var sunsetStr: NSTextField!
    @IBOutlet weak var speedWindStr: NSTextField!
    @IBOutlet weak var humidityStr: NSTextField!
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        
        func getJSON(urlToRequest: String) -> NSData? {
            return NSData(contentsOfURL: NSURL(string: urlToRequest)!)?
        }
        func parseJSON(inputData: NSData?) -> NSDictionary?{
            var error: NSError?
            var boardsDictionary: NSDictionary?
            if inputData != nil {
            boardsDictionary = NSJSONSerialization.JSONObjectWithData(inputData!, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary
            }
            return boardsDictionary
        }
        
        // функция searchCity принимает строку поиска и возвращает найденые города по запросу в масиве.
        func searchCity(searchCity: String) -> NSArray? {
        var nameCity = [String]()
        
        let jsonResult = parseJSON(getJSON("http://api.openweathermap.org/data/2.5/find?q=\(searchCity)&type=like")!)
        
        if jsonResult != nil {
        let list = jsonResult!["list"] as? NSArray
                if list != nil {
        for entry in list! {
            nameCity.append(entry["name"] as String)
                            }
                                }
        }
            return nameCity
        }
        
        // кусок кода для теста
        var d = searchCity("kie")!
        for var i = 0; i < d.count; i++ {
            println(d[i])
        }

        // plist
        var myDict: NSDictionary?
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("save.plist")
        println(path)
        //var path = NSBundle.mainBundle().pathForResource("save", ofType: "plist")
       // var data : NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!)!
     
            myDict = NSDictionary(contentsOfFile: path)
        
        if let dict = myDict {
            // Use your dict here
            let saveNameCity = dict["nameCity"] as? String
            println(saveNameCity)
            
        
        }
        var fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path)))
        {
            var bundle : NSString = NSBundle.mainBundle().pathForResource("save", ofType: "plist")!
            fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
        }
        var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        var bedroomFloorID: AnyObject = 101
        dict.setObject(bedroomFloorID, forKey: "nameCity")
        dict.writeToFile(path, atomically: false)
        
        
        let jsonResult: NSDictionary? = parseJSON(getJSON("http://api.openweathermap.org/data/2.5/weather?q=Dnipropetrovsk,UA&units=metric"))
        
        
        if let jsonResult = jsonResult {
            
            // Значения из словаря присваиваются этикеток
            
            let jsonDate: NSDictionary! = jsonResult["main"] as? NSDictionary
            let temp = jsonDate["temp"] as? Float
            //let tempMax = jsonDate["temp_max"] as? Float
            //let tempMin = jsonDate["temp_min"] as? Float
            let humidity = jsonDate["humidity"] as? Int // Влажность
            let pressure = jsonDate["pressure"] as? Int // Давление

            println(temp!)
            println(humidity!)
            println(pressure!)
            self.pressureStr.stringValue=String(pressure!)
            self.humidityStr.stringValue=String(humidity!)

            println("ура")
            
            
            if var
                temp = temp {
                self.tempStr.stringValue = String(format: "%.2f", temp)
               // println(temp)
            }
            else{
                //self.text01.stringValue = "-"
            }
            
            // Город
            let nameCity = jsonResult["name"] as? String
            
            // Восход и закат
            let jsonSys: NSDictionary! = jsonResult["sys"] as? NSDictionary
            
            let jsonSunrise = jsonSys["sunrise"] as? Double
            let jsonSunset = jsonSys["sunset"] as? Double // закат
            
            
            if jsonSunrise != nil || jsonSunset != nil {
            let sunrise = NSDate(timeIntervalSince1970: jsonSunrise!)
            let sunset = NSDate(timeIntervalSince1970: jsonSunset!)
                //self.sunriseStr.stringValue=String(sunrise)
            let dateFormatter = NSDateFormatter()
                //let sunriseDate = dateFormatter.stringFromDate(NSDate(sunrise))
                //let sunsetDate = dateFormatter.stringFromDate(NSDate(sunset))
                //let sunriseDate=stringFromDate(sunrise)
       // let sunsetDate=stringFromDate(sunset)
       //println(jsonSunrise)
                
                
            
            //self.sunriseStr.stringValue=NSDate(sunriseStr)
            
            // wind
            let jsonWind: NSDictionary! = jsonResult["wind"] as? NSDictionary
            let speedWind = jsonWind["speed"] as? Int
            let degWind = jsonWind["deg"] as? Int
            self.speedWindStr.stringValue=String(speedWind!)
          
            
            // cloud
            let jsonClouds: NSDictionary! = jsonResult["clouds"] as? NSDictionary
            let clouds = jsonClouds["all"] as? Int
            
            
            
        }
        
        completionHandler(.NoData)
        
}

}
}
