//
//  CountryListViewModel.swift
//  Countries
//
//  Created by Christopher Endress on 7/19/25.
//

import Combine
import Foundation

@MainActor
final class CountryListViewModel {
    // Inputs
    @Published var searchText: String = ""
    
    // Outputs
    @Published private(set) var countries: [Country] = []
    @Published private(set) var filtered: [Country] = []
    @Published private(set) var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let service: CountryServiceProtocol
    
    init(service: CountryServiceProtocol = CountryService()) {
        self.service = service
        bind()
        fetch()
    }
    
    private func bind() {
        // Whenever countries or searchText changes, update filtered
        Publishers
            .CombineLatest($countries, $searchText)
            .map { countries, query in
                guard !query.isEmpty else { return countries }
                return countries.filter {
                    $0.name.localizedCaseInsensitiveContains(query) ||
                    $0.capital.localizedCaseInsensitiveContains(query)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.filtered, on: self)
            .store(in: &cancellables)
    }
    
    private func fetch() {
        service.fetchCountries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] list in
                self?.countries = list
            })
            .store(in: &cancellables)
    }
}
