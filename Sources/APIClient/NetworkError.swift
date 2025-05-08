//
//  File.swift
//  
//
//  Created by Jiguar on 29/03/25.
//

import Foundation


public enum NetworkError : Error
{
    case parametersNil
    case encodingFailed
    case missingURL
    case unauthorized
    case badRequest
    case failed(reason:String)
    case serverError
    case missingData
    case outdated
    case noInternet

}

extension NetworkError : LocalizedError
{
    public var errorDescription: String?
    {
        switch self {
        case .parametersNil:
            return NSLocalizedString("Parameters are missing", comment: "Please check the parameters provided in the request")
        case .encodingFailed :
            return NSLocalizedString("Failed to encode", comment: " ")
        case .missingURL:
            return NSLocalizedString("URL is missing", comment: "")
        case .unauthorized:
            return NSLocalizedString("Authentication Failed", comment: "The authentication token provided is invalid or might have expired")
        case .badRequest:
            return NSLocalizedString("Bad Request", comment: "")
        case .failed(let reason):
            return NSLocalizedString("API failed", comment: reason)
        case .serverError:
            return NSLocalizedString("Server Error", comment: "")
        case .missingData:
            return NSLocalizedString("Missing Data", comment: "")
        case .outdated:
            return NSLocalizedString("Outdated Data", comment: "")
        case .noInternet:
            return NSLocalizedString("Please check internet connection", comment: "")

        }
        
  
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs._code == rhs._code
    }
}
