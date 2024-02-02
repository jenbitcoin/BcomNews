import Foundation

/**
 Represents server API call error
 */
public enum APIError {
    case Unauthorized(message: String?)
    case Forbidden(message: String?)
    case ServerError
    case RequestError(code: Int, title: String?, message: String?)
    case UnexpectedResponse
    case NoConnection
    case Unknown(NSError?)
}

/**
 APIError extension
 */
extension APIError {
    public func debugDescription() -> String {
        switch self {
        case .Unauthorized(let message):
            return "Unauthorized " + (message ?? "")
        case .Forbidden(let message):
            return "Forbidden " + (message ?? "")
        case .ServerError:
            return "ServerError"
        case .RequestError(let code, let title, let message):
            return "RequestError " + "code: " + String(code) + " | \(title ?? "") | \(message ?? "")"
        case .UnexpectedResponse:
            return "UnexpectedResponse"
        case .NoConnection:
            return "NoConnection"
        case .Unknown(let error):
            if let error = error {
                return "Unknown " + (error.localizedFailureReason ?? "") + " " + error.localizedDescription
            }
            return "Unknown"
        }
    }
    
    public func errorDescription() -> ErrorDescription {
        switch self {
        case .Unauthorized(let message):
            return ErrorDescription(title: "Not authorized to perform action", message: message)
        case .Forbidden(let message):
            return ErrorDescription(title: "Acton not allowed", message: message)
        case .ServerError:
            return ErrorDescription(title: "Server error while performing action", message: nil)
        case .RequestError(_, let title, let message):
            return ErrorDescription(title: title ?? "", message: message)
        case .UnexpectedResponse:
            return ErrorDescription(title: "Unexpected response from server", message: nil)
        case .NoConnection:
            return ErrorDescription(title: "No network connection", message: "Check your connection and try again")
        case .Unknown(let error):
            return ErrorDescription(title: "Error", message: error?.localizedDescription)
        }
    }
    
}

public struct ErrorDescription {
    public let title: String
    public let message: String?
    
    public init(title: String, message: String?) {
        self.title = title
        self.message = message
    }
}
