//
//  Reader.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation

enum EmployeeList: String {
    case fullList = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    case wrongList = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    case emptyList = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
}

enum DownloadType {
    case list
    case fullImage
    case smallImage
}

protocol DownloadDelegate {
    
}

class DownloadService: NSObject {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.valadao.joana.employeeDirectory")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var delegate: DownloadDelegate

    init(delegate: DownloadDelegate) {
        self.delegate = delegate
    }
    
    func startDownload (of type: DownloadType, from path: String) {
        guard let requestURL: URL = URL(string: path) else {
            // TODO: throw an error
            return
        }
        
        let task = session.downloadTask(with: requestURL)
        task.resume()
    }
}

extension DownloadService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("*********************** FINISHED DOWNLOAD")
        print("Session: \(session)")
        print("Task: \(downloadTask)")
        print("Location: \(location)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("*********************** FINISHED DOWNLOAD with error")
        print("Session: \(session)")
        print("Task: \(task)")
        print("Error: \(error?.localizedDescription)")
    }
}
