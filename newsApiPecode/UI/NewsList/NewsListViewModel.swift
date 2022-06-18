//
//  NewsListViewModel.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 17.06.2022.
//

import Foundation
import RealmSwift

protocol NewsListViewModel {
    var shouldReload: (() -> Void)? { get set }
    var articles: [Article] { get set }
    var pageInfo: ListPageInfo { get set}
    
    func getArticles()
    func setNeedToSort(isNeeded: Bool)
    func searchButtonDidTapped(searchField: String?)
    func infoWasDelegated(params: SelectedParameters)
    func addToFavorites(path: IndexPath)
    func paginationTableView(index: IndexPath)
}

class NewsListViewModelImpl: NewsListViewModel {
    
    var shouldReload: (() -> Void)?
    
    private lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var articles: [Article] = []
    lazy var pageInfo: ListPageInfo = ListPageInfo(limit: 1, page: 0, amountOfArticles: 0)
    
    private var favorites: [FavoriteArticle]?
    private var filters: [QueryParameter]?
    private var params: [QueryParameter] = []
    
    private var word: QueryParameter?
    private var country: QueryParameter?
    private var source: QueryParameter?
    private var category: QueryParameter?
    
    private var isFiltered: Bool = false
    private var isNeedToSort: Bool = false
    
    func infoWasDelegated(params: SelectedParameters) {
        self.params.removeAll()
        
        filters = []
        if let source = params.source  {
            filters?.append(QueryParameter(key: "source", value: source))
        }
        
        if let country = params.country{
            filters?.append(QueryParameter(key: "country", value: country))
        }
        
        if let category = params.category {
            filters?.append(QueryParameter(key: "category", value: category))
        }
        
        self.getArticles(isFiltered: true)
        self.isFiltered = false
    }
    
    func getArticles() {
        self.getArticles(isFiltered: isFiltered)
    }
    
    func searchButtonDidTapped(searchField: String?)  {
        self.articles.removeAll()
        
        if let searchValue = searchField, !searchField!.isEmpty {
            clearParams(searchValue: searchValue)
        }
        
        if let filters = filters {
            for filter in filters {
                self.params.append(filter)
            }
        }
        
        self.filters?.removeAll()
        self.getArticles()
        self.pageInfo.limit = 1
        self.pageInfo.page = 0
    }
    
    func addToFavorites(path: IndexPath) {
        let favorite = FavoriteArticle()
        let article = self.articles[path.row]
        favorite.author = article.author
        favorite.source = article.source.name!
        favorite.articleDescription = article.description!
        favorite.urlToImage = article.urlToImage ?? ""
        favorite.title = article.title
        favorite.url = article.url
        
        FavouriteService.shared.articleDidTapped(title: self.articles[path.row].title, favorite: favorite)
        self.shouldReload?()
    }
    
    func setNeedToSort(isNeeded: Bool) {
        if isNeeded {
            self.isNeedToSort = true
        } else {
            self.isNeedToSort = false
        }
    }
    
    func paginationTableView(index: IndexPath) {
        if index.row == articles.count - 1 {
            self.pageInfo.limit += 1
            
            if (pageInfo.limit < pageInfo.amountOfArticles) {
                self.getArticles(isFiltered: self.isFiltered)
            }
        }
    }
    
    private func clearParams(searchValue: String) {
        self.params.removeAll()
        self.params.append(QueryParameter(key: "q", value: searchValue))
        self.articles.removeAll()
        self.pageInfo.limit = 1
        self.pageInfo.page = 0
    }
    
    private func getArticles(isFiltered: Bool) {
        NetworkService.shared.getArticles(params: params, isFilters: isFiltered, isNeedToBeSorted: isNeedToSort, completion: { (articles, error) in
            self.pageInfo.amountOfArticles = articles?.count ?? 0
            
            if error == nil {
                if let articles = articles {
                    let currentPage = self.pageInfo.page
                    self.articles.append(articles[currentPage])
                    self.pageInfo.page += 1
                }
            }
            
            self.shouldReload?()
        })
    }
}
