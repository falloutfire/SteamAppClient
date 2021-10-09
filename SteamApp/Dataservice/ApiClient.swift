//
//  ApiClient.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import Foundation
import UIKit

protocol APIClient {
    
    var session: URLSession { get }
    
    var imageSession: URLSession { get }
    
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    
    func fetch(with request: URLRequest, completion: @escaping (Result<AnyObject?, APIError>) -> Void)
    
    func fetchImage(with request: URLRequest, completion: @escaping (Result<UIImage?, APIError>) -> Void)
    
}

extension APIClient {
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest,
                                            decodingType: T.Type,
                                            completionHandler completion: JSONTaskCompletionHandler?) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            NetworkLogger.log(response: response as? HTTPURLResponse, data: data, error: error)
            guard let httpResponse = response as? HTTPURLResponse else {
                completion?(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion?(genericModel, nil)
                    } catch {
                        completion?(nil, .requestFailed)
                    }
                } else {
                    completion?(nil, .invalidData)
                }
            } else if let responseMetadata = response as? HTTPURLResponse, responseMetadata.statusCode != 200 && responseMetadata.statusCode != 201, let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let errorValue = NSError(domain:"", code: responseMetadata.statusCode, userInfo:[NSLocalizedDescriptionKey: json["message"]!])
                    completion?(nil, APIError(response: httpResponse, error: errorValue))
                } else {
                    completion?(nil, APIError(response: httpResponse, error: error))
                }
            }
        }
        return task
    }
    
    func fetch(with request: URLRequest, completion: @escaping (Result<AnyObject?, APIError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            NetworkLogger.log(request: request)
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(Result.failure(.requestFailed))
                    return
                }
                NetworkLogger.log(response: response as? HTTPURLResponse, data: data, error: error)
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    completion(Result.success(nil))
                } else if let responseMetadata = response as? HTTPURLResponse, responseMetadata.statusCode != 200 && responseMetadata.statusCode != 201, let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let errorValue = NSError(domain:"", code: responseMetadata.statusCode, userInfo:[NSLocalizedDescriptionKey: json["message"]!])
                        
                        completion(Result.failure(APIError(response: httpResponse, error: errorValue)))
                    } else {
                        completion(Result.failure(APIError(response: httpResponse, error: error)))
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T, APIError>) -> Void) {
        NetworkLogger.log(request: request)
        let task = decodingTask(with: request, decodingType: T.self) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.requestFailed))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.requestFailed))
                }
            }
        }
        task.resume()
    }
    
    func fetchImage(with request: URLRequest, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        if let url = request.url {
            let task = session.dataTask(with: url) { (data, response, error) in
                NetworkLogger.log(request: request)
                // Check for the error, then data and try to create the image.
    //            guard let httpResponse = response as? HTTPURLResponse else {
    //                completion(Result.failure(.requestFailed))
    //                return
    //            }
                NetworkLogger.log(response: response as? HTTPURLResponse, data: data, error: error)
                if let responseData = data, let image = UIImage(data: responseData) {
                    completion(.success(image))
                } else if let responseMetadata = response as? HTTPURLResponse, responseMetadata.statusCode != 200 && responseMetadata.statusCode != 201, let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let errorValue = NSError(domain:"", code: responseMetadata.statusCode, userInfo:[NSLocalizedDescriptionKey: json["message"]!])
                        
                        completion(Result.failure(APIError(response: response, error: errorValue)))
                    } else {
                        completion(Result.failure(APIError(response: response, error: error)))
                    }
                } else {
                    completion(Result.failure(APIError(response: response, error: error)))
                }
            }
            task.resume()
        }
    }
}
