//
//  Utils.swift
//  TestWeather
//
//  Created by Mephrine on 2020/05/27.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit

public func p(_ items: Any...) {
    #if DEBUG
    let output = items.map { "***\($0)***" }.joined(separator: " | ")
    Swift.print(output, terminator: "\n")
    #endif
}

public let Defaults = UserDefaults.standard

class Utils: NSObject {
    public static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    public static let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height
    public static var SAFE_AREA_TOP: CGFloat = 0
    
    private static func archiveArray<T>(array : [T]) -> Data {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
            return data
        } catch {
            fatalError("archive fail error : \(error)")
        }
    }
    
    static func unarchiveWeatherList() -> [WeatherListModel]? {
        guard let archive = Defaults.value(forKey: UD_REGI_LOCATION_LIST) as? Data else { return nil }

        do {
            guard let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, WeatherListModel.self], from: archive) as? [WeatherListModel] else {
                p("unarchive fail error")
                return nil
            }
            
            return array
        } catch {
            fatalError("unarchive fail error : \(error)")
        }
    }
    
    static func insertLocation(cityNm: String? = "", latitude: Double, longitude: Double) {
        var array = self.unarchiveWeatherList()
        let model = WeatherListModel(lat: latitude, lon: longitude, city: cityNm ?? "")
        if array == nil {
            array = [WeatherListModel]()
        }
        array!.append(model)
        
        let archive = self.archiveArray(array: array!)
        Defaults.setValue(archive, forKey: UD_REGI_LOCATION_LIST)
        Defaults.synchronize()
    }
    
    static func updateLocation(cityNm: String? = "", latitude: Double, longitude: Double) {
        var array = self.unarchiveWeatherList()
        if let arrLocation = array {
            for (index, item) in arrLocation.enumerated() {
                if item.lat == latitude && item.lon == longitude {
                    let newModel = WeatherListModel(lat: latitude, lon: longitude, city: cityNm ?? "")
                    array?[index] = newModel
                    let archive = self.archiveArray(array: array!)
                    Defaults.setValue(archive, forKey: UD_REGI_LOCATION_LIST)
                    Defaults.synchronize()
                    
                    return
                }
            }
        }
    }
    
    static func indexOfLocation(index: Int) -> WeatherListModel? {
        let array = self.unarchiveWeatherList()
        return array?[index]
    }
    
    static func removeLocation(index: Int) {
        var array = self.unarchiveWeatherList()
        if index < (array?.count) ?? 0 {
            array?.remove(at: index)
        }
        
        let archive = self.archiveArray(array: array!)
        Defaults.setValue(archive, forKey: UD_REGI_LOCATION_LIST)
        Defaults.synchronize()
    }
    
    static func selectedIndexOfLocation() -> Int {
        print("Defaults.integer(forKey: UD_CURRENT_LOCATION_INDEX) : \(Defaults.integer(forKey: UD_CURRENT_LOCATION_INDEX))")
        return Defaults.integer(forKey: UD_CURRENT_LOCATION_INDEX)
    }
    
    static func setSelectedIndexOfLocation(index: Int) {
        Defaults.set(index, forKey: UD_CURRENT_LOCATION_INDEX)
        Defaults.synchronize()
    }
}
