//
//  ViewController.swift
//  ModuleDebug
//
//  Created by ios on 2024/9/23.
//

import UIKit
import MyControlView

class ViewController: UIViewController {

    lazy var colorPickerView: MYHSBColorPickerView = {
        let colorPickerView = MYHSBColorPickerView(x: 50, y: 50, width: 200)
        return colorPickerView
    }()
    
    lazy var hueSlider: STSliderView = {
        let hueSlider = STSliderView(frame: .init(x: 50, y: 300, width: 200, height: 70))
        let hueModel = STSliderViewModel(name: "hue", minValue: 0, maxValue: 1, thumbValue: 0)
        hueSlider.model = hueModel
        hueModel?.addObserver(self, forKeyPath: "hue", options: .new, context: nil)
        return hueSlider
    }()
    
    lazy var satSlider: STSliderView = {
        let satSlider = STSliderView(frame: .init(x: 50, y: 500, width: 200, height: 70))
        let satModel = STSliderViewModel(name: "sat", minValue: 0, maxValue: 1, thumbValue: 0)
        satSlider.model = satModel
        satModel?.addObserver(self, forKeyPath: "sat", options: .new, context: nil)
        return satSlider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testColorPickerView()
    }

    func testColorPickerView() {
        view.addSubview(colorPickerView)
        
        view.addSubview(hueSlider)
        
        view.addSubview(satSlider)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "hue" {
            colorPickerView.hue = hueSlider.model.thumbValue
        } else if keyPath == "sat" {
            colorPickerView.sat = satSlider.model.thumbValue
        }
    }
}

