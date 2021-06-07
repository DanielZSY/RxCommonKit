
import UIKit
import BFKit
import RxSwift
import RxCocoa
import MessageKit
import RxCommonKit

class MessagesViewController: message, RxRoutableBase {
    
    private var userId: String = ""
    
    static func create(params: Any?) -> UIViewController {
        let itemVC = MessagesViewController()
        itemVC.userId = (params as? String) ?? ""
        return itemVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Message"
        self.view.backgroundColor = .white
    }
}
