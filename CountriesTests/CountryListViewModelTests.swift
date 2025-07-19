//
//  CountryListViewModelTests.swift
//  CountriesTests
//
//  Created by Christopher Endress on 7/19/25.
//

import XCTest
import Combine
@testable import Countries

@MainActor
final class CountryListViewModelTests: XCTestCase {
    private var viewModel: CountryListViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        
        // Stub data
        let stubCountries = [
            Country(
                capital: "Montevideo",
                code: "UY",
                currency: Currency(code: "UYU", name: "Peso", symbol: "$"),
                flag: URL(string: "https://restcountries.eu/data/ury.svg")!,
                language: Language(code: "es", name: "Spanish"),
                name: "Uruguay",
                region: "SA"
            ),
            Country(
                capital: "Washington, D.C.",
                code: "US",
                currency: Currency(code: "USD", name: "Dollar", symbol: "$"),
                flag: URL(string: "https://restcountries.eu/data/usa.svg")!,
                language: Language(code: "en", name: "English"),
                name: "United States of America",
                region: "NA"
            )
        ]
        
        viewModel = CountryListViewModel(service: MockCountryService(stubCountries))
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testEmptySearchShowsAll() {
        let expectation = expectation(description: "filtered emits full list")
        
        viewModel.$filtered
            .dropFirst()
            .first(where: { $0.count == 2 })
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilteringByName() {
        let expectation = expectation(description: "filter by country name")
        
        viewModel.$filtered
            .dropFirst()
            .first(where: { $0.map(\.code) == ["UY"] })
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.searchText = "URU"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilteringByCapital() {
        let expectation = expectation(description: "filter by capital name")
        
        viewModel.$filtered
            .dropFirst()
            .first(where: { $0.map(\.code) == ["US"] })
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.searchText = "wash"
        
        wait(for: [expectation], timeout: 1.0)
    }
}

private final class MockCountryService: CountryServiceProtocol {
    let stub: [Country]
    
    init(_ stub: [Country]) { self.stub = stub }
    
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        Just(stub)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
