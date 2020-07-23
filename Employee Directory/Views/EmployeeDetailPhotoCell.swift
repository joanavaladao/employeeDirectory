//
//  EmployeeDetailPhotoCell.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-22.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class EmployeeDetailPhotoCell: UITableViewCell {

    lazy var photoImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "person")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmployeeDetailPhotoCell {
    func setupCell() {
        addSubview(photoImage)
        
        NSLayoutConstraint.activate([
            photoImage.heightAnchor.constraint(equalToConstant: 250.0),
            photoImage.widthAnchor.constraint(equalToConstant: 250.0),
            
            photoImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32.0),
            photoImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 32.0),
            photoImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 4.0),
            photoImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 4.0)
        ])
    }
}

