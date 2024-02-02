import Foundation

/**
 Represents server API call outcome
 */
public enum APIResponse<Value> {
    case success(Value)
    case failure(APIError)
    
    /**
     Returns if operation succesfull
     - Returns: true if success, false otherwise
     */
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /**
     Returns if operation failed
     - Returns: false if failure, true otherwise
     */
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /**
     Operation result
     - Returns: the operation result if the call is a success, `nil` otherwise.
     */
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /**
     Operation error
     - Returns: the operation error if the call failed, `nil` otherwise.
     */
    public var error: APIError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
