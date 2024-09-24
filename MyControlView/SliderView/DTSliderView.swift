//
//  DTSliderView.swift
//  MyControlView
//
//  Created by Howard-Zjun on 2023/8/13.
//

import UIKit
import MyBaseExtension

/// 双滑块滑条
public class DTSliderView: UIView {

    var minThumbOservation1: NSKeyValueObservation?
    
    var maxThumbObservation2: NSKeyValueObservation?
    
    public var model: DTSliderViewModel {
        didSet {
            let minX1 = (kwidth - thumbWidth) * (model.minThumbValue - model.minValue) / (model.maxValue - model.minValue) - thumbWidth * 0.5
            minThumbV.frame.origin = .init(x: minX1, y: minThumbV.kminY)
            minValueLab.text = .init(format: "%.1f", model.minThumbValue)
            
            let minX2 = (kwidth - thumbWidth) * (model.maxThumbValue - model.minValue) / (model.maxValue - model.minValue) - thumbWidth * 0.5
            maxThumbV.frame.origin = .init(x: minX2, y: maxThumbV.kminY)
            maxValueLab.text = .init(format: "%.1f", model.maxThumbValue)
            
            minThumbOservation1?.invalidate()
            minThumbOservation1 = model.observe(\.minThumbValue, options: .new) { [weak self] model, change in
                guard let self = self else { return }
                let minX1 = (kwidth - thumbWidth) * (model.minThumbValue - model.minValue) / (model.maxValue - model.minValue) - thumbWidth * 0.5
                minThumbV.frame.origin = .init(x: minX1, y: minThumbV.kminY)
                minValueLab.text = .init(format: "%.1f", model.minThumbValue)
            }
            maxThumbObservation2?.invalidate()
            maxThumbObservation2 = model.observe(\.maxThumbValue, options: .new) { [weak self] model, change in
                guard let self = self else { return }
                let minX2 = (kwidth - thumbWidth) * (model.maxThumbValue - model.minValue) / (model.maxValue - model.minValue) - thumbWidth * 0.5
                maxThumbV.frame.origin = .init(x: minX2, y: maxThumbV.kminY)
                maxValueLab.text = .init(format: "%.1f", model.maxThumbValue)
            }
        }
    }
    
    var minBeginPoint: CGPoint?
    
    var maxBeginPoint: CGPoint?
    
    var thumbWidth: CGFloat = 20
    
    // MARK: - view
    lazy var minValueLab: UILabel = {
        let minValueLab = UILabel(frame: .init(x: 0, y: (kheight - 45) * 0.5, width: kwidth * 0.5, height: 20))
        minValueLab.font = .italicSystemFont(ofSize: 14)
        minValueLab.textColor = .init(hex: 0xD2D2D2)
        minValueLab.textAlignment = .left
        return minValueLab
    }()
    
    lazy var maxValueLab: UILabel = {
        let maxValueLab = UILabel(frame: .init(x: kwidth * 0.5, y: (kheight - 45) * 0.5, width: kwidth * 0.5, height: 20))
        maxValueLab.font = .italicSystemFont(ofSize: 14)
        maxValueLab.textColor = .init(hex: 0xD2D2D2)
        maxValueLab.textAlignment = .right
        return maxValueLab
    }()
    
    lazy var baseV: UIView = {
        let baseV = UIView(frame: .init(x: 0, y: minValueLab.kmaxY + 5 + (thumbWidth - 5) * 0.5, width: kwidth, height: 5))
        baseV.layer.cornerRadius = baseV.kheight * 0.5
        baseV.backgroundColor = .init(hex: 0xD2D2D2)
        return baseV
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView(frame: .init(x: baseV.kminX, y: baseV.kminY, width: 0, height: baseV.kheight))
        coverView.layer.cornerRadius = coverView.kheight * 0.5
        coverView.backgroundColor = .init(hex: 0x46AA5F)
        return coverView
    }()
    
