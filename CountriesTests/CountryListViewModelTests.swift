//
//  CountryListViewModelTests.swift
//  CountriesTests
//
//  Created by Christopher Endress on 7/19/25.
//

import XCTest
import Combine
@testable import Countries

// A fake service that immediately returns stub data
private final class MockCountryService: CountryServiceProtocol {
    let stub: [Country]
    
    init(_ stub: [Country]) { self.stub = stub }
    
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        Just(stub)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class CountryListViewModelTests: XCTestCase {
    var viewModel: CountryListViewModel!
    var cancellables = Set<AnyCancellable>()
    
    @MainActor
    override func setUp() {
        super.setUp()
        // Stub data matching the Country model
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
    
    @MainActor
    func testEmptySearchShowsAll() {
        let expectation = expectation(description: "filtered update")
        viewModel.$filtered
            .sink { countries in
                XCTAssertEqual(countries.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor
    func testFilteringByName() {
        let expectation = expectation(description: "filtered update")
        viewModel.$filtered
            .dropFirst()
            .sink { countries in
                XCTAssertEqual(countries.map { $0.code }, ["UY"])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "uru"
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor
    func testFilteringByCapital() {
        let expectation = expectation(description: "filtered update")
        viewModel.$filtered
            .dropFirst()
            .sink { countries in
                XCTAssertEqual(countries.map { $0.code }, ["US"])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "wash"
        wait(for: [expectation], timeout: 1)
    }
}
