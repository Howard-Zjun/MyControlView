//
//  HorizontalPickerView.swift
//  ControlShow
//
//  Created by Howard-Zjun on 2023/8/5.
//

import UIKit

class HorizontalPickerView: UIScrollView {
    
    var index: Int = 0

    var items: [String]

    // MARK: - view
    lazy var contentView: UIView = {
        let contentView = UIView(frame: .init(x: 0, y: 0, width: CGFloat(items.count) * 30 + CGFloat(items.count - 1) * 4 + (kwidth - 30), height: kheight))
        return contentView
    }()

    lazy var itemLabs: [UILabel] = {
        var itemLabs: [UILabel] = []
        var minX = (kwidth - 30) * 0.5
        for item in items {
            let lab = UILabel(frame: .init(x: minX, y: (contentView.kheight - 30) * 0.5, width: 30, height: 30))
            lab.font = .italicSystemFont(ofSize: 14)
            lab.textColor = .init(hex: 0xE0E0E0)
            lab.text = item
            lab.textAlignment = .center

            itemLabs.append(lab)

            minX = lab.kmaxX + 4
        }
        return itemLabs
    }()

    // MARK: - life time
    init(frame: CGRect, items: [String]) {
        self.items = items;
        super.init(frame: frame)
        configUI()
        index = 0
        updateLabAlphaByIndex()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - config
    func configUI() {
        layer.cornerRadius = 4
        backgroundColor = UIColor(hex: 0x171717)
        delegate = self
        contentSize = contentView.bounds.size
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        addSubview(contentView)
        for itemLab in itemLabs {
            contentView.addSubview(itemLab)
        }
    }

    // MARK: - 原子方法
    /// 更新标签的透明度
    func updateLabAlphaByIndex() {
        for (tempIndex, itemLab) in itemLabs.enumerated() {
            if index - tempIndex == 0 {
                itemLab.backgroundColor = .init(hex: 0x2E2E2E)
                itemLab.alpha = 1
            } else {
                itemLab.backgroundColor = .clear
                if index - tempIndex >= 2 || index - tempIndex <= -2 {
                    itemLab.alpha = 0.2
                } else if index - tempIndex == 1 ||  index - tempIndex == -1 {
                    itemLab.alpha = 0.5
                }
            }
        }
    }
    
    func updateView(items: [String]) {
        self.items = items
        for itemLab in itemLabs {
            itemLab.removeFromSuperview()
        }
        contentView.frame = .init(x: 0, y: 0, width: CGFloat(items.count) * 30 + CGFloat(items.count - 1) * 4 + (kwidth - 30), height: kheight)
        contentSize = contentView.bounds.size
        
        var itemLabs: [UILabel] = []
        var minX = (kwidth - 30) * 0.5
        for item in items {
            let lab = UILabel(frame: .init(x: minX, y: (contentView.kheight - 30) * 0.5, width: 30, height: 30))
            lab.font = .italicSystemFont(ofSize: 14)
            lab.textColor = .init(hex: 0xE0E0E0)
            lab.text = item
            lab.textAlignment = .center

            itemLabs.append(lab)
            contentView.addSubview(lab)
            
            minX = lab.kmaxX + 4
        }
        self.itemLabs = itemLabs
        
        index = 0
        updateLabAlphaByIndex()
        updateViewAfterScroll()
    }
    
    func updateViewAfterScroll() {
        let itemLab = itemLabs[index]
        delegate = nil
        setContentOffset(.init(x: itemLab.kminX - (kwidth - itemLab.kwidth) * 0.5, y: 0), animated: true)
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            weakSelf?.delegate = weakSelf
        })
    }
}

// MARK: - UIScrollViewDelegate
extension HorizontalPickerView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let midX: CGFloat = scrollView.contentOffset.x + kwidth * 0.5
        var isExist = false // 是否在label的范围内
        var nearIndex = 0
        for (tempIndex, itemLab) in itemLabs.enumerated() {
            if CGRectContainsPoint(itemLab.frame, .init(x: midX, y: contentView.kheight * 0.5)) {
                index = tempIndex
                isExist = true
                break
            } else if itemLab.kmaxX < midX {
                nearIndex = tempIndex
            }
        }
        if nearIndex == itemLabs.count {
            nearIndex = itemLabs.count - 1
        }
        if !isExist {
            index = nearIndex
        }
        updateLabAlphaByIndex()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateViewAfterScroll()
    }
}


