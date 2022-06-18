//
//  NewsListViewController.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Foundation
import UIKit
import RealmSwift

protocol NewsListViewControllerDelegate {
    func infoWasDelegated(params: SelectedParameters)
}

class NewsListViewController: UIViewController {
    
    // MARK: - Private
    
    private var viewModel: NewsListViewModel = NewsListViewModelImpl()
    
    // MARK: - UI
    
    private lazy var refreshControl: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var articleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets.zero
        NewsTableViewCell.register(for: tableView)
        return tableView
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(searchButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.minimumScaleFactor = 0.4
        label.text = "SortByData:"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var sortSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Yes","No"])
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var searchField: UITextField = {
        let searchField = UITextField()
        searchField.font = UIFont.systemFont(ofSize: 18)
        searchField.textColor = UIColor.black
        searchField.placeholder = "Enter"
        searchField.textAlignment = .center
        searchField.borderStyle = UITextField.BorderStyle.line
        return searchField
    }()
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getArticles()
        setUpNavigationbar()
        setUpUI()
        setUpViews()
        addRefreshControl()
        reloadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.articleTableView.reloadData()
    }
    // MARK: - Actions
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch  segmentedControl.selectedSegmentIndex {
        case  0:
            self.viewModel.setNeedToSort(isNeeded: true)
        case  1:
            self.viewModel.setNeedToSort(isNeeded: false)
        default:
            break
        }
    }
    
    @objc func refreshTableView() {
        self.viewModel.pageInfo.limit = 1
        self.viewModel.pageInfo.page = 0
        
        self.viewModel.getArticles()
        articleTableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    @objc private func filterButtonDidTapped() {
        let filtersVC = FiltersViewController()
        filtersVC.delegate = self
        navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    @objc private func favoriteButtonDidTapped() {
        let favoriteArticlesVC = FavoriteArticlesViewController()
        navigationController?.pushViewController(favoriteArticlesVC, animated: true)
    }
    
    @objc private func searchButtonDidTapped() {
        self.viewModel.searchButtonDidTapped(searchField: self.searchField.text)
        self.searchField.text = ""
    }
    // MARK: - Private
    
    private func setUpNavigationbar() {
        applyDefaultNavigationBar()
        
        self.navigationItem.title = "News"
        
        let filterButton = UIBarButtonItem(image: nil,
                                           style: .done,
                                           target: self,
                                           action: #selector(filterButtonDidTapped))
        filterButton.title = "Filters"
        navigationItem.rightBarButtonItem = filterButton
        
        
        let favoriteButton = UIBarButtonItem(image: nil,
                                             style: .done,
                                             target: self,
                                             action: #selector(favoriteButtonDidTapped))
        favoriteButton.title = "Favorite"
        navigationItem.leftBarButtonItem = favoriteButton
    }
    
    private func setUpUI() {
        self.view.backgroundColor = UIColor.white
    }
    
    private func setUpViews() {
        
        view.addSubview(searchButton)
        searchButton.layout {
            $0.top.constraint(to: view, by: .top(20))
            $0.size(.height(30), .width(60))
            $0.leading.constraint(to: self.view, by: .leading(10))
        }
        
        view.addSubview(searchField)
        searchField.layout {
            $0.top.constraint(to: view, by: .top(20))
            $0.size(.height(30), .width(80))
            $0.leading.constraint(to: searchButton, by: .trailing(10))
        }
        
        view.addSubview(articleTableView)
        articleTableView.layout {
            $0.constraint(to: view, by: .leading(0), .bottom(0), .trailing(0))
            $0.top.constraint(to: searchField, by: .bottom(10))
        }
        
        
        view.addSubview(sortLabel)
        sortLabel.layout {
            $0.top.constraint(to: view, by: .top(20))
            $0.size(.height(30), .width(85))
            $0.leading.constraint(to: searchField, by: .trailing(10))
        }
        
        view.addSubview(sortSegmentControl)
        sortSegmentControl.layout {
            $0.top.constraint(to: view, by: .top(20))
            $0.size(.height(30), .width(90))
            $0.leading.constraint(to: sortLabel, by: .trailing(10))
        }
    }
    
    private func getArticles() {
        viewModel.getArticles()
    }
    
    private func addRefreshControl() {
        articleTableView.addSubview(refreshControl!)
        refreshControl?.layout {
            $0.top.constraint(to: articleTableView, by: .top(0))
            $0.centerX.constraint(to: articleTableView, by: .centerX(0))
        }
    }
    
    private func reloadTableView () {
        self.viewModel.shouldReload = {
            DispatchQueue.main.async {
                self.articleTableView.reloadData()
            }
        }
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = NewsTableViewCell.deque(for: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.setUpViews()
        cell.setUpInfo(article: viewModel.articles[indexPath.row])
        
        cell.favouriteButtonAction = { [self] in
            self.viewModel.addToFavorites(path: indexPath)
        }
        
        cell.contentView.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = WebViewController()
        webVC.articleUrl = viewModel.articles[indexPath.row].url
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.paginationTableView(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

extension NewsListViewController: NewsListViewControllerDelegate {
    func infoWasDelegated(params: SelectedParameters) {
        self.viewModel.infoWasDelegated(params: params)
    }
}
