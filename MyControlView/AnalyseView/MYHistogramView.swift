//
//  MYHistogramView.swift
//  MyControlView
//
//  Created by Howard-Zjun on 2024/10/28.
//

import UIKit

class MYHistogramView: UIView {

    let baseScore: Int
    
    let topScore: Int
    
    let spaceCount: Int
    
    let scores: [CGFloat]
    
    let statisticsStrategy: [ScoreStatistics] = [AverageScoreStatistics(), TopScoreStatistics(), LowestScoreStatistics()]
    
    let statisticsSpace: CGFloat = 10
    
    // MARK: - view
    lazy var spaceLabs: [UILabel] = {
        var spaceLabs: [UILabel] = []
        let scoreSpace = CGFloat(topScore - baseScore) / CGFloat(spaceCount - 1)
        let baseY: CGFloat = 10
        let itemHeight = (kheight - 30) / CGFloat(spaceCount)
        for index in 0..<spaceCount {
            let lab = UILabel(frame: .init(x: 0, y: baseY + CGFloat(index) * itemHeight, width: 50, height: itemHeight))
            lab.font = .systemFont(ofSize: 15)
            lab.textColor = .black
            lab.text = "\(topScore - Int(CGFloat(index) * scoreSpace))"
            lab.textAlignment = .center
            spaceLabs.append(lab)
        }
        return spaceLabs
    }()
    
    lazy var lineViews: [UIView] = {
        var lineViews: [UIView] = []
        let color = UIColor.black
        for (index, lab) in spaceLabs.enumerated() {
            let view = UIView(frame: .init(x: lab.kmaxX, y: lab.kminY + (lab.kheight - 1) * 0.5, width: kwidth - lab.kmaxX, height: 1))
            if index == spaceLabs.count - 1 {
                view.backgroundColor = color
            } else {
                let shape = CAShapeLayer()
                shape.strokeColor = color.cgColor
                shape.lineWidth = 1
                shape.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
                let path = CGMutablePath()
                path.move(to: .init(x: 0, y: view.kheight * 0.5))
                path.addLine(to: .init(x: view.kwidth, y: view.kheight * 0.5))
                shape.path = path
                view.layer.addSublayer(shape)
            }
            lineViews.append(view)
        }
        return lineViews
    }()
    
    lazy var columnarViews: [UIView] = {
        var columnarViews: [UIView] = []
        let maxScoreY = lineViews[0].kminY
        let minScoreY = lineViews[lineViews.count - 1].kminY
        var itemMaxX = spaceLabs[0].kmaxX + statisticsSpace * 0.5
        let itemWidth = (kwidth - spaceLabs[0].kmaxX - statisticsSpace * CGFloat(statisticsStrategy.count)) / CGFloat(statisticsStrategy.count)
        
        for strategy in statisticsStrategy {
            let score = strategy.result(scores: scores)
            let minY = maxScoreY + (minScoreY - maxScoreY) * (CGFloat(topScore) - score) / CGFloat(topScore - baseScore)
            let view = UIView(frame: .init(x: itemMaxX, y: minY, width: itemWidth, height: minScoreY - minY))
            view.backgroundColor = strategy.columnarColor
            columnarViews.append(view)
            
            itemMaxX = view.kmaxX + statisticsSpace
        }
        return columnarViews
    }()
    
    lazy var scoreLabs: [UILabel] = {
        var scoreLabs: [UILabel] = []
        for (index, columnarView) in columnarViews.enumerated() {
            let lab = UILabel(frame: .init(x: columnarView.kminX, y: columnarView.kminY - 15, width: columnarView.kwidth, height: 15))
            lab.font = .systemFont(ofSize: 15, weight: .medium)
            lab.textColor = .init(hex: 0x4E88F9)
            lab.text = "\(statisticsStrategy[index].result(scores: scores))"
            lab.textAlignment = .center
            scoreLabs.append(lab)
        }
        return scoreLabs
    }()
    
    lazy var statisticsLabs: [UILabel] = {
        var statisticsLabs: [UILabel] = []
        for (index, strategy) in statisticsStrategy.enumerated() {
            let columnarView = columnarViews[index]
            let lab = UILabel(frame: .init(x: columnarView.kminX - statisticsSpace * 0.5, y: lineViews[lineViews.count - 1].kminY, width: columnarView.kwidth + statisticsSpace, height: kheight - lineViews[lineViews.count - 1].kminY))
            lab.font = .systemFont(ofSize: 15)
            lab.textColor = .black
            lab.text = strategy.name
            lab.textAlignment = .center
            statisticsLabs.append(lab)
        }
        return statisticsLabs
    }()
    
    // MARK: - life time
    /// - Parameters:
    ///   - frame: 大小
    ///   - baseScore: 最低分刻度
    ///   - topScore: 最高分刻度
    ///   - spaceCount: 刻度数量
    ///   - scores: 所有分数
    init(frame: CGRect, baseScore: Int, topScore: Int, spaceCount: Int, scores: [CGFloat]) {
        self.baseScore = baseScore
        self.topScore = topScore
        self.spaceCount = spaceCount
        self.scores = scores
        super.init(frame: frame)
        spaceLabs.forEach({ addSubview($0) })
        lineViews.forEach({ addSubview($0) })
        columnarViews.forEach({ addSubview($0) })
        scoreLabs.forEach({ addSubview($0) })
        statisticsLabs.forEach({ addSubview($0) })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
