//
//  ViewController.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func read(_ sender: UIButton) {
        print("****** Button pressed")
        let x = DownloadService(delegate: self)
        x.startDownload(of: .list, from: EmployeeList.fullList.rawValue)
    }
    
}

extension ViewController: DownloadDelegate {
    
}
