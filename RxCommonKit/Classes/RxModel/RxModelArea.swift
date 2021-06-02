import UIKit
import GRDB.Swift
import HandyJSON.Swift

/// 省市区数据结构
public struct RxModelArea: RxModelBase {
    
    public var id: Int64 = 0
    public var rawData: [String : Any]?
    public static let databaseTableName = "tb_rxarea"
    enum Columns: String, ColumnExpression {
        case id, pid, code, name
    }
    public var pid: Int64 = 0
    public var code: String = ""
    public var name: String = ""
    
    public init() {
        
    }
    public init(instance: RxModelArea) {
        self.id = instance.id
        self.pid = instance.pid
        self.rawData = instance.rawData
        self.code = instance.code
        self.name = instance.name
    }
    public init(row: Row) {
        self.id = row[Columns.id] ?? 0
        self.pid = row[Columns.pid] ?? 0
        self.code = row[Columns.code] ?? ""
        self.name = row[Columns.name] ?? ""
    }
    public mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    public func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = self.id
        container[Columns.pid] = self.pid
        container[Columns.code] = self.code
        container[Columns.name] = self.name
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
