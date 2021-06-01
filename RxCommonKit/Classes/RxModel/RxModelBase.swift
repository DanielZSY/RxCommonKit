
import UIKit
import BFKit
import GRDB.Swift
import HandyJSON.Swift

public protocol RxModelBase: HandyJSON, TableRecord, FetchableRecord, PersistableRecord, EncodableRecord {
    
    var id: Int64 { get set }
    var rawData: [String: Any]? { get set }
    
    init(instance: Self)
}
extension RxModelBase {
    
    public func copyable() -> Self {
        return Self.init(instance: self)
    }
}
