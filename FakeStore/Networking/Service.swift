//
//  Service.swift
//  FakeStore
//
//  Created by Andrew Vale on 29/01/25.
//

import Foundation

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
}

class Service {
    
    private let baseURL: String = "https://fakestoreapi.com"
    
    func makeRequest<T: Decodable> (endPoint: String,
                                    method: HTTPMethod,
                                    body: Data? = nil,
                                    headers: [String: String] = [:],
                                    reponseType: T.Type) async throws -> T {
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
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
}