    lazy var minThumbV: UIView = {
        let minThumbV = UIView(frame: .init(x: -thumbWidth * 0.5, y: minValueLab.kmaxY + 5, width: thumbWidth, height: thumbWidth))
        minThumbV.layer.cornerRadius = minThumbV.kheight * 0.5
        minThumbV.layer.borderWidth = 1
        minThumbV.layer.borderColor = UIColor.white.cgColor
        minThumbV.backgroundColor = .init(hex: 0x46AA5F)
        minThumbV.addGestureRecognizer({
            UIPanGestureRecognizer(target: self, action: #selector(panMinThumbV(_:)))
        }())
        return minThumbV
    }()
    
    lazy var maxThumbV: UIView = {
        let maxThumbV = UIView(frame: .init(x: kwidth - thumbWidth * 0.5, y: minValueLab.kmaxY + 5, width: thumbWidth, height: thumbWidth))
        maxThumbV.layer.cornerRadius = maxThumbV.kheight * 0.5
        maxThumbV.layer.borderWidth = 1
        maxThumbV.layer.borderColor = UIColor.white.cgColor
        maxThumbV.backgroundColor = .init(hex: 0x46AA5F)
        maxThumbV.addGestureRecognizer({
            UIPanGestureRecognizer(target: self, action: #selector(panMaxThumbV(_:)))
        }())
        return maxThumbV
    }()
    
    // MARK: - life time
    init(frame: CGRect, model: DTSliderViewModel) {
        self.model = model
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - config
    func configUI() {
        layer.cornerRadius = 5
        backgroundColor = .init(hex: 0x171717)
        addSubview(minValueLab)
        addSubview(maxValueLab)
        addSubview(baseV)
        addSubview(coverView)
        addSubview(minThumbV)
        addSubview(maxThumbV)
    }
    
    // MARK: - target
    @objc func panMinThumbV(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        if sender.state == .began {
            minBeginPoint = sender.location(in: minThumbV)
        } else if sender.state == .changed {
            guard let minBeginPoint = minBeginPoint else {
                return
            }
            var minX: CGFloat = location.x - minBeginPoint.x
            if minX > maxThumbV.kminX - thumbWidth {
                minX = maxThumbV.kminX - thumbWidth
            } else if minX < -thumbWidth * 0.5 {
                minX = -thumbWidth * 0.5
            }
            model.minThumbValue = (minX + thumbWidth - thumbWidth * 0.5) / (kwidth - thumbWidth) * (model.maxValue - model.minValue) + model.minValue
        } else {
            minBeginPoint = nil
        }
    }
    
    @objc func panMaxThumbV(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        if sender.state == .began {
            maxBeginPoint = sender.location(in: maxThumbV)
        } else if sender.state == .changed {
            guard let maxBeginPoint = maxBeginPoint else {
                return
            }
            var minX: CGFloat = location.x - maxBeginPoint.x
            if minX < minThumbV.kmaxX {
                minX = minThumbV.kmaxX
            } else if minX > kwidth - thumbWidth * 0.5 {
                minX = kwidth - thumbWidth * 0.5
            }
            model.maxThumbValue = (minX - thumbWidth * 0.5) / (kwidth - thumbWidth) * (model.maxValue - model.minValue) + model.minValue
        } else {
            maxBeginPoint = nil
        }
    }
}

public class DTSliderViewModel: NSObject {
 
    public let name: String
    
    public let minValue: CGFloat
    
    public let maxValue: CGFloat
    
    @objc dynamic var minThumbValue: CGFloat {
        didSet {
            if minThumbValue < minValue {
                minThumbValue = minValue
            } else if minThumbValue > maxValue {
                minThumbValue = maxValue
            }
        }
    }
    
    @objc dynamic var maxThumbValue: CGFloat {
        didSet {
            if maxThumbValue > maxValue {
                maxThumbValue = maxValue
            } else if maxThumbValue < minValue {
                maxThumbValue = minValue
            }
        }
    }
    
    public init?(name: String, minValue: CGFloat, maxValue: CGFloat, minThumbValue: CGFloat, maxThumbValue: CGFloat) {
        guard minValue <= maxValue else {
            print("\(NSStringFromClass(Self.self)) \(#function) minValue: \(minValue) > maxValue: \(maxValue) 错误")
            return nil
        }
        guard minThumbValue <= maxThumbValue else {
            print("\(NSStringFromClass(Self.self)) \(#function) minThumbValue: \(minThumbValue) > maxThumbValue: \(maxThumbValue) 错误")
            return nil
        }
        guard minThumbValue >= minValue else {
            print("\(NSStringFromClass(Self.self)) \(#function) minThumbValue \(minThumbValue) < minValue: \(minValue)")
            return nil
        }
        guard maxThumbValue <= maxValue else {
            print("\(NSStringFromClass(Self.self)) \(#function) maxThumbValue \(maxThumbValue) > maxValue: \(maxValue)")
            return nil
        }
        
        self.name = name
        self.minValue = minValue
        self.maxValue = maxValue
        self.minThumbValue = minThumbValue
        self.maxThumbValue = maxThumbValue
    }
}
