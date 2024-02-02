import Foundation

public class SDKConfiguration {
    
    private init() {}
    private var _api: SDKAPIData?
    public static let shared: SDKConfiguration = SDKConfiguration()

    public var api: SDKAPIData {
        get {
            guard let apiConfig = _api else {
                fatalError("CEO Dogs SDK API configuration is not set, use `api` property to set `SDKAPIData`")
            }
            return apiConfig
        }
        set {
            _api = newValue
        }
    }
}

public struct SDKAPIData {
    let apiRootScheme: String
    let apiRootHost: String
    let apiServerHost: String

    public init(rootScheme: String, rootHost: String, serverHost: String) {
        self.apiRootScheme = rootScheme
        self.apiRootHost = rootHost
        self.apiServerHost = serverHost
    }
}
