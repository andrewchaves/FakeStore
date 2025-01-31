//
//  Service.swift
//  FakeStore
//
//  Created by Andrew Vale on 29/01/25.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
    case unknownError
}

class Service {
    
    private let baseURL: String = "https://fakestoreapi.com"
    
    func makeRequest<T: Decodable> (endPoint: String,
                                    method: HTTPMethod,
                                    body: Data? = nil,
                                    headers: [String: String] = [:],
                                    reponseType: T.Type) async throws -> AnyPublisher<T, APIError> {
        //Check if url is ok
        guard let url = URL(string: "\(baseURL)\(endPoint)") else {
            throw APIError.invalidURL
        }
        
        //Config request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        //Perform request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            return Just(data)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    if let decodingError = error as? DecodingError {
                        return APIError.decodingError
                    } else {
                        return APIError.unknownError
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            throw APIError.networkError(error)
        }
    }
}
