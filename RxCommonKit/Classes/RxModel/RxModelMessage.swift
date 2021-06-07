
import UIKit
import GRDB.Swift
import HandyJSON.Swift

/// 自定义消息对象
public class RxModelMessage: RxModelBase {
    
    public class override var databaseTableName: String { "tb_message" }
    enum Columns: String, ColumnExpression {
        case messageUserId, messageId, messageContent, messageType, messageDirection, messageTime, messageSendState, messageUnReadCount, messageFileId, messageFileName, messageLoginUserId
    }
    public var messageUserId: Int64 = 0
    public var messageId: String = ""
    public var messageContent: String = ""
    /// 0 文本 1 语音 2 图片 3 定位 4 视频 9 系统
    public var messageType: Int = 0
    /// 0 发送 1 接收
    public var messageDirection: Int = 0
    public var messageTime: TimeInterval = 0.0
    /// 0 未发送/发送中 1 发送成功 2 发送失败 3 对方已读
    public var messageSendState: Int = 0
    public var messageUnReadCount: Int = 0
    public var messageFileId: String = ""
    public var messageFileName: String = ""
    public var messageLoginUserId: Int64 = RxUserSetting.shared.userId
    
    public required init() {
        super.init()
    }
    public required init<T: RxModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else { return }
        
        self.messageUserId = model.messageUserId
        self.messageId = model.messageId
        self.messageContent = model.messageContent
        self.messageType = model.messageType
        self.messageDirection = model.messageDirection
        self.messageTime = model.messageTime
        self.messageSendState = model.messageSendState
        self.messageUnReadCount = model.messageUnReadCount
        self.messageFileId = model.messageFileId
        self.messageFileName = model.messageFileName
        self.messageLoginUserId = model.messageLoginUserId
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.messageUserId = row[Columns.messageUserId] ?? 0
        self.messageId = row[Columns.messageId] ?? ""
        self.messageContent = row[Columns.messageContent] ?? ""
        self.messageType = row[Columns.messageUserId] ?? 0
        self.messageDirection = row[Columns.messageDirection] ?? 0
        self.messageTime = row[Columns.messageTime] ?? 0.0
        self.messageSendState = row[Columns.messageSendState] ?? 0
        self.messageUnReadCount = row[Columns.messageUnReadCount] ?? 0
        self.messageFileId = row[Columns.messageFileId] ?? ""
        self.messageFileName = row[Columns.messageFileName] ?? ""
        self.messageLoginUserId = row[Columns.messageLoginUserId] ?? 0
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.messageUserId] = self.messageUserId
        container[Columns.messageId] = self.messageId
        container[Columns.messageContent] = self.messageContent
        container[Columns.messageType] = self.messageType
        container[Columns.messageDirection] = self.messageDirection
        container[Columns.messageTime] = self.messageTime
        container[Columns.messageSendState] = self.messageSendState
        container[Columns.messageUnReadCount] = self.messageUnReadCount
        container[Columns.messageFileId] = self.messageFileId
        container[Columns.messageFileName] = self.messageFileName
        container[Columns.messageLoginUserId] = self.messageLoginUserId
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
    }
}
