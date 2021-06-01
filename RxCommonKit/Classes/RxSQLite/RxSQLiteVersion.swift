
import UIKit
import BFKit
import GRDB.Swift
import CryptoSwift

/// 数据库版本管理
internal struct RxSQLiteVersion {
    
    /// 当前App本地版本
    internal static let dbVersion: Int = 1
    /// 创建数据表 Version 1
    internal static func createTables() {
        do {
            try RxSQLiteKit.shared.connection?.write { db in
                try db.create(table: RxModelVersion.databaseTableName, ifNotExists: true, body: { t in
                    t.column("version", .integer).notNull().defaults(to: 0).indexed()
                    t.column("content", .text).notNull().defaults(to: "")
                    t.primaryKey(["version"])
                })
                try db.create(table: RxModelMessage.databaseTableName, ifNotExists: true, body: { t in
                    t.column("messageId", .integer).notNull().defaults(to: 0)
                    t.column("messageUserId", .text).notNull().defaults(to: "")
                    t.column("messageContent", .text).notNull().defaults(to: "")
                    t.column("messageType", .integer).notNull().defaults(to: 0)
                    t.column("message_time", .double).notNull().defaults(to: 0)
                    t.column("messageDirection", .integer).notNull().defaults(to: 0)
                    t.column("messageTime", .integer).notNull().defaults(to: 0)
                    t.column("messageSendState", .integer).notNull().defaults(to: 0)
                    t.column("messageFileId", .text).notNull().defaults(to: "")
                    t.column("messageFileName", .text).notNull().defaults(to: "")
                    t.column("messageLoginUserId", .integer).notNull().defaults(to: 0).indexed()
                    t.primaryKey(["message_id"])
                })
            }
        } catch {
            BFLog.error("createdb version error: \(error.localizedDescription)")
        }
    }
}
