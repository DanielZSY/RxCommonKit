import UIKit
import GRDB.Swift
import HandyJSON.Swift

public class RxModelMessageRecord: RxModelBase {
    
    public class override var databaseTableName: String { "tb_messagerecord" }
    enum Columns: String, ColumnExpression {
        case messageUserId, messageId, messageUnReadCount, messageLoginUserId
    }
    public var messageUserId: Int64 = 0
    public var messageId: String = ""
    public var messageUnReadCount: Int = 0
    public var messageLoginUserId: Int64 = RxUserSetting.shared.userId
    
    public required init() {
        super.init()
    }
    public required init<T: RxModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else { return }
        
        self.messageUserId = model.messageUserId
        self.messageId = model.messageId
        self.messageUnReadCount = model.messageUnReadCount
        self.messageLoginUserId = model.messageLoginUserId
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.messageUserId = row[Columns.messageUserId] ?? 0
        self.messageId = row[Columns.messageId] ?? ""
        self.messageLoginUserId = row[Columns.messageLoginUserId] ?? 0
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.messageUserId] = self.messageUserId
        container[Columns.messageId] = self.messageId
        container[Columns.messageUnReadCount] = self.messageUnReadCount
        container[Columns.messageLoginUserId] = self.messageLoginUserId
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
    }
}
