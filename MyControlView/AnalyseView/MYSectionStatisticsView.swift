//
//  MYSectionStatisticsView.swift
//  MyControlView
//
//  Created by ios on 2024/10/29.
//

import UIKit

/// 区间统计图
class MYSectionStatisticsView: UIView {

    let sections: [SectionModel]

    let sectionDict: [SectionModel : [MYScoreModel]]
    
    // MARK: - view
    lazy var spaceLabs: [UILabel] = {
        var spaceLabs: [UILabel] = []
        let itemHeight = kheight / CGFloat(sections.count)
        var minY: CGFloat = 0
        for division in sections {
            let lab = UILabel(frame: .init(x: 0, y: minY, width: 100, height: itemHeight))
            lab.font = .systemFont(ofSize: 15)
            lab.textColor = .black
            lab.text = division.name
            lab.textAlignment = .left
            spaceLabs.append(lab)
            
            minY = lab.kmaxY
        }
        return spaceLabs
    }()
    
    lazy var scaleViews: [UIView] = {
        var maxCount = 1
        for arr in sectionDict.values {
            maxCount = max(maxCount, arr.count)
        }
        var scaleViews: [UIView] = []
        let maxWidth  = (kwidth - spaceLabs[0].kmaxX) * 2 / 3
        for (index, division) in sections.enumerated() {
            let spaceLab = spaceLabs[index]
            let count = sectionDict[division]?.count ?? 0
            let scale = CGFloat(count) / CGFloat(maxCount)
            let width = count == 0 ? 10 : maxWidth * scale
            let view = UIView(frame: .init(x: spaceLab.kmaxX, y: spaceLab.kminY + (spaceLab.kheight - 10) * 0.5, width: width, height: 10))
            view.backgroundColor = division.color
            view.layer.cornerRadius = 5
            scaleViews.append(view)
        }
        return scaleViews
    }()
    
    lazy var countLabs: [UILabel] = {
        var countLabs: [UILabel] = []
        for (index, division) in sections.enumerated() {
            let scaleView = scaleViews[index]
            let count = sectionDict[division]?.count ?? 0
            let text = "\(count)人"
            let textWidth = (text as NSString).size(withAttributes: [.font : UIFont.systemFont(ofSize: 15)]).width + 10
            let lab = UILabel(frame: .init(x: scaleView.kmaxX, y: scaleView.kminY + (scaleView.kheight - 20) * 0.5, width: textWidth, height: 20))
            lab.font = .systemFont(ofSize: 15)
            lab.textColor = .black
            lab.text = text
            lab.textAlignment = .center
            countLabs.append(lab)
        }
        return countLabs
    }()
    
    // MARK: - view
    init(frame: CGRect, models: [MYScoreModel]) {
        var divisions: [SectionModel] = []
        if let item = SectionModel(minScore: 36, maxScore: nil, color: .init(hex: 0x797EFF)) {
            divisions.append(item)
        }
        if let item = SectionModel(minScore: 32, maxScore: 36, color: .init(hex: 0x4683F9)) {
            divisions.append(item)
        }
        if let item = SectionModel(minScore: 28, maxScore: 32, color: .init(hex: 0x4683F9)) {
            divisions.append(item)
        }
        if let item = SectionModel(minScore: 24, maxScore: 28, color: .init(hex: 0x52B6FF)) {
            divisions.append(item)
        }
        if let item = SectionModel(minScore: nil, maxScore: 24, color: .init(hex: 0xFF6A6A)) {
            divisions.append(item)
        }
        self.sections = divisions
        
        var divisionDict: [SectionModel : [MYScoreModel]] = [:]
        for score in models {
            for division in divisions {
                if division.isThisSection(score: score.dscore) {
                    var arr = divisionDict[division]
                    if arr == nil {
                        arr = []
                    }
                    arr?.append(score)
                    divisionDict[division] = arr
                    break
                }
            }
        }
        self.sectionDict = divisionDict
        
        super.init(frame: frame)
        
        spaceLabs.forEach({ addSubview($0)} )
        scaleViews.forEach({ addSubview($0) })
        countLabs.forEach({ addSubview($0) })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MYSectionStatisticsView {
    
    class SectionModel: NSObject {
        
        let maxScore: CGFloat?
        
        let minScore: CGFloat?
        
        let color: UIColor
        
        var name: String {
            if let minScore, let maxScore {
                return "\(minScore)-\(maxScore)分"
            } else if let minScore {
                return "\(minScore)分以上"
            } else if let maxScore {
                return "\(maxScore)分以下"
            } else {
                return ""
            }
        }
        
        init?(minScore: CGFloat?, maxScore: CGFloat?, color: UIColor) {
            if minScore == nil, maxScore == nil {
                return nil
            }
            self.maxScore = maxScore
            self.minScore = minScore
            self.color = color
        }
        
        func isThisSection(score: CGFloat) -> Bool {
            if let minScore, let maxScore {
                if score >= minScore, score <= maxScore {
                    return true
                }
            } else if let minScore {
                if score >= minScore {
                    return true
                }
            } else if let maxScore {
                if score <= maxScore {
                    return true
                }
            }
            return false
        }
    }
}
