//
//  File.swift
//  MonoWeather
//
//  Created by 이승현 on 2023/03/25.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    static let shared = WeatherManager()
    private init() {}
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=82ba15ba68cefeff502358350f966d4d&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    private func performRequest(with urlString: String){
        
        //1. URL 인스턴스 생성
        if let url = URL(string: urlString){
            //2. URLSession 인스턴스 생성
            let session = Foundation.URLSession(configuration: .default)
            
            //3. URLSession 에게 할 일 주기
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                //Data 타입으로 데이터를 받아옴..일반 string, int 가 아님
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        delegate?.didUpdateWeather(_weatherManager: self, weather: weather)
                    }
                }
            }
            
            //4. 할 일 시작
            task.resume()
        }
    }
    private func parseJSON(weatherData: Data)->WeatherModel? {
        
        let decoder = JSONDecoder() //an object that can decode JSON Objects
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
