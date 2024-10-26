//
//  STSliderView.swift
//  MyControlView
//
//  Created by ios on 2024/9/24.
//

import UIKit
import MyBaseExtension

/// 单滑块滑条
public class STSliderView: UIView {

    var thumbObservation: NSKeyValueObservation?
    
    let thumbWidth: CGFloat = 20
    
    public var model: STSliderViewModel! {
        didSet {
            nameLab.text = model.name
            updateView(value: model.thumbValue, minValue: model.minValue, maxValue: model.maxValue)
            
            thumbObservation?.invalidate()
            thumbObservation = model.observe(\.thumbValue, options: .new, changeHandler: { [weak self] model, change in
                guard let self = self else { return }
                updateView(value: model.thumbValue, minValue: model.minValue, maxValue: model.maxValue)
            })
        }
    }
    
    var beginPoint: CGPoint?
    
    // MARK: - view
    lazy var baseV: UIView = {
        let baseV = UIView(frame: .init(x: thumbWidth * 0.5, y: (kheight - 5) * 0.5, width: kwidth - thumbWidth, height: 5))
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
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel(frame: .init(x: 10, y: baseV.kmaxY + 5, width: kwidth - 10, height: 20))
        nameLab.font = .systemFont(ofSize: 14)
        nameLab.textColor = .init(hex: 0xD2D2D2)
        nameLab.textAlignment = .left
        return nameLab
    }()
    
    lazy var valueLab: UILabel = {
        let valueLab = UILabel(frame: .init(x: 0, y: baseV.kminY - 5 - 20, width: 40, height: 20))
        valueLab.font = .systemFont(ofSize: 14)
        valueLab.textColor = .init(hex: 0xD2D2D2)
        valueLab.textAlignment = .center
        return valueLab
    }()
    
    lazy var thumbV: UIView = {
        let thumbV = UIView(frame: .init(x: 0, y: (kheight - thumbWidth) * 0.5, width: thumbWidth, height: thumbWidth))
        thumbV.layer.cornerRadius = thumbV.kheight * 0.5
        thumbV.layer.borderWidth = 1
        thumbV.layer.borderColor = UIColor.white.cgColor
        thumbV.backgroundColor = .init(hex: 0x46AA5F)
        thumbV.addGestureRecognizer({
            UIPanGestureRecognizer(target: self, action: #selector(panThumbV(_:)))
        }())
        return thumbV
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - config
    func configUI() {
        layer.cornerRadius = 5
        backgroundColor = .init(hex: 0x3C3C3C)
        addSubview(baseV)
        addSubview(coverView)
        addSubview(nameLab)
        addSubview(valueLab)
        addSubview(thumbV)
    }
    
    // MARK: - target
    @objc func panThumbV(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        if sender.state == .began {
            beginPoint = sender.location(in: thumbV)
        } else if sender.state == .changed {
            guard let beginPoint else {
                return
            }
            var minX: CGFloat = location.x - beginPoint.x
            if minX > baseV.kmaxX {
                minX = baseV.kmaxX
            } else if minX < baseV.kminX {
                minX = baseV.kminX
            }
            model.thumbValue = (minX - baseV.kminX) / baseV.kwidth * (model.maxValue - model.minValue) + model.minValue
            print("\(NSStringFromClass(Self.self)) \(#function) value: \(model.thumbValue)")
        } else {
            beginPoint = nil
        }
    }
    
    func updateView(value: CGFloat, minValue: CGFloat, maxValue: CGFloat) {
        let minX = baseV.kwidth * (value - minValue) / (maxValue - minValue) + baseV.kminX - thumbWidth * 0.5
        
        thumbV.kminX = minX
        coverView.kwidth = minX + thumbWidth * 0.5 - baseV.kminX
        valueLab.kminX = minX + (thumbWidth - valueLab.kwidth) * 0.5
        valueLab.text = .init(format: "%.1f", value)
    }
}

public class STSliderViewModel: NSObject {
    
    public let name: String
    
    public let minValue: CGFloat
    
    public let maxValue: CGFloat
    
    @objc dynamic public var thumbValue: CGFloat {
        didSet {
            if thumbValue < minValue {
                thumbValue = minValue
            } else if thumbValue > maxValue {
                thumbValue = maxValue
            }
        }
    }
    
    public init?(name: String, minValue: CGFloat, maxValue: CGFloat, thumbValue: CGFloat) {
        guard minValue < maxValue else {
            print("\(NSStringFromClass(Self.self)) \(#function) minValue: \(minValue) > maxValue: \(maxValue) 错误")
            return nil
        }
        guard thumbValue >= minValue else {
            print("\(NSStringFromClass(Self.self)) \(#function) thumbValue \(thumbValue) < minValue: \(minValue)")
            return nil
        }
        guard thumbValue <= maxValue else {
            print("\(NSStringFromClass(Self.self)) \(#function) thumbValue \(thumbValue) > maxValue: \(maxValue)")
            return nil
        }
        
        self.name = name
        self.minValue = minValue
        self.maxValue = maxValue
        self.thumbValue = thumbValue
    }
}
