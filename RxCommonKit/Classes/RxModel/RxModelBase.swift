import UIKit
import GRDB.Swift
import HandyJSON.Swift

public protocol RxModelCopyable {
    
    init(instance: Self)
}
extension RxModelCopyable {
    public func copyable() -> Self {
        return Self.init(instance: self)
    }
}
open class RxModelBase: Record, HandyJSON, RxModelCopyable {
    
    public enum Columns: String, ColumnExpression {
        case id
    }
    public var id: Int64 = 0
    public var rawData: [String: Any]?
    public var dic: [String: Any]? {
        var val = self.toJSON()
        val?.removeValue(forKey: "referenceRow")
        return val
    }
    public required override init() {
        super.init()
    }
    public required init<T: RxModelBase>(instance: T) {
        super.init()
        
        self.id = instance.id
        self.rawData = instance.rawData
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.id = row[RxModelBase.Columns.id] ?? 0
    }
    public override func didInsert(with rowID: Int64, for column: String?) {
        super.didInsert(with: rowID, for: column)
        
        self.id = rowID
    }
    open override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
    }
    open func mapping(mapper: HelpingMapper) {
        
    }
}
