import UIKit
import GRDB.Swift
import HandyJSON.Swift

public struct RxModelMessageRecord: RxModelBase {
    
    public var id: Int64 = 0
    public var rawData: [String : Any]?
    public static let databaseTableName = "tb_rxmessagerecord"
    enum Columns: String, ColumnExpression {
        case messageUserId, messageId, messageUnReadCount, messageLoginUserId
    }
    public var messageUserId: Int64 = 0
    public var messageId: String = ""
    public var messageUnReadCount: Int = 0
    public var messageLoginUserId: Int64 = RxUserSetting.shared.userId
    
    public init() {
        
    }
    public init(instance: RxModelMessageRecord) {
        self.id = instance.id
        self.rawData = instance.rawData
        self.messageUserId = instance.messageUserId
        self.messageId = instance.messageId
        self.messageUnReadCount = instance.messageUnReadCount
        self.messageLoginUserId = instance.messageLoginUserId
    }
    public init(row: Row) {
        self.messageUserId = row[Columns.messageUserId] ?? 0
        self.messageId = row[Columns.messageId] ?? ""
        self.messageLoginUserId = row[Columns.messageLoginUserId] ?? 0
    }
    public mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    public func encode(to container: inout PersistenceContainer) {
        container[Columns.messageUserId] = self.messageUserId
        container[Columns.messageId] = self.messageId
        container[Columns.messageUnReadCount] = self.messageUnReadCount
        container[Columns.messageLoginUserId] = self.messageLoginUserId
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
