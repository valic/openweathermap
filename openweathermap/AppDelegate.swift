//
//  AppDelegate.swift
//  openweathermap
//
//  Created by Мялин Валентин on 3/22/15.
//  Copyright (c) 2015 Мялин Валентин. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        // NSURLSession создается с объектом NSURL, содержащей URL веб-службы. Эта сессия используется для сетевых вызовов.
        let urlAsString = "http://api.openweathermap.org/data/2.5/weather?q=Dnipropetrovsk,UA&units=metric"
        
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        // Метод dataTaskWithURL создает задачу подключения, который будет использоваться на самом деле отправить запрос. Следует отметить, что она имеет окончания, как это последний параметр.
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            // С JSONObjectWithData: Опции: метод ошибки класса NSJSONSerialization фактический разбор выполняется. При разборе данные будут записаны в словарь.
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSDictionary
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            //println(jsonResult)
            
            
            // Значения из словаря присваиваются этикеток
            
            let jsonDate: NSDictionary! = jsonResult["main"] as? NSDictionary
            let temp = jsonDate["temp"] as? Float
            //let tempMax = jsonDate["temp_max"] as? Float
            //let tempMin = jsonDate["temp_min"] as? Float
            let humidity = jsonDate["humidity"] as? Int // Влажность
            let pressure = jsonDate["pressure"] as? Int // Давление
            
            println(temp!)
            
            /*
            
            let nicknameWOT: NSString! = jsonDate2["nickname"] as? NSString
            let global_rating: Int! = jsonDate2["global_rating"] as? Int
            println(global_rating)
            let jsonTime: Int! = jsonResult["count"] as Int*/
            
            
            dispatch_async(dispatch_get_main_queue(), {
                let test = jsonResult
                // timeLabel.text = jsonTime
            })
        })
        // Метод resume() начинает веб-запрос.
        
        jsonQuery.resume()
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

