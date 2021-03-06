
import UIKit

extension String {
    public var locale: String {
        let format = Bundle.main.localizedString(forKey: self, value: nil, table: "RxLocalizable")
        return String(format: format, locale: Locale.current)
    }
    public var color: UIColor {
        return UIColor.init(hex: self)
    }
    public var image: UIImage? {
        return UIImage.init(named: self)
    }
    public var scale: CGFloat {
        return CGFloat(self.floatValue) * kScreenScale
    }
    public var length: Int {
        return self.count
    }
    public var longLongValue: Int64 {
        return Int64(NSString(string: self).longLongValue)
    }
    public var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    public func isEqual(_ value: String) -> Bool {
        return self == value
    }
    public func toRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }
    public func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: utf16),
              let to = range.upperBound.samePosition(in: utf16) else {
            return nil
        }
        let location = utf16.distance(from: utf16.startIndex, to: from)
        let length = utf16.distance(from: from, to: to)
        
        return NSRange(location: location, length: length)
    }
    public func getWidth(_ font: UIFont, height: CGFloat = 22) -> CGFloat {
        
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.width)
    }
    public func getHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.height)
    }
    public func getOneHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: " ").boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.height)
    }
    public var base64encoded: String {
        guard let data: Data = data(using: .utf8) else { return "" }
        return data.base64EncodedString()
    }
    public var base64decoded: String {
        guard let data = Data(base64Encoded: String(self), options: .ignoreUnknownCharacters), let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return ""
        }
        return String(describing: dataString)
    }
    public var urlEncoded: String? {
        addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
    }
    public var urlDecoded: String? {
        return self.removingPercentEncoding
    }
    public func character(at index: Int) -> Character {
        self[self.index(startIndex, offsetBy: index)]
    }
    public func substring(from index: Int) -> String {
        String(self[self.index(startIndex, offsetBy: index)...])
    }
    public func substring(from character: Character) -> String {
        let index = self.index(of: character)
        guard index > -1 else { return "" }
        return substring(from: index + 1)
    }
    public func substring(to index: Int) -> String {
        guard index <= count else { return "" }
        return String(self[..<self.index(startIndex, offsetBy: index)])
    }
    public func substring(to character: Character) -> String {
        let index: Int = self.index(of: character)
        guard index > -1 else { return "" }
        return substring(to: index)
    }
    public func substring(with range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        
        return String(self[start..<end])
    }
    public func substring(with range: CountableClosedRange<Int>) -> String {
        substring(with: Range(uncheckedBounds: (lower: range.lowerBound, upper: range.upperBound + 1)))
    }
    public func index(of character: Character) -> Int {
        guard let index: Index = firstIndex(of: character) else { return -1 }
        return distance(from: startIndex, to: index)
    }
    public func range(of string: String, caseSensitive: Bool = true) -> Bool {
        caseSensitive ? (range(of: string) != nil) : (lowercased().range(of: string.lowercased()) != nil)
    }
    public func has(_ string: String, caseSensitive: Bool = true) -> Bool {
        range(of: string, caseSensitive: caseSensitive)
    }
    public func occurrences(of string: String, caseSensitive: Bool = true) -> Int {
        var string = string
        if !caseSensitive { string = string.lowercased() }
        return lowercased().components(separatedBy: string).count - 1
    }
    public func queryStringParameter(parameter: String) -> String? {
        guard let url = URLComponents(string: self) else { return nil }
        return url.queryItems?.first { $0.name == parameter }?.value
    }
    public func queryDictionary() -> [String: String] {
        var queryStrings: [String: String] = [:]
        for pair in self.components(separatedBy: "&") {
            let key = pair.components(separatedBy: "=")[0]
            let value = pair.components(separatedBy: "=")[1].replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
    public func replacingOccurrences(of target: [String], with replacement: String) -> String {
        var string = self
        for occurrence in target {
            string = string.replacingOccurrences(of: occurrence, with: replacement)
        }
        return string
    }
    /// ????????????
    public func isEmail() -> Bool {
        if self.length == 0 { return false }
        let emailRegex = "^([A-Za-z0-9_\\.-]+)@([\\dA-Za-z\\.-]+)\\.([A-Za-z\\.]{2,6})$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: self)
    }
}
extension NSAttributedString {
    
    /// ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    ///
    /// - Parameters:
    ///   - width: ??????????????????
    ///   - height: ??????????????????
    /// - Returns: ???????????????size
    public func getSize(width: CGFloat, height: CGFloat) -> CGSize {
        let attributed = self
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        let framesetter = CTFramesetterCreateWithAttributedString(attributed)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange.init(location: 0, length: attributed.length), nil, rect.size, nil)
        return CGSize.init(width: size.width + 1, height: size.height + 1)
    }
    public func getImageRunFrame(run: CTRun, lineOringinPoint: CGPoint, offsetX: CGFloat) -> CGRect {
        /// ???????????? ??????
        var runBounds = CGRect.zero
        var h: CGFloat = 0
        var w: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var asecnt: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        
        let cfRange = CFRange.init(location: 0, length: 0)
        
        w = CGFloat(CTRunGetTypographicBounds(run, cfRange, &asecnt, &descent, &leading))
        h = asecnt + descent + leading
        /// ???????????????????????????????????????????????? || ???????????????
        x = offsetX + lineOringinPoint.x
        /// y
        y = lineOringinPoint.y - descent
        runBounds = CGRect.init(x: x, y: y, width: w, height: h)
        return runBounds
    }
}
