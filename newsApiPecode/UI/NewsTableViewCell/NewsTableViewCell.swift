//
//  NewsTableViewCell.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Foundation
import UIKit
import SDWebImageSwiftUI

class NewsTableViewCell: UITableViewCell, ReusableCell {
    
    public var favouriteButtonAction: (() -> Void)?
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 3
        label.minimumScaleFactor = 0.4
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var articleDescription: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var source: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.textAlignment = .center
        label.minimumScaleFactor = 0.4
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var favouriteView: UIImageView = {
        let view = UIImageView()
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favouriteButtonPressed))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var author: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.minimumScaleFactor = 0.4
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var articleImageView: UIImageView = {
        let label = UIImageView()
        return label
    }()
    
    func setUpViews() {
        self.addSubview(title)
        title.layout {
            $0.constraint(to: self, by: .top(10))
            $0.centerX.constraint(to: self, by: .centerX(0))
            $0.size(.width(200), .height(60))
        }
        
        self.addSubview(articleDescription)
        articleDescription.layout {
            $0.top.constraint(to: title, by: .bottom(10))
            $0.constraint(to: self, by: .trailing(-20))
            $0.size(.width(110), .height(120))
        }
        
        self.addSubview(articleImageView)
        articleImageView.layout {
            $0.top.constraint(to: title, by: .bottom(10))
            $0.constraint(to: self, by: .leading(10))
            $0.size(.width(200), .height(120))
        }
        
        self.addSubview(author)
        author.layout {
            $0.top.constraint(to: articleImageView, by: .bottom(10))
            $0.constraint(to: self, by: .leading(20))
            $0.size(.width(90), .height(20))
        }
        
        self.addSubview(source)
        source.layout {
            $0.top.constraint(to: author, by: .bottom(20))
            $0.constraint(to: self, by: .leading(10))
            $0.size(.width(90), .height(20))
        }
        
        self.addSubview(favouriteView)
        favouriteView.layout {
            $0.top.constraint(to: self, by: .top(20))
            $0.trailing.constraint(to: self, by: .trailing(-10))
            $0.size(.width(25), .height(25))
        }
        self.selectionStyle = .none
    }
    
    func setFavoriteImage() {
        guard let title = self.title.text else {return}
        
        if FavouriteService.shared.isArticleFavorite(title: self.title.text!) {
            self.favouriteView.image = UIImage(named: "favorite.png")
        }else {
            self.favouriteView.image = UIImage(named: "unfavorite.png")
        }
    }
    
    func setUpInfo(article: Article) {
        title.text = article.title
        source.text = article.source.name
        author.text = article.author
        articleDescription.text = article.description
        
        if let imgUrl = article.urlToImage,
           let url = URL(string: imgUrl) {
            articleImageView.sd_setImage(with: url)
        }
        setFavoriteImage()
    }
    
    func setUpFavoriteInfo(article: FavoriteArticle) {
        title.text = article.title
        source.text = article.source
        author.text = article.author
        articleDescription.text = article.description
        
        if let url = URL(string: article.urlToImage) {
            articleImageView.sd_setImage(with: url)
        }
        setFavoriteImage()
    }
        
        @objc private func favouriteButtonPressed() {
            guard let title = self.title.text else {return}
            
            if  (FavouriteService.shared.isArticleFavorite(title: title)) {
                FavouriteService.shared.removeArticle(titles: title)
            }else {
                FavouriteService.shared.addArticle(title: title)
            }

            favouriteButtonAction?()
            setFavoriteImage()
        }
    }
