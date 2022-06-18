//
//  FavoriteArticlesViewController.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 16.06.2022.
//

import UIKit
import RealmSwift

class FavoriteArticlesViewController: UIViewController {
    // MARK: - Model
    
    private var viewModel: FavoriteListViewModel = FavoriteListViewModelImpl()
    // MARK: - Private
    
    private lazy var articleTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets.zero
        NewsTableViewCell.register(for: tableView)
        return tableView
    }()
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpViews()
        reloadTableView ()
    }
    // MARK: - Private
    
    private func reloadTableView () {
        self.viewModel.shouldReload = {
            DispatchQueue.main.async {
                self.articleTableView.reloadData()
            }
        }
    }
    
    private func setUpUI() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func setUpViews() {
        view.addSubview(articleTableView)
        articleTableView.layout {
            $0.constraint(to: view, by: .leading(0), .bottom(0), .trailing(0), .top(0))
        }
        self.viewModel.getResults()
    }
}

extension FavoriteArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = NewsTableViewCell.deque(for: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.setUpViews()
        cell.setUpFavoriteInfo(article: self.viewModel.results[indexPath.row])
        
        cell.favouriteButtonAction = { [self] in
            self.viewModel.addToFavorites(path: indexPath)
        }
        
        cell.contentView.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = WebViewController()
        webVC.articleUrl = self.viewModel.results[indexPath.row].url
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}


