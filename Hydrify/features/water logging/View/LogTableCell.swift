//
//  LogTableCell.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 28/05/24.
//

import UIKit

class LogTableCell: UITableViewCell {
    static let identifier = "LogTableCell"
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var datelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(datelLabel)
        setUpContraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpContraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 8),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8),
            datelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            datelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 8),
            datelLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor,constant: 8),
        ])
    }
    
    func configureCell(with log: WaterLog) {
        titleLabel.text = "\(log.quantity)"
        subTitleLabel.text = log.unit
        datelLabel.text = "\(log.date ?? Date())"
        
    }
}
