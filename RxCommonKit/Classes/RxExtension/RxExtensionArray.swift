
import UIKit

extension Array where Element: Equatable {
    /// 去重复
    public mutating func removeDuplicates() {
        var result = [Element]()
        self.forEach { (val) in
            if !result.contains(val) {
                result.append(val)
            }
        }
        self.removeAll()
        self.append(contentsOf: result)
    }
}
