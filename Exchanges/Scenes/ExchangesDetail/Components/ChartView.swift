//
//  ChartView.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 07/02/2021.
//

import SnapKit
import SwiftChart
import UIKit

class ChartView: UIView {
    var chart: Chart!
    var data:[Rate]

    init(data: [Rate]) {
        self.data = data
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChartView {
    private func setupView() {
        guard  !data.isEmpty else {
            return
        }

        chart = Chart(frame: .zero)

        let data = self.data.map { item -> (x: Int, y:Double) in
            return (self.data.firstIndex(where: { $0.date == item.date }) ?? 0, item.value)
        }
        let series = ChartSeries(data: data)
        series.area = true

        var xLabels:[Double] = []
        let range = data.count > 0 ? data.count - 1 : 0
        for i in 0...range {
            xLabels.append(Double(i))
        }
        chart.xLabels = xLabels
        chart.xLabelsTextAlignment = .center
        chart.labelFont = .boldSystemFont(ofSize: 8)

        chart.xLabelsFormatter = { first, second in
            let rate = self.data[first] as Rate
            let date = rate.date
            let string = Calendar.current.getShortStringFromDate(date: date)
            print(string)
            return string
        }

        chart.add(series)

        addSubview(chart)

        chart.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
