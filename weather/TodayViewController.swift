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
import AppKit


class TodayViewController: NSViewController, NCWidgetProviding  {
    
    @IBOutlet weak var weatherIcon: NSImageView!
       
    @IBOutlet weak var tempStr: NSTextField!   
    @IBOutlet weak var pressureStr: NSTextField!
    @IBOutlet weak var speedWindStr: NSTextField!
    @IBOutlet weak var humidityStr: NSTextField!
    @IBOutlet weak var cityName: NSTextField!
   
    

    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    
    // https://developer.apple.com/library/mac/samplecode/Lister/Listings/Swift_ListerTodayOSX_TodayViewController_swift.html
    var widgetAllowsEditing: Bool {
        return true
    }
    
    // Called when a user chooses the widget’s begin editing button.
    func widgetDidBeginEditing() {
    println("Старт редактирования")
        
    }
    
    // Called when a widget’s editing session ends.
    func widgetDidEndEditing() {
    println("Стоп редактирования")
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        
       
        func getJSON(urlToRequest: String) -> NSData? {
            return NSData(contentsOfURL: NSURL(string: urlToRequest)!)
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
            nameCity.append(entry["name"] as! String)
            //  ранее  было  nameCity.append(entry["name"] as String)
                            }
                                }
        }
            return nameCity
        }
        
        // кусок кода для теста
       /* var d = searchCity("kie")!
        for var i = 0; i < d.count; i++ {
            println(d[i])
        }
        */

        // plist - Чтение настроек
        var myDict: NSDictionary?
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        

        let path = documentsDirectory.stringByAppendingPathComponent("save.plist")
        println(path)
     
        myDict = NSDictionary(contentsOfFile: path)
        
        var saveNameCity : String?
        var cityID : Int?
        
        if myDict == nil {

            // Создаем файл на основании шаблона save.plist
            var fileManager = NSFileManager.defaultManager()
            if (!(fileManager.fileExistsAtPath(path)))
            {
                var bundle : NSString = NSBundle.mainBundle().pathForResource("save", ofType: "plist")!
                fileManager.copyItemAtPath(bundle as String, toPath: path, error:nil)
            }
            
            // читаем файл
            myDict = NSDictionary(contentsOfFile: path)
        }
            // Use your dict here
            saveNameCity = myDict!["nameCity"] as? String
            cityID = myDict!["cityID"] as? Int
        
            // выводим имя  города
            self.cityName.stringValue=String(saveNameCity!)
        
        func saveInPlist(nameSity: String, cityID : Int) {

            var dict: NSMutableDictionary = ["nameCity": nameSity, "cityID" : cityID]
            dict.writeToFile(path, atomically: true)
        }
        
        //saveInPlist("London", 2643743)
        
      
        
        
        let jsonResult: NSDictionary? = parseJSON(getJSON("http://api.openweathermap.org/data/2.5/weather?id=\(String(cityID!))&units=metric"))
        
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
                }
                
            
            //self.sunriseStr.stringValue=NSDate(sunriseStr)
            
            // wind
            let jsonWind: NSDictionary! = jsonResult["wind"] as? NSDictionary
            let speedWind = jsonWind["speed"] as? Int
            let degWind = jsonWind["deg"] as? Int
            self.speedWindStr.stringValue=String(speedWind!)
          
            
            // cloud
            let jsonClouds: NSDictionary! = jsonResult["clouds"] as? NSDictionary
            let clouds = jsonClouds["all"] as? Int
                
            // weather
            var weatherID:Int!
            var weatherMain:String!
            var iconNumber:String!
            
            var weatherDescription:String
            
            if let weather = jsonResult["weather"] as? [AnyObject] {
                for start in weather {
                    weatherID = start["id"] as! Int
                    weatherMain = start["main"] as! String
                    iconNumber = start["icon"] as! String
                    weatherDescription = start["description"] as! String
                }
            }
            
            //добавляем иконку
            var imgURL: NSURL = NSURL(string: "http://openweathermap.org/img/w/\(iconNumber)"+".png")!
            var imgData: NSData = NSData(contentsOfURL: imgURL)!
            weatherIcon.image = NSImage(data: imgData)
            
        
            
        completionHandler(.NoData)
        
}
}
}
