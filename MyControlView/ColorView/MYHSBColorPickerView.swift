//
//  MYHSBColorPickerView.swift
//  MyControlView
//
//  Created by ios on 2024/10/24.
//

import UIKit
import MyBaseExtension

public class MYHSBColorPickerView: UIImageView {

    var hueObservation: NSKeyValueObservation?
    
    var satObservation: NSKeyValueObservation?
    
    @objc public var model: MYHSBColorPickerViewModel! {
        didSet {
            hueObservation?.invalidate()
            satObservation?.invalidate()
            
            hueObservation = model.observe(\.hue, options: .new, changeHandler: { [weak self] model, change in
                guard let self = self else { return }
                updateByValueChange()
            })
            satObservation = model.observe(\.sat, options: .new, changeHandler: { [weak self] model, change in
                guard let self = self else { return }
                updateByValueChange()
            })
        }
    }
    
    /// 半径
    var r: CGFloat {
        kwidth * 0.5
    }
    
    var bPoint: CGPoint {
        .init(x: kwidth, y: kheight * 0.5)
    }
    
    /// 中心点
    var cPoint: CGPoint {
        .init(x: kwidth * 0.5, y: kheight * 0.5)
    }
    
    // MARK: - view
    lazy var panView: UIView = {
        let panView = UIView(frame: .init(x: (kwidth - 30) * 0.5, y: (kheight - 30) * 0.5, width: 30, height: 30))
        panView.layer.cornerRadius = 15
        panView.layer.borderWidth = 3
        panView.layer.borderColor = UIColor.white.cgColor
        panView.backgroundColor = .white
        return panView
    }()
    
    // MARK: - life time
    public init(x: CGFloat, y: CGFloat, width: CGFloat) {
        super.init(frame: .init(x: x, y: y, width: width, height: width))
        isUserInteractionEnabled = true
        image = .init(named: "hsb")
        
        addSubview(panView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(updateByPanGesture(_:)))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        hueObservation?.invalidate()
        satObservation?.invalidate()
    }
    
    // MARK: - target
    @objc func updateByPanGesture(_ target: UILongPressGestureRecognizer) {
        // 触摸点
        var tPoint = target.location(in: self)
        // 出发点
        let bPoint = bPoint
        // 中心
        let cPoint = cPoint
        
        var tcWidth = distance(point1: tPoint, point2: cPoint)
        let r = r

        if tcWidth > r { // 超出色盘范围
            if tPoint.y == cPoint.y { // 与中心点统一水平
                if tPoint.x < 0 {
                    tPoint.x = 0
                } else {
                    tPoint.x = kwidth
                }
            } else if tPoint.y == cPoint.y { // 与中心点统一垂直
                if tPoint.y < 0 {
                    tPoint.y = 0
                } else {
                    tPoint.y = kheight
                }
            } else {
                // t，c 水平距离
                var tcx = r / tcWidth * abs(tPoint.x - cPoint.x)
                var tcy = r / tcWidth * abs(tPoint.y - cPoint.y)
                
                if tcx < 0 {
                    tcx = 0
                } else if tcx > r {
                    tcx = r
                }
                
                if tcy < 0 {
                    tcy = 0
                } else if tcy > r {
                    tcy = r
                }
                
                if tPoint.x < cPoint.x {
                    if tPoint.y < cPoint.y { // 左上
                        tPoint = .init(x: cPoint.x - tcx, y: cPoint.y - tcy)
                    } else if tPoint.y > cPoint.y { // 左下
                        tPoint = .init(x: cPoint.x - tcx, y: cPoint.y + tcy)
                    }
                } else {
                    if tPoint.y < cPoint.y { // 右上
                        tPoint = .init(x: cPoint.x + tcx, y: cPoint.y - tcy)
                    } else if tPoint.y > cPoint.y { // 右下
                        tPoint = .init(x: cPoint.x + tcx, y: cPoint.y + tcy)
                    }
                }
            }
            // 修正点位后，也修正距离
            tcWidth = distance(point1: tPoint, point2: cPoint)
        }
        
        var radian = abs(atan((tPoint.y - cPoint.y) / (tPoint.x - cPoint.x)) - atan((bPoint.y - cPoint.y) / (bPoint.x - cPoint.x)))

        if tPoint.x < cPoint.x {
            if tPoint.y < cPoint.y { // 左上
                radian = CGFloat.pi - radian
            } else if tPoint.y > cPoint.y { // 左下
                radian = CGFloat.pi + radian
            }
        } else {
            if tPoint.y < cPoint.y { // 右上
            } else if tPoint.y > cPoint.y { // 右下
                radian = CGFloat.pi * 2 - radian
            }
        }
        
        model.setValue(tcWidth / r, forKey: "sat")
        model.setValue(radian / (CGFloat.pi * 2), forKey: "hue")
        
        print("\(NSStringFromClass(Self.self)) \(#function) x: \(tPoint.x) y: \(tPoint.y) sat: \(model.sat) hue: \(model.hue)")

        panView.center = .init(x: tPoint.x, y: tPoint.y)
        updateColor()
        
//        let state = target.state
//
//        if state == .began {
//            
//        } else if state == .changed {
//            
//        } else {
//            
//        }
    }
    
    private func updateByValueChange() {
        let r = r
        let cPoint = cPoint
        let tcWidth = r * model.sat
        let angle = model.hue * 360
        let tcy = sin(angle) * tcWidth
        let tcx = cos(angle) * tcWidth
        
        print("\(NSStringFromClass(Self.self)) \(#function) sat: \(model.sat) hue: \(model.hue)")

        if model.hue <= 0.25 {
            panView.center = .init(x: cPoint.x + tcx, y: r - tcy)
        } else if model.hue <= 0.5 {
            panView.center = .init(x: r - tcx, y: r - tcy)
        } else if model.hue <= 0.75 {
            panView.center = .init(x: r - tcx, y: cPoint.y + tcy)
        } else {
            panView.center = .init(x: cPoint.x + tcx, y: cPoint.y + tcy)
        }
        
        updateColor()
    }
    
    private func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
    
    private func updateColor() {
        panView.backgroundColor = .init(hue: model.hue, saturation: model.sat, brightness: 1, alpha: 1)
    }
}

public class MYHSBColorPickerViewModel: NSObject {
    
    /// 色相
    @objc dynamic public var hue: CGFloat {
        didSet {
            if hue < 0 {
                hue = 0
            } else if hue > 1 {
                hue = 1
            }
        }
    }
    
    /// 饱和度
    @objc dynamic public var sat: CGFloat {
        didSet {
            if sat < 0 {
                sat = 0
            } else if sat > 1 {
                sat = 1
            }
        }
    }
    
    public init(hue: CGFloat, sat: CGFloat) {
        if hue < 0 {
            self.hue = 0
        } else if hue > 1 {
            self.hue = 1
        } else {
            self.hue = hue
        }
        
        if sat < 0 {
            self.sat = 0
        } else if sat > 1 {
            self.sat = 1
        } else {
            self.sat = sat
        }
    }
}
