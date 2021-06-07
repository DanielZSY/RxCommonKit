
import UIKit
import BFKit
import RxCommonKit

class HomeViewController: UIViewController {
    
    private lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let array: [String] = ["ChatList", "UserList", "WSSConnect", "SendMessage"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Demo"
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = .clear
        self.view.addSubview(collectionView)
        self.adapter.collectionView = collectionView
        
        let dataSource = RxListAdapterDataSource<String>(sectionControllerProvider: { (_, _) -> DetailLabelSectionController in
            let cell = DetailLabelSectionController()
            cell.onDidSelectItem = { row in
                switch row {
                case 0: RxRouterKit.push(path: RxRoutableVC.create(ChatListViewController.self, nil))
                case 1: RxRouterKit.push(path: RxRoutableVC.create(UserListViewController.self, nil))
                case 2:
                    RxTimerKit.shared.startTimer()
                    RxWebSocketKit.shared.reconnect()
                case 3:
                    var param = [String: Any]()
                    param["appId"] = 101
                    param["userId"] = "100000"
                    param["message"] = "test message"
                    RxNetworkKit.created.request(target: .post("/user/sendMessage", param), encryption: false, completionBlock: { [weak self] result in
                        guard let `self` = self else { return }
                        
                    })
                default: break
                }
            }
            return cell
        })
        let itemSignal = BehaviorSubject<[String]>(value: [])
        itemSignal.onNext(array)
        itemSignal.bind(to: adapter.rx.objects(for: dataSource)).disposed(by: disposeBag)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = self.view.bounds
    }
}
