//
//  EmployeeListCellCollectionViewCell.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-19.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class EmployeeListCell: UICollectionViewCell {
    
    lazy var photoView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "person")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "NAME"
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var teamLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "TEAM"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackLabel: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, teamLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [photoView, stackLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 16.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmployeeListCell {
    func setupView() {
        backgroundColor = .white
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            
            photoView.heightAnchor.constraint(equalToConstant: 139.5),
            photoView.widthAnchor.constraint(equalToConstant: 139.0)
        ])
    }
}

