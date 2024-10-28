//
//  ScoreStatistics.swift
//  MyControlView
//
//  Created by Howard-Zjun on 2024/10/28.
//

import Foundation

protocol ScoreStatistics {
    
    var name: String { get }
    
    var columnarColor: UIColor { get }
    
    func result(scores: [CGFloat]) -> CGFloat
    
}

class AverageScoreStatistics: ScoreStatistics {
    
    var name: String {
        "平均分"
    }
    
    var columnarColor: UIColor {
        .init(hex: 0x74BAFB)
    }
    
    func result(scores: [CGFloat]) -> CGFloat {
        let sum = scores.reduce(0) { partialResult, item in
            partialResult + item
        }
        return sum / CGFloat(scores.count)
    }
}

class TopScoreStatistics: ScoreStatistics {
    
    var name: String {
        "最高分"
    }
    
    var columnarColor: UIColor {
        .init(hex: 0x73A0FC)
    }
    
    func result(scores: [CGFloat]) -> CGFloat {
        var ret = scores[0]
        for item in scores {
            if item > ret {
                ret = item
            }
        }
        return ret
    }
}

class LowestScoreStatistics: ScoreStatistics {
    
    var name: String {
        "最低分"
    }
    
    var columnarColor: UIColor {
        .init(hex: 0x7381FC)
    }
    
    func result(scores: [CGFloat]) -> CGFloat {
        var ret = scores[0]
        for item in scores {
            if item < ret {
                ret = item
            }
        }
        return ret
    }
}
