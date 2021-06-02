
import UIKit
import BFKit
import GRDB.Swift
import HandyJSON.Swift

public struct RxModelLocation: RxModelBase {
    
    public var id: Int64 = 0
    public var rawData: [String : Any]?
    public static let databaseTableName = "tb_rxlocation"
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
    
    public init() {
        
    }
    public init(instance: RxModelLocation) {
        self.id = instance.id
        self.rawData = instance.rawData
        self.latitude = instance.latitude
        self.longitude = instance.longitude
        self.country = instance.country
        self.province = instance.province
        self.city = instance.city
        self.state = instance.state
        self.area = instance.area
        self.street = instance.street
        self.thoroughfare = instance.thoroughfare
        self.countryCode = instance.countryCode
        self.countryNunber = instance.countryNunber
        self.postalCode = instance.postalCode
        self.address = instance.address
        self.addressLines = instance.addressLines
        self.addressDictionary = instance.addressDictionary
    }
    public init(row: Row) {
        self.id = row[Columns.id] ?? 0
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
    public func encode(to container: inout PersistenceContainer) {
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
}
