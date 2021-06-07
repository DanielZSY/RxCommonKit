
import UIKit
import BFKit
import RxSwift
import RxCocoa
import MessageKit
import RxCommonKit

class MessageViewController: MessagesViewController, RxRoutableBase {
    
    private var userId: String = ""
    
    static func create(params: Any?) -> UIViewController {
        let itemVC = MessageViewController()
        itemVC.userId = (params as? String) ?? ""
        return itemVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Message"
        self.view.backgroundColor = .white
        
        
    }
}
