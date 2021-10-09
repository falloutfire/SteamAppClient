//
//  Endpoint.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import Foundation
import UIKit

protocol Endpoint {
    
    var base: URL { get }
    var path: String? { get }
    //var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    //var parameterEncoding: ParameterEnconding { get }
    var method: HTTPMethod { get }
    var contentType: ContentType { get }
    var image: UIImage? { get }
    
}

extension Endpoint {

    
    var request: URLRequest {
        let url = path != nil ? base.appendingPathComponent(path!) : base
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
//        if let headers = headers {
//            for (key, value) in headers {
//                request.setHeader(for: key, with: value)
//            }
//        }
        
        
        //request.setValue(Dataservice.shared.headersURL.absoluteString, forHTTPHeaderField: "Referer")
        //request.setValue(Dataservice.shared.headersURL.absoluteString, forHTTPHeaderField: "Origin")
        let locale = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
        request.setValue(locale, forHTTPHeaderField: "accept-language")
        //request.setValue(UserAgent.shared.getUserAgent(), forHTTPHeaderField: "User-Agent")
        let boundary = generateBoundary()
        switch contentType {
        case .json, .image:
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        case .multipart:
            var type = contentType.rawValue
            type.append(boundary)
            request.setValue(type, forHTTPHeaderField: "Content-Type")
        }
        
        if let params = params {
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        }
        
        return request
    }
    
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}

extension URLRequest {
    mutating func encode<T>(with item: T) where T : Encodable {
        let value = try? JSONEncoder().encode(item)
        httpBody = value
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

enum ParameterEnconding {
    case defaultEncoding
    case jsonEncoding
    case compositeEncoding
}

enum ContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data; boundary="
    case image = "image/jpeg"
}

