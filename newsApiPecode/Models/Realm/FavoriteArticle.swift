//
//  FavoriteArticle.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 17.06.2022.
//

import Foundation
import RealmSwift

class FavoriteArticle: Object {
    @Persisted var title = ""
    @Persisted var articleDescription = ""
    @Persisted var urlToImage = ""
    @Persisted var author: String?
    @Persisted var source = ""
    @Persisted var url = ""
}
