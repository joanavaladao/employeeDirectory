//
//  EmployeeDetailCell.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-22.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class EmployeeDetailCell: UITableViewCell {

    lazy var iconImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "person")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "INFO"
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImage, infoLabel])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 32.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmployeeDetailCell {
    func setupCell() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            iconImage.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            infoLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
