//
//  ReportViewModel.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-23.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation

struct Information {
    var description: String
    var value: Int
}

struct ChartData {
    var title: String
    var data: [Information]
}

class ReportViewModel {
    let reportsData: [ChartData]
    
    init(reportsData: [ChartData]) {
        self.reportsData = reportsData
    }
    
    func numberOfSections() -> Int {
        return reportsData.count
    }
    
    func numberOfRows() -> Int {
        return 1
    }
    
    func getReportData(for index: IndexPath) -> ChartData {
        return reportsData[index.section]
    }
    
    func getHeaderTitle(for section: Int) -> String {
        return reportsData[section].title
    }
}
