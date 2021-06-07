
import UIKit
import BFKit
import RxCommonKit

class HomeViewController: UIViewController {
    
    private lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let array: [String] = ["ChatList", "UserList"]

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
