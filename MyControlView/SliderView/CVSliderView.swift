//
//  CVSliderView.swift
//  ControlShow
//
//  Created by Howard-Zjun on 2023/8/13.
//

import UIKit

public class CVSliderView: UIView {
    
    // MARK: - view
    lazy var scaleView: UIView = {
        let scaleView = UIView(frame: .init(x: 0, y: 0, width: 0, height: kheight))
        scaleView.backgroundColor = UIColor(hex: 0xF0F0F0)
        return scaleView
    }()
    
    lazy var valueLab: UILabel = {
        let valueLab = UILabel(frame: .init(x: 15, y: (kheight - 20) * 0.5, width: 100, height: 20))
        valueLab.font = .italicSystemFont(ofSize: 14)
        valueLab.textColor = .init(hex: 0xB3B3B3)
        valueLab.text = "0%"
        valueLab.textAlignment = .left
        return valueLab
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton(frame: .init(x: kwidth - 15 - 20, y: (kheight - 20) * 0.5, width: 20, height: 20))
        closeBtn.setImage(.init(systemName: "power.circle.fill"), for: .normal)
        closeBtn.tintColor = .blue
        closeBtn.addTarget(self, action: #selector(touchCloseBtn), for: .touchUpInside)
        closeBtn.isSelected = true
        return closeBtn
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView(frame: .init(x: 0, y: 0, width: kwidth, height: kheight))
        coverView.backgroundColor = .init(hex: 0xFFFFFF, a: 0.2)
        coverView.isHidden = true
        return coverView
    }()
    
    // MARK: - life time
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - config
    func configUI() {
        layer.cornerRadius = 4
        backgroundColor = .init(hex: 0x171717)
        addGestureRecognizer({
            UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        }())
        addSubview(scaleView)
        addSubview(valueLab)
        addSubview(coverView)
        addSubview(closeBtn)
    }
    
    // MARK: - target
    @objc func touchCloseBtn() {
        closeBtn.isSelected = !closeBtn.isSelected
        closeBtn.tintColor = closeBtn.isSelected ? .blue : .gray
        if (closeBtn.isSelected) {
            addGestureRecognizer({
                UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
            }())
        } else {
            for gesture in gestureRecognizers ?? [] {
                removeGestureRecognizer(gesture)
            }
        }
        coverView.isHidden = closeBtn.isSelected
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        if sender.state == .began {
        } else if sender.state == .changed {
            var temp = location.x
            if temp > kwidth {
                temp = kwidth
            } else if temp < 0 {
                temp = 0
            }
            scaleView.frame = .init(x: 0, y: 0, width: temp, height: kheight)
            valueLab.text = "\(Int(temp / kwidth * 100))%"
        } else {
            
        }
    }
}
