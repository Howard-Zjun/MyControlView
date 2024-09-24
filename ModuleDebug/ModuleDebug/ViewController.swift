//
//  ViewController.swift
//  ModuleDebug
//
//  Created by ios on 2024/9/23.
//

import UIKit
import MyControlView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let slider = CVSliderView(frame: .init(x: 0, y: 100, width: 150, height: 50))
        view.addSubview(slider)
        
        if let model = STSliderViewModel(name: "cx", minValue: 0, maxValue: 100, thumbValue: 50) {
            let stSlider = STSliderView(frame: .init(x: 50, y: 300, width: 200, height: 50))
            stSlider.model = model
            view.addSubview(stSlider)
        }
    }


}

