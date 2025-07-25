//
//  CountryCell.swift
//  Countries
//
//  Created by Christopher Endress on 7/19/25.
//

import UIKit

final class CountryCell: UITableViewCell {
    static let reuseID = "CountryCell"
    
    //MARK: - UI setup
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(topLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(bottomLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            topLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: codeLabel.leadingAnchor, constant: 4),
            
            codeLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            codeLabel.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor),
            codeLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            bottomLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
    
    // MARK: - Configuration
    
    func configure(with country: Country) {
        topLabel.text = "\(country.name), \(country.region)"
        codeLabel.text = country.code
        bottomLabel.text = country.capital
    }
}
