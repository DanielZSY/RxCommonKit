
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
                    t.column("messageId", .text).notNull().defaults(to: "").indexed()
                    t.column("messageUserId", .integer).notNull().defaults(to: 0).indexed()
                    t.column("messageContent", .text).notNull().defaults(to: "")
                    t.column("messageType", .integer).notNull().defaults(to: 0)
                    t.column("message_time", .double).notNull().defaults(to: 0)
                    t.column("messageDirection", .integer).notNull().defaults(to: 0)
                    t.column("messageTime", .integer).notNull().defaults(to: 0)
                    t.column("messageSendState", .integer).notNull().defaults(to: 0)
                    t.column("messageFileId", .text).notNull().defaults(to: "")
                    t.column("messageFileName", .text).notNull().defaults(to: "")
                    t.column("messageLoginUserId", .integer).notNull().defaults(to: 0).indexed()
                    t.primaryKey(["messageId"])
                })
                try db.create(table: RxModelMessageRecord.databaseTableName, ifNotExists: true, body: { t in
                    t.column("messageId", .text).notNull().defaults(to: "").indexed()
                    t.column("messageUserId", .integer).notNull().defaults(to: 0).indexed()
                    t.column("messageLoginUserId", .integer).notNull().defaults(to: 0).indexed()
                    t.primaryKey(["messageUserId", "messageLoginUserId"])
                })
                try db.create(table: RxModelArea.databaseTableName, ifNotExists: true, body: { t in
                    t.column("id", .integer).notNull().defaults(to: 0).indexed()
                    t.column("pid", .integer).notNull().defaults(to: 0).indexed()
                    t.column("code", .text).notNull().defaults(to: "").indexed()
                    t.column("name", .text).notNull().defaults(to: "")
                })
                try db.create(table: RxModelLocation.databaseTableName, ifNotExists: true, body: { t in
                    t.column("id", .integer).notNull().defaults(to: 0).indexed()
                    t.column("latitude", .integer).notNull().defaults(to: 0)
                    t.column("longitude", .integer).notNull().defaults(to: 0)
                    t.column("country", .text).notNull().defaults(to: "")
                    t.column("province", .text).notNull().defaults(to: "")
                    t.column("city", .text).notNull().defaults(to: "")
                    t.column("state", .text).notNull().defaults(to: "")
                    t.column("area", .text).notNull().defaults(to: "")
                    t.column("street", .text).notNull().defaults(to: "")
                    t.column("thoroughfare", .text).notNull().defaults(to: "")
                    t.column("countryCode", .text).notNull().defaults(to: "")
                    t.column("countryNunber", .text).notNull().defaults(to: "")
                    t.column("postalCode", .text).notNull().defaults(to: "")
                    t.column("address", .text).notNull().defaults(to: "")
                    t.column("addressLines", .text).notNull().defaults(to: "")
                })
            }
        } catch {
            BFLog.error("createdb version error: \(error.localizedDescription)")
        }
    }
}
