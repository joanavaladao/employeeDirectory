//
//  ReportViewCell.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-23.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit
import Charts

class ReportViewCell: UITableViewCell {

    lazy var pieChart: PieChartView = {
        let chart = PieChartView(frame: .zero)
//        chart.delegate = self
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellData(for data: ChartData) {
//        pieChart.chartDescription?.text = data.title
        var numberOfEntries = [PieChartDataEntry]()
        
        for item in data.data {
            if item.value > 0 {
                let entry = PieChartDataEntry(value: Double(item.value))
                entry.label = item.description
                numberOfEntries.append(entry)
            }
        }
        
        let dataSet = PieChartDataSet(entries: numberOfEntries, label: nil)
        let chartData = PieChartData(dataSet: dataSet)
        
        let colors = [UIColor(named: "Color1") ?? UIColor.blue,
                      UIColor(named: "Color2") ?? UIColor.systemPink,
                      UIColor(named: "Color3") ?? UIColor.darkGray,
                      UIColor(named: "Color4") ?? UIColor.red]
        dataSet.colors = colors
        pieChart.data = chartData
    }
}

private extension ReportViewCell {
    func setupCell() {
        addSubview(pieChart)
        
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pieChart.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            pieChart.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ReportViewCell: ChartViewDelegate {
    
}
