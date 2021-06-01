
import UIKit
import HandyJSON
import GRDB.Swift

/// 数据库版本
public struct RxModelVersion: RxModelBase {
    
    public var id: Int64 = 0
    public var rawData: [String : Any]?
    public static let databaseTableName = "tb_rxversion"
    enum Columns: String, ColumnExpression {
        case version, content
    }
    public var version: Int = 0
    public var content: String = ""
    
    public init() {
        
    }
    public init(instance: RxModelVersion) {
        self.id = instance.id
        self.rawData = instance.rawData
        self.version = instance.version
        self.content = instance.content
    }
    public init(row: Row) {
        self.version = row[Columns.version] ?? 0
        self.content = row[Columns.content] ?? ""
    }
    public mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    public func encode(to container: inout PersistenceContainer) {
        container[Columns.version] = self.version
        container[Columns.content] = self.content
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
