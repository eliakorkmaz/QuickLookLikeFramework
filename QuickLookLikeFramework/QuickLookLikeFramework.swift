//
//  QuickLookLikeFramework.swift
//  QuickLookLikeFramework
//
//  Created by Emrah Korkmaz on 22.12.2022.
//

import Foundation
import UIKit
import OSLog
import PDFKit

public protocol QuickLookLikePreviewItem {
    var previewItemURL: URL? { get }
}


extension URL : QuickLookLikePreviewItem {
    public var previewItemURL: URL? {
        return absoluteURL
    }
}



public protocol QuickLookLikeDelegate: AnyObject {
    func previewControllerWillDismiss(_ controller: QuickLookLikeController)
    func previewControllerDidDismiss(_ controller: QuickLookLikeController)
    func previewControllerDidSelected(_ index: Int)
}

public protocol QuickLookLikeDataSource: AnyObject {
    func numberOfPreviewItems(in controller: QuickLookLikeController) -> Int
    func previewController(_ controller: QuickLookLikeController, previewItemAt index: Int) -> QuickLookLikePreviewItem
}

public class QuickLookLikeController: UIViewController {
    
    private var logger: Logger!
    
    private lazy var contentTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    public weak var delegate: QuickLookLikeDelegate?
    public weak var dataSource: QuickLookLikeDataSource?
    
    deinit { print("deinit") }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        logger = Logger(subsystem: identifierForBundle, category: "QuickLookLikePreview")
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        logger.debug("viewDidLoad")
        setupUI()
        title = "merhaba"
    }
    
    /*
    public func present(from: UIViewController) {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.modalPresentationStyle = .fullScreen
        
        from.present(navigationController, animated: true)
    }*/
    
    public override var modalPresentationStyle: UIModalPresentationStyle {
        get { .fullScreen }
        set { }
    }
}
extension QuickLookLikeController {
    
    var identifierForBundle: String { Bundle.main.bundleIdentifier ?? "" }
    
    func setupUI() {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        print("inset from top ", view.safeAreaLayoutGuide.layoutFrame.size.height)
        //self.tableView.contentInset = UIEdgeInsets(top: -self.topLayoutGuide.length, left: 0, bottom: 0, right: 0)

        
        view.backgroundColor = .white
        view.addSubview(navBar)
        
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        //self.view.safeAreaInsets.top
        
        

        let navItem = UINavigationItem(title: "SomeTitle")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil , action: #selector(handle))
        navItem.rightBarButtonItem = doneItem

        let leftItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(present2))
        navItem.leftBarButtonItem = leftItem
        
        
        navBar.setItems([navItem], animated: false)
        
        view.addSubview(contentTableView)
        contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
                                       
    @objc func handle() {
        self.dismiss(animated: true)
    }
    
    @objc func present2() {
        let presentationController = QuickLookLikePreviewController()
        self.present(presentationController, animated: true)
    }
    
    private class QuickLookLikePreviewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .blue
        }
    }

}

extension QuickLookLikeController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.numberOfPreviewItems(in: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        guard let itemUrl = dataSource?.previewController(self, previewItemAt: indexPath.row) else { fatalError("-") }
        
        
        
        print("item url ", itemUrl.previewItemURL)
        let textToCell = itemUrl.previewItemURL?.absoluteString ?? ""
        
        
        
        cell.textLabel?.text = "URL #\(textToCell)"
        
        return cell
    }
}

