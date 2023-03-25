//
//  ViewController.swift
//  MonoWeather
//
//  Created by 이승현 on 2023/03/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    

    @IBOutlet weak var ondoLB: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextfield.delegate = self
        
        
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    
    
    
    
    func setting(){
        
        let tabBarVC = UITabBarController()
        
        let vc1 = UINavigationController(rootViewController: SettingViewController())
        let vc2 = FirstViewController()
        let vc3 = SecondViewController()
        
        vc1.title = "메인화면"
        vc2.title = "디테일화면"
        
        tabBarVC.setViewControllers([vc1,vc2], animated:false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        
        guard let items = tabBarVC.tabBar.items else {return}
        items[0].image = UIImage(systemName: "cloud.rain")
        items[1].image = UIImage(systemName: "cloud.rain.circle")
        
    //present(tabBarVC,animated: true, completion: nil)
    }
}

