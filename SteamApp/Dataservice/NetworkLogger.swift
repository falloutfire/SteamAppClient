//
//  NetworkLogger.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import Foundation
import Alamofire

class NetworkLogger: EventMonitor {
    
    func requestDidFinish(_ request: Request) {
        
        let requsetInfo = request.request
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        let urlAsString = requsetInfo?.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlAsString)
        let method = requsetInfo?.httpMethod != nil ? "\(requsetInfo?.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        var output = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in requsetInfo?.allHTTPHeaderFields ?? [:] {
           output += "\(key): \(value) \n"
        }
        if let body = requsetInfo?.httpBody {
           output += "\nhttpBody: \(String(data: body, encoding: .utf8) ?? "")"
        }
        print(output)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let responseInfo = response.response
        
        print("\n - - - - - - - - - - INCOMMING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        let urlString = responseInfo?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        var output = ""
        if let urlString = urlString {
           output += "\(urlString)"
           output += "\n\n"
        }
        if let statusCode =  responseInfo?.statusCode {
           output += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = responseInfo?.url?.host {
           output += "Host: \(host)\n"
        }
        for (key, value) in responseInfo?.allHeaderFields ?? [:] {
           output += "\(key): \(value)\n"
        }
        if let body = response.data {
           output += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
        }
        if response.error != nil {
           output += "\nError: \(response.error!.localizedDescription)\n"
        }
        print(output)
    }
}

