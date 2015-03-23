//
//  TodayViewController.swift
//  weather
//
//  Created by Мялин Валентин on 3/22/15.
//  Copyright (c) 2015 Мялин Валентин. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding  {
    

    
  @IBOutlet var text01: NSTextField!

    override var nibName: String? {
        return "TodayViewController"
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        
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
            println(temp)
            println(humidity)
            println(pressure)
            println("ура")
            
            
            self.text01.stringValue = String(humidity!)
            
            dispatch_async(dispatch_get_main_queue(), {

            })
        })
        
        
        // Метод resume() начинает веб-запрос.
        jsonQuery.resume()


        completionHandler(.NoData)
    

        
}

}
