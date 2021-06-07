
import UIKit
import BFKit
import RxCommonKit

class ChatListViewController: UIViewController, RxRoutableBase {
    
    static func create(params: Any?) -> UIViewController {
        let item = ChatListViewController()
        return item
    }
    private lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let array: [String] = ["Daniel", "Danny"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ChatList"
        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .clear
        self.view.addSubview(collectionView)
        self.adapter.collectionView = collectionView
        
        let dataSource = RxListAdapterDataSource<String>(sectionControllerProvider: { (_, _) -> DetailLabelSectionController in
            let cell = DetailLabelSectionController()
            cell.onDidSelectItem = { [weak self] row in
                guard let `self` = self else { return }
                guard let param = self.array.safeObject(at: row) else { return }
                RxRouterKit.push(path: RxRoutableVC.create(MessageViewController.self, param))
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
