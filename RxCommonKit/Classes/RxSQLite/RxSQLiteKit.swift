
import UIKit
import BFKit
import GRDB.Swift

fileprivate let RxDBName: String = "KitDatabase.sqlite"
fileprivate let RxDBPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appendingPathComponent(RxDBName) ?? RxDBName

/// 本地化数据库操作
public struct RxSQLiteKit {
    
    /// 连接数据库
    private var dbQueue: DatabaseQueue?
    /// 单例模式
    public static var shared = RxSQLiteKit()
    /// 连接池
    public var connection: DatabaseQueue? { return self.dbQueue }
    /// 打开数据库
    public mutating func open() {
        BFLog.error("dbpath: \(RxDBPath)")
        if self.dbQueue == nil {
            do {
                var configuration = Configuration()
                configuration.readonly = false
                self.dbQueue = try DatabaseQueue.init(path: RxDBPath, configuration: configuration)
            } catch {
                BFLog.error("create DatabaseQueue error: \(error.localizedDescription)")
            }
        }
        self.checkVersion()
    }
    /// 关闭数据库
    public mutating func close() {
        self.dbQueue?.releaseMemory()
        self.dbQueue = nil
    }
    /// 检测版本
    private mutating func checkVersion() {
        if self.dbQueue == nil { return }
        // 当前App数据库版本
        var model: RxModelVersion?
        RxSQLiteKit.getMaxModel(model: &model, column: RxModelVersion.Columns.version.rawValue)
        if let version = model {
            switch version.version {
            case 0:
                RxSQLiteVersion.createTables()
            default: break
            }
        } else {
            model = RxModelVersion()
            RxSQLiteVersion.createTables()
        }
        model?.version = RxSQLiteVersion.dbVersion
        RxSQLiteKit.setModel(model: model!)
    }
}
extension RxSQLiteKit {
    /// 获取数据对象
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getModel<T: RxModelBase>(model: inout T?, filter: String, values: [Any]) {
        do {
            try RxSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    model = try T.filter(sql: filter, arguments: arguments).fetchOne(db)
                } else {
                    model = try T.filter(sql: filter).fetchOne(db)
                }
            })
        } catch {
            BFLog.error("sqlite read error: \(error.localizedDescription)")
        }
    }
    /// 获取数据对象
    /// column 字段名称
    public static func getMaxModel<T: RxModelBase>(model: inout T?, column: String) {
        do {
            try RxSQLiteKit.shared.connection?.write({ db in
                if try db.tableExists(T.databaseTableName) {
                    model = try T.select(max(Column.init(column))).fetchOne(db)
                }
            })
        } catch {
            BFLog.error("sqlite read error: \(error.localizedDescription)")
        }
    }
    /// 获取指定条件纪录数
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getArrayCount<T: RxModelBase>(type: T.Type, count: inout Int, filter: String, values: [Any]) {
        do {
            try RxSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    count = try T.filter(sql: filter, arguments: arguments).fetchCount(db)
                } else {
                    count = try T.filter(sql: filter).fetchCount(db)
                }
            })
        } catch {
            BFLog.error("sqlite read error: \(error.localizedDescription)")
        }
    }
    /// 获取制定条件对象集合
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getArrayWhere<T: RxModelBase>(models: inout [T]?, filter: String, values: [Any], order: String? = nil, page: Int = 0) {
        do {
            let page = kPageCount
            try RxSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    if let strOrder = order {
                        models = try T.filter(sql: filter, arguments: arguments).order(Column(strOrder).desc).limit(page * page, offset: page).fetchAll(db)
                    } else {
                        models = try T.filter(sql: filter, arguments: arguments).limit(page * page, offset: page).fetchAll(db)
                    }
                } else {
                    if let strOrder = order {
                        models = try T.filter(sql: filter).limit(page * page, offset: page).order(Column(strOrder).desc).fetchAll(db)
                    } else {
                        models = try T.filter(sql: filter).limit(page * page, offset: page).fetchAll(db)
                    }
                }
            })
        } catch {
            BFLog.error("sqlite read error: \(error.localizedDescription)")
        }
    }
    /// 获取所有对象
    public static func getArrayAll<T: RxModelBase>(models: inout [T]?) {
        do {
            try RxSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db)
            })
        } catch {
            BFLog.error("sqlite read error: \(error.localizedDescription)")
        }
    }
    /// 设置对象
    public static func setModel<T: RxModelBase>(model: T) {
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                try model.save(db)
            })
        } catch {
            BFLog.error("sqlite save error: \(error.localizedDescription)")
        }
    }
    /// 设置对象集合
    public static func setModels<T: RxModelBase>(models: [T]) {
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                try models.forEach { model in
                    try model.save(db)
                }
            })
        } catch {
            BFLog.error("sqlite save error: \(error.localizedDescription)")
        }
    }
    /// 修改对象
    public static func updModel<T: RxModelBase>(model: T) {
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                try model.update(db)
            })
        } catch {
            BFLog.error("sqlite update error: \(error.localizedDescription)")
        }
    }
    /// 删除对象
    @discardableResult
    public static func delModel<T: RxModelBase>(model: T) -> Bool {
        var success: Bool = false
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                success = try model.delete(db)
            })
        } catch {
            BFLog.error("sqlite delete error: \(error.localizedDescription)")
        }
        return success
    }
    /// 删除某表数据
    @discardableResult
    public static func delAllModel<T: RxModelBase>(type: T.Type) -> Int {
        var count: Int = 0
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                count = try T.deleteAll(db)
            })
        } catch {
            BFLog.error("sqlite deleteall error: \(error.localizedDescription)")
        }
        return count
    }
}
extension RxModelBase {
    /// 设置对象
    public func save() {
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                try self.save(db)
            })
        } catch {
            BFLog.error("sqlite save error: \(error.localizedDescription)")
        }
    }
    /// 修改对象
    public func update() {
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                try self.update(db)
            })
        } catch {
            BFLog.error("sqlite update error: \(error.localizedDescription)")
        }
    }
    /// 删除对象
    @discardableResult
    public func delete() -> Bool {
        var success: Bool = false
        do {
            try RxSQLiteKit.shared.connection?.write({ (db) in
                success = try self.delete(db)
            })
        } catch {
            BFLog.error("sqlite delete error: \(error.localizedDescription)")
        }
        return success
    }
}
