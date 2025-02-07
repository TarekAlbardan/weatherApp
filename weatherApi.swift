//
//  weatherApi.swift
//  weatherApp
//
//  Created by MacBook on 2025-02-05.
//

import Foundation

struct WeatherResponse : Decodable {
    let latitude:Double
    let longitude:Double
    let current:current
    let daily: daily

    struct current: Decodable {
        let temperature2M: Double
        let weatherCode:Int
        let time: String
    }
    struct daily: Decodable {
        let time :[String]
        let weatherCode :[Int]
        let temperature2MMax:[Double]
        let temperature2MMin:[Double]
    }

}
