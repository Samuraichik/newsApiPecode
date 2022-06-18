//
//  FiltersViewModel.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 17.06.2022.
//

import Foundation
import RealmSwift

private struct Defaults {
    static let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    static let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz",
                            "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma",
                            "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk",
                            "th", "tr", "tw", "ua", "us", "ve", "za"]
    static let sources = ["BBC News", "The New York Times", "CNN", "Washington Post", "CNBC", "TIME", "Euronews", "The Washington Times"]
}

enum PickerState {
    case source
    case country
    case category
}


protocol FiltersViewModel {
    var selectedParameters: SelectedParameters? { get set }
    
    func setPickerState(state: PickerState)
    func getPickerState(row: Int) -> String
    func getArrCount() -> Int
    func acceptButtonDidTapped () -> SelectedParameters?
}

class FiltersViewModelImpl: FiltersViewModel {
    
    var selectedParameters: SelectedParameters?
    
    private var sourceSelected: String?
    private var countrySelected: String?
    private  var categorySelected: String?
    private var currentPickerState: PickerState?
    
    private let categories = Defaults.categories
    private let country = Defaults.countries
    private let source = Defaults.sources
    
    func getPickerState(row: Int ) -> String {
        switch currentPickerState {
        case .source:
            self.sourceSelected = source[row]
            return source[row]
        case .category:
            self.categorySelected = categories[row]
            return categories[row]
        case .country:
            self.countrySelected = country[row]
            return country[row]
        case .none:
            return ""
        }
    }
    
    func setPickerState(state: PickerState) {
        self.currentPickerState = state
    }
    
    func getArrCount() -> Int {
        switch currentPickerState {
        case .source:
            return source.count
        case .category:
            return categories.count
        case .country:
            return country.count
        default:
            return 0
        }
    }
    
    func acceptButtonDidTapped () -> SelectedParameters? {
        selectedParameters?.source = self.sourceSelected
        selectedParameters?.category = self.categorySelected
        selectedParameters?.country = self.countrySelected

        if let selected = self.selectedParameters {
            return selected
        }
        return nil
    }
}
