//
//  ApiError.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import Foundation
import Alamofire

enum APIError: Error, ErrorDescriptable {
    
    case notAuthenticated
    case csrfToken
    case notFound
    case networkProblem
    case badRequest(Data?, Error?)
    case requestFailed
    case invalidData
    case unknown(HTTPURLResponse?, Data?, Error?)
    case uiError(String?)
    case sessionTaskError(Error?)
    
    init(error: String?) {
        self = .uiError(error)
    }
    
    init(response: URLResponse?, data: Data?, error: AFError?) {
        guard let sessionError = error, !sessionError.isSessionTaskError else {
            self = .sessionTaskError(error)
            return
        }
        
        guard let retryError = error, !retryError.isRequestRetryError else {
            if let errorResponse = response as? HTTPURLResponse {
                self = .unknown(errorResponse, data, error)
            } else {
                self = .unknown(nil, data, error)
            }
            return
        }
        self.init(response: response, data: data, error: error as Error?)
    }
    
    init(response: URLResponse?, data: Data?, error: Error?) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil, data, error)
            return
        }
        switch response.statusCode {
        case 400:
            self = .badRequest(data, error)
        case 401:
            self = .notAuthenticated
        case 403:
            if response.description == ErrorMessages.Default.CSRFToken {
                self = .csrfToken
            } else {
                self = .unknown(response, data, error)
            }
        case 404:
            self = .notFound
        default:
            self = .unknown(response, data, error)
        }
    }
    
    var isAuthError: Bool {
        switch self {
        case .notAuthenticated: return true
        default: return false
        }
    }
    
    var isCSRFError: Bool {
        switch self {
        case .csrfToken: return true
        default:
            return false
        }
    }
    
    var isBadRequest: Bool {
        switch self {
        case .requestFailed: return true
        default:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .notAuthenticated:
            return ErrorMessages.Default.NotAuthorized
        case .notFound:
            return ErrorMessages.Default.NotFound
        case .networkProblem:
            return ErrorMessages.Default.ServerError
        case .requestFailed, .invalidData:
            return ErrorMessages.Default.RequestFailed
        case .csrfToken:
            return ErrorMessages.Default.CSRFToken
        case .unknown(_, let data, let error):
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let errorValue = json["message"] as? String {
                return errorValue
            }
            
            return error?.localizedDescription ?? ErrorMessages.Default.ServerError
        case .badRequest(let data, let error):
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let errorValue = json["message"] as? String {
                return errorValue
            }
            
            return error?.localizedDescription ?? ErrorMessages.Default.RequestFailed
        case .uiError(let data):
            return data ?? ""
        case .sessionTaskError(_):
                return ErrorMessages.Default.sessionTaskError
        }
    }
    
}

extension APIError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return ErrorMessages.Default.NotAuthorized
        case .notFound:
            return ErrorMessages.Default.NotFound
        case .networkProblem:
            return ErrorMessages.Default.ServerError
        case .requestFailed, .invalidData:
            return ErrorMessages.Default.RequestFailed
        case .csrfToken:
            return ErrorMessages.Default.CSRFToken
        case .unknown(_, let data, let error):
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let errorValue = json["message"] as? String {
                return errorValue
            }
            
            return error?.localizedDescription ?? ErrorMessages.Default.ServerError
        case .badRequest(let data, let error):
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let errorValue = json["message"] as? String {
                return errorValue
            }
            
            return error?.localizedDescription ?? ErrorMessages.Default.RequestFailed
        case .uiError(let data):
            return data ?? ""
        case .sessionTaskError(_):
                return ErrorMessages.Default.sessionTaskError
        }
    }
    
}


// MARK: - Constants

extension APIError {
    
    struct ErrorMessages {
        
        struct Default {
            static let ServerError = "Server Error. Please, try again later."
            static let NotAuthorized = "This information is not available."
            static let NotFound = "Bad request error."
            static let RequestFailed = "Resquest failed. Please, try again later."
            static let CSRFToken = "Invalid CSRF token"
            static let sessionTaskError = "Session Task Error"
        }
    }
}

protocol Descriptable {
    
    var description: String { get }
    
}

protocol ErrorDescriptable: Descriptable {}
