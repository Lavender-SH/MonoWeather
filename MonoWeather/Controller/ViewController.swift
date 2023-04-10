//
//  ViewController.swift
//  MonoWeather
//
//  Created by 이승현 on 2023/03/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageview: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var descriptioNLabel: UILabel!
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func findCurrentLocationButton(_ sender: UIButton) { locationManager.requestLocation()
    }
    
    var weatherManager = WeatherManager.shared
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setup() { searchTextField.keyboardType = UIKeyboardType.emailAddress
        searchTextField.clearButtonMode = .always
        searchTextField.becomeFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
//    func setting(){
//
//        let tabBarVC = UITabBarController()
//
//        let vc1 = UINavigationController(rootViewController: SettingViewController())
//        let vc2 = FirstViewController()
//        let vc3 = SecondViewController()
//
//        vc1.title = "메인화면"
//        vc2.title = "디테일화면"
//
//        tabBarVC.setViewControllers([vc1,vc2], animated:false)
//        tabBarVC.modalPresentationStyle = .fullScreen
//        tabBarVC.tabBar.backgroundColor = .white
//
//        guard let items = tabBarVC.tabBar.items else {return}
//        items[0].image = UIImage(systemName: "cloud.rain")
//        items[1].image = UIImage(systemName: "cloud.rain.circle")
//
//        //present(tabBarVC,animated: true, completion: nil)
//    }
}
    
    
    
    // MARK: - 확장 WeatherManagerDelegate
    extension ViewController: WeatherManagerDelegate {
        func didUpdateWeather(_weatherManager: WeatherManager, weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageview.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
                self.tempMinLabel.text = weather.tempMin.description
                self.tempMaxLabel.text = weather.tempMax.description
                self.sunRiseLabel.text = weather.sunRise.description
                self.sunSetLabel.text = weather.sunSet.description
                self.timeZoneLabel.text = weather.timeZone.description
                self.descriptioNLabel.text = weather.discriptioN
                
            }
        }
        func didFailWithError(error: Error) {
            print(error)
        }
    }
    
    
    // MARK: - 확장 CLLocationManagerDelegate
    extension ViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last{
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                weatherManager.fetchWeather(latitude: lat, longitude: lon)
            }
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
        
    }
    
    
    
extension ViewController: UITextFieldDelegate {
    // 텍스트필드의 엔터키가 눌러지면 다음 동작을 허락할 것인지
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    // 텍스트필드의 입력이 끝날 떄호출 (끝날지 말지를 허락)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder =  "Type a city"
            return false
        }
    }
    //텍스트필드의 입력이 끝났을때 호출 (시점)
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        print("텍스트필드의 입력값: \(string)")
        
        // 입력되고 있는 글자가 "숫자"인 경우 입력을 허용하지 않는 논리
        if Int(string) != nil {  // (숫자로 변환이 된다면 nil이 아닐테니)
            return false
        } else {
            // 10글자이상 입력되는 것을 막는 코드
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
    }
}
