//
//  APIClient.swift
//  WeatherApp
//
//  Created by Magnus Holm on 10/02/2018.
//  Copyright © 2018 Magnus Holm. All rights reserved.
//

import Foundation

enum Either<V, E: Error> {
    case value(V)
    case error(E)
}

enum APIError: Error {
    case apiError
    case badResponse
    case jsonDecoder
    case unknown(String)
}

protocol APIClient {
    var session: URLSession { get }
    func fetch<V: Codable>(with request: URLRequest, completion: @escaping (Either<V, APIError>) -> Void )
}

extension APIClient {
    func fetch<V: Codable>(with request: URLRequest, completion: @escaping (Either<V, APIError>) -> Void ) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.error(.apiError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<299 ~= response.statusCode else {
                completion(.error(.badResponse))
                return
            }
            
            guard let value = try? JSONDecoder().decode(V.self, from: data!) else {
                completion(.error(.jsonDecoder))
                return
            }
            
            completion(.value(value))
        }
        task.resume()
    }
}
