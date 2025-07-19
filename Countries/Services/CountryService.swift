//
//  CountryService.swift
//  Countries
//
//  Created by Christopher Endress on 7/19/25.
//

import Combine
import Foundation

protocol CountryServiceProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error>
}

final class CountryService: CountryServiceProtocol {
    private let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json")!
    
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
