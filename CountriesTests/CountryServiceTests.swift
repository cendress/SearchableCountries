//
//  CountryServiceTests.swift
//  CountriesTests
//
//  Created by Christopher Endress on 7/19/25.
//

import Combine
import XCTest
@testable import Countries

class CountryServiceTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var service: CountryServiceProtocol!

    override func setUp() {
        super.setUp()
        service = CountryService()
    }

    func testFetchCountries() {
        let expectation = self.expectation(description: "Fetch countries")
        var fetched: [Country]?
        var fetchError: Error?

        service.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchError = error
                }
                expectation.fulfill()
            }, receiveValue: { countries in
                fetched = countries
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5)
        XCTAssertNil(fetchError)
        XCTAssertEqual(fetched?.count, 249, "Expected 249 countries")
    }
}
