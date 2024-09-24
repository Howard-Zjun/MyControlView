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
    }


}

