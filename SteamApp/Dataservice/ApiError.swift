//
//  ApiError.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import Foundation

enum APIError: Error, ErrorDescriptable {
    
    case notAuthenticated
    case csrfToken
    case notFound
    case networkProblem
    case badRequest(Error?)
    case requestFailed
    case invalidData
    case unknown(HTTPURLResponse?, Error?)
    
    init(response: URLResponse?, error: Error?) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil, error)
            return
        }
        switch response.statusCode {
        case 400:
            self = .badRequest(error)
        case 401:
            self = .notAuthenticated
        case 403:
            if response.description == ErrorMessages.Default.CSRFToken {
                self = .csrfToken
            } else {
                self = .unknown(response, error)
            }
        case 404:
            self = .notFound
        default:
            self = .unknown(response, error)
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
    
    var description: String {
        switch self {
        case .notAuthenticated:
            return ErrorMessages.Default.NotAuthorized
        case .notFound:
            return ErrorMessages.Default.NotFound
        case .networkProblem, .unknown:
            return ErrorMessages.Default.ServerError
        case .requestFailed, .invalidData:
            return ErrorMessages.Default.RequestFailed
        case .csrfToken:
            return ErrorMessages.Default.CSRFToken
        case .badRequest(let error):
            return error?.localizedDescription ?? ErrorMessages.Default.RequestFailed
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
        case .networkProblem, .unknown:
            return ErrorMessages.Default.ServerError
        case .requestFailed, .invalidData:
            return ErrorMessages.Default.RequestFailed
        case .csrfToken:
            return ErrorMessages.Default.CSRFToken
        case .badRequest(let error):
            return error?.localizedDescription ?? ErrorMessages.Default.RequestFailed
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
        }
    }
}

protocol Descriptable {
    
    var description: String { get }
    
}

protocol ErrorDescriptable: Descriptable {}
