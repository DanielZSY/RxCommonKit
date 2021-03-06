import UIKit
import GRDB.Swift
import HandyJSON.Swift

/// 省市区数据结构
public class RxModelArea: RxModelBase {
    
    public class override var databaseTableName: String { "tb_area" }
    enum Columns: String, ColumnExpression {
        case id, pid, code, name
    }
    public var pid: Int = 0
    public var code: String = ""
    public var name: String = ""
    
    public required init() {
        super.init()
    }
    public required init<T: RxModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else { return }
        self.pid = model.pid
        self.code = model.code
        self.name = model.name
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.id = row[Columns.id] ?? 0
        self.pid = row[Columns.pid] ?? 0
        self.code = row[Columns.code] ?? ""
        self.name = row[Columns.name] ?? ""
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.id] = self.id
        container[Columns.pid] = self.pid
        container[Columns.code] = self.code
        container[Columns.name] = self.name
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
    }
}
