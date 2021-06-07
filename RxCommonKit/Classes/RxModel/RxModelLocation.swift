
import UIKit
import BFKit
import GRDB.Swift
import HandyJSON.Swift

public class RxModelLocation: RxModelBase {
    
    public class override var databaseTableName: String { "tb_location" }
    enum Columns: String, ColumnExpression {
        case id, latitude, longitude, country, province, city, state, area, street, thoroughfare, countryCode, countryNunber, postalCode, address, addressLines
    }
    /// 经度
    public var latitude: Double = 0
    /// 纬度
    public var longitude: Double = 0
    /// 国家
    public var country: String = ""
    /// 省
    public var province: String = ""
    /// 市
    public var city: String = ""
    /// 县
    public var state: String = ""
    /// 区
    public var area: String = ""
    /// 街道
    public var street: String = ""
    /// 要道
    public var thoroughfare: String = ""
    /// 国家简称 US
    public var countryCode: String = ""
    /// 国家编号
    public var countryNunber: String = ""
    /// 邮政编码
    public var postalCode: String = ""
    /// 具体地址 - 什么店
    public var address: String = ""
    /// 详细地址 - 街道 城市 省份 国家
    public var addressLines: [String]?
    /// 字典数据
    public var addressDictionary: [AnyHashable: Any]?
    
    public required override init() {
        super.init()
    }
    public required init<T: RxModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else { return }
        
        self.latitude = model.latitude
        self.longitude = model.longitude
        self.country = model.country
        self.province = model.province
        self.city = model.city
        self.state = model.state
        self.area = model.area
        self.street = model.street
        self.thoroughfare = model.thoroughfare
        self.countryCode = model.countryCode
        self.countryNunber = model.countryNunber
        self.postalCode = model.postalCode
        self.address = model.address
        self.addressLines = model.addressLines
        self.addressDictionary = model.addressDictionary
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.latitude = row[Columns.latitude] ?? 0
        self.longitude = row[Columns.longitude] ?? 0
        self.country = row[Columns.country] ?? ""
        self.province = row[Columns.province] ?? ""
        self.city = row[Columns.city] ?? ""
        self.state = row[Columns.state] ?? ""
        self.area = row[Columns.area] ?? ""
        self.street = row[Columns.street] ?? ""
        self.thoroughfare = row[Columns.thoroughfare] ?? ""
        self.countryCode = row[Columns.countryCode] ?? ""
        self.countryNunber = row[Columns.countryNunber] ?? ""
        self.postalCode = row[Columns.postalCode] ?? ""
        self.address = row[Columns.address] ?? ""
        let lines = row[Columns.countryNunber] ?? ""
        self.addressLines = lines.components(separatedBy: "@")
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.id] = self.id
        container[Columns.latitude] = self.latitude
        container[Columns.longitude] = self.longitude
        container[Columns.country] = self.country
        container[Columns.province] = self.province
        container[Columns.city] = self.city
        container[Columns.state] = self.state
        container[Columns.area] = self.area
        container[Columns.street] = self.street
        container[Columns.thoroughfare] = self.thoroughfare
        container[Columns.countryCode] = self.countryCode
        container[Columns.countryNunber] = self.countryNunber
        container[Columns.postalCode] = self.postalCode
        container[Columns.address] = self.address
        container[Columns.addressLines] = self.addressLines?.joined(separator: "@") ?? ""
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
    }
}
