//
//  Networking.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case decodingError(String)
    case encodingError
    case noData
    case notLogin
    case errorMessage(String)
    case statusCode(Int?)
    case errorResponse(ErrorResponse)
    case dataNotComplete
}

class Networking {
    let base = "https://api.notion.com/v1/"
    var baseDatabase: String {
        return base + "databases/"
    }
    var basePage: String {
        return base + "pages/"
    }
    var baseBlock: String {
        return base + "blocks/"
    }
    var bearerToken: String =  "secret_6BgnfZzorJLh126hd8LgRdydGwjgO1ziSPfSnrdFwcj"
    let notionVersion = "2021-08-16"
    
    enum DatabaseID: String {
        case yearMonthDatabaseID = "adc413abe9364b50966e4e5c4759e523"
        case dailyLog = "225a9807434d43fca3488f8be0441ee0"
    }
    
    enum SortDirection: String {
        case ascending = "ascending"
        case descending = "descending"
    }
    enum SortTimestamp: String {
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
    }
    
    private init() { }
    
    static let shared = Networking()
    
    func getData<T:Codable>(from urlString: String, completion: @escaping ((Result<T,NetworkError>), URLResponse?, Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl), nil, nil)
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(urlString)
                return completion(.failure(.noData), response, nil)
            }
            
            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                
                if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    DispatchQueue.main.async {
                        GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                    }
                    return completion(.failure(.errorResponse(errorResponseDecoded)), response, data)
                }
                
                return completion(.failure(.errorMessage(data.jsonToString())), response, data)
            }
            completion(.success(decoded), response, data)
        }.resume()
    }
    
    func postData<T:Codable, U:Codable>(to urlString: String, postData: T?, completionResponse: @escaping (Result<U, NetworkError>, URLResponse?, Data?, Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            return completionResponse(.failure(.badUrl), nil, nil, false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        if let postData = postData {
            guard let jsonData = try? JSONEncoder().encode(postData) else {
                print(postData)
                print("Error: Trying to convert model to JSON data")
                return completionResponse(.failure(.encodingError), nil, nil, false)
            }
            
            request.httpBody = jsonData
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completionResponse(.failure(.noData), response, nil, false)
            }
            
            if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                print(urlString)
                DispatchQueue.main.async {
                    GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                }
                return completionResponse(.failure(.errorResponse(errorResponseDecoded)), response, data, false)
            }
            
            guard let decoded = try? JSONDecoder().decode(U.self, from: data) else {
                if let response = response {
                    if response.isStatusOK() {
                        return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, true)
                    }
                }
                
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, false)
            }
            
            return completionResponse(.success(decoded), response, data, true)
        }.resume()
    }
    
    func patchData<T:Codable, U:Codable>(to urlString: String, patchData: T?, completionResponse: @escaping (Result<U, NetworkError>, URLResponse?, Data?, Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            return completionResponse(.failure(.badUrl), nil, nil, false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        if let patchData = patchData {
            guard let jsonData = try? JSONEncoder().encode(patchData) else {
                print(patchData)
                print("Error: Trying to convert model to JSON data")
                return completionResponse(.failure(.encodingError), nil, nil, false)
            }
            
            request.httpBody = jsonData
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completionResponse(.failure(.noData), response, nil, false)
            }
            
            if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                print(urlString)
                DispatchQueue.main.async {
                    GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                }
                return completionResponse(.failure(.errorResponse(errorResponseDecoded)), response, data, false)
            }
            
            guard let decoded = try? JSONDecoder().decode(U.self, from: data) else {
                if let response = response {
                    if response.isStatusOK() {
                        return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, true)
                    }
                }
                
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                return completionResponse(.failure(.decodingError(data.jsonToString())), response, data, false)
            }
            
            return completionResponse(.success(decoded), response, data, true)
        }.resume()
    }
    
    func deleteData<T:Codable>(from urlString: String, completion: @escaping (Result<T, NetworkError>, URLResponse?, Data?, Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl), nil, nil, false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(notionVersion)", forHTTPHeaderField: "Notion-Version")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(urlString)
                return completion(.failure(.noData), response, nil, false)
            }
            
            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                if let response = response {
                    if response.isStatusOK() {
                        return completion(.failure(.decodingError(data.jsonToString())), response, data, true)
                    }
                }
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                
                if let errorResponseDecoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    DispatchQueue.main.async {
                        GlobalData.shared.errorMessage = Mapper.errorMessageRemoteToLocal(errorResponseDecoded)
                    }
                    return completion(.failure(.errorResponse(errorResponseDecoded)), response, data, false)
                }
                
                return completion(.failure(.errorMessage(data.jsonToString())), response, data, false)
            }
            completion(.success(decoded), response, data, true)
        }.resume()
    }
}

extension Data {
    func jsonToString() -> String {
        return String(data: self, encoding: .utf8) ?? "error encoding"
    }
    
    func decodedData<T:Codable>(type: T.Type) -> T? {
        guard let decoded = try? JSONDecoder().decode(T.self, from: self) else {
            print(String(data: self, encoding: .utf8) ?? "no data")
            return nil
        }
        
        return decoded
    }
}
