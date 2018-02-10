//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Magnus Holm on 10/02/2018.
//  Copyright © 2018 Magnus Holm. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponent: URLComponents {
        var component = URLComponents(string: baseUrl)
        component?.path = path
        component?.queryItems = queryItems
        
        return component!
    }
    
    var request: URLRequest {
        return URLRequest(url: urlComponent.url!)
    }
}

enum WeatherEndpoint: Endpoint {
    case tenDayForecast(city: String, state: String)
    
    var baseUrl: String {
        return "https://api.wunderground.com"
    }
    var path: String {
        switch self {
        case .tenDayForecast(let city, let state):
            return "/api/f9111d7519d659fc/forecast10day/q/\(state)/\(city).json"
        }
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
}
