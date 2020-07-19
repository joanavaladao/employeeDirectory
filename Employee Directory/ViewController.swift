//
//  ViewController.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var downloadService: DownloadService = {
        return DownloadService(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func read(_ sender: UIButton) {
        print("****** Button pressed")
        downloadService.startDownload(of: .list, from: EmployeeList.timeout.rawValue)
    }
    
}

extension ViewController: DownloadDelegate {
    func savedTemporaryFile(url: URL, downloadType: DownloadType){}
    func errorDownloadingFile(_ error: Error, downloadType: DownloadType){}
    func errorSavingFile(_ error: Error, downloadType: DownloadType){}
}
