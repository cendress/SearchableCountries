//
//  Country.swift
//  Countries
//
//  Created by Christopher Endress on 7/19/25.
//

import Foundation

struct Country: Codable {
    let capital: String
    let code: String
    let currency: Currency
    let flag: URL
    let language: Language
    let name: String
    let region: String
}
