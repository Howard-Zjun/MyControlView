//
//  PixelPickerView.swift
//  ControlShow
//
//  Created by Howard-Zjun on 2023/8/5.
//

import UIKit
import MyBaseExtension

class PixelLabel: UILabel {
    
    var isSelected: Bool = false
}

class PixelPickerView: UIScrollView {

    var x: Int {
        didSet {
            reloadItemLabs()
            updateViewBaseOn(itemLab: itemLabs[0])
        }
    }
    
    var y: Int {
        didSet {
            reloadItemLabs()
            updateViewBaseOn(itemLab: itemLabs[0])
        }
    }
    
    var space: CGFloat = 3 {
        didSet {
            reloadItemLabs()
            updateViewBaseOn(itemLab: itemLabs[0])
        }
    }
    
    var itemWidth: CGFloat = 25
    
    // MARK: - view
    lazy var contentView: UIView = {
        let width: CGFloat = CGFloat(x) * itemWidth + CGFloat(x + 1) * space
        let height: CGFloat = CGFloat(y) * itemWidth + CGFloat(y + 1) * space
        let contentView = UIView(frame: .init(x: 0, y: (self.kheight - kheight) * 0.5, width: kwidth, height: kheight))
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    var itemLabs: [PixelLabel] = []
    
    // MARK: - life time
    init(frame: CGRect, x: Int, y: Int) {
        self.x = x
        self.y = y
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
        minimumZoomScale = 1
        let shortSide = min(kwidth, kheight)
        maximumZoomScale = (shortSide - 2 * space) / (itemWidth * 1.5)
        delegate = self
        contentSize = contentView.frame.size
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        addSubview(contentView)
        reloadItemLabs()
    }
    
    // MARK: - target
    @objc func touchItemLab(_ gesture: UITapGestureRecognizer) {
        let itemLab = gesture.view as! PixelLabel
        itemLab.isSelected = !itemLab.isSelected
        updateViewBaseOn(itemLab: itemLab)
    }
    
    // MARK: - 原子方法
    func updateViewBaseOn(itemLab: PixelLabel) {
        var rowSelectArr = [Int](repeating: 0, count: y) // 行选中统计
        var colSelectArr = [Int](repeating: 0, count: x) // 列选中统计
        for (tempIndex, itemLab) in itemLabs.enumerated() {
            let indexX = tempIndex % x
            let indexY = tempIndex / x
            if itemLab.isSelected {
                rowSelectArr[indexY] = 1
                colSelectArr[indexX] = 1
            }
        }
        for tempIndex in 1..<rowSelectArr.count {
            rowSelectArr[tempIndex] += rowSelectArr[tempIndex - 1]
        }
        for tempIndex in 1..<colSelectArr.count {
            colSelectArr[tempIndex] += colSelectArr[tempIndex - 1]
        }
        
        let width: CGFloat = CGFloat(colSelectArr[colSelectArr.count - 1]) * itemWidth * 1.5 + CGFloat(x - colSelectArr[colSelectArr.count - 1]) * itemWidth + CGFloat(x + 1) * space
        let height: CGFloat = CGFloat(rowSelectArr[rowSelectArr.count - 1]) * itemWidth * 1.5 + CGFloat(y - rowSelectArr[rowSelectArr.count - 1]) * itemWidth + CGFloat(y + 1) * space
        contentView.frame = .init(x: 0, y: 0, width: width * zoomScale, height: height * zoomScale)
        contentSize = contentView.frame.size
        
        var minX = space, minY = space
        for tempY in 0..<y {
            let rowExistSelect: Bool = tempY == 0 ? rowSelectArr[tempY] > 0 : (rowSelectArr[tempY] - rowSelectArr[tempY - 1]) > 0
            for tempX in 0..<x {
                let itemLab = itemLabs[tempY * x + tempX]
                let colExistSelect: Bool = tempX == 0 ? colSelectArr[tempX] > 0 : (colSelectArr[tempX] - colSelectArr[tempX - 1]) > 0
                var offsetX = 0.0
                var offSetY = 0.0
                if (colExistSelect && !itemLab.isSelected) {
                    offsetX = (1.5 - 1) * itemWidth * 0.5
                }
                if (rowExistSelect && !itemLab.isSelected) {
                    offSetY = (1.5 - 1) * itemWidth * 0.5
                }
                itemLab.frame = .init(x: minX + offsetX, y: minY + offSetY , width: itemWidth * (itemLab.isSelected ? 1.5 : 1), height: itemWidth * (itemLab.isSelected ? 1.5 : 1))
                
                minX += itemLab.kwidth + 2 * offsetX + space
            }
            minX = space
            if rowExistSelect {
                minY += 1.5 * itemWidth + space
            } else {
                minY += itemWidth + space
            }
        }
    }
    
    func reloadItemLabs() {
        for itemLab in itemLabs {
            itemLab.removeFromSuperview()
        }
        var itemLabs: [PixelLabel] = []
        var minX = space
        var minY = space
        for tempIndex in 0..<(x * y) {
            let lab = PixelLabel(frame: .init(x: minX, y: minY, width: itemWidth, height: itemWidth))
            lab.layer.cornerRadius = 3
            lab.backgroundColor = .init(hex: 0x262626)
            lab.font = .italicSystemFont(ofSize: 14)
            lab.textColor = .init(hex: 0x464646)
            lab.text = "\(tempIndex + 1)"
            lab.textAlignment = .center
            lab.tag = tempIndex
            lab.isUserInteractionEnabled = true
            lab.addGestureRecognizer({
                UITapGestureRecognizer(target: self, action: #selector(touchItemLab(_:)))
            }())
            
            itemLabs.append(lab)
            contentView.addSubview(lab)
            
            if (tempIndex + 1) % x == 0 {
                minX = space
                minY = lab.kmaxY + 3
            } else {
                minX = lab.kmaxX + 3
            }
        }
        self.itemLabs = itemLabs
    }
}

// MARK: - UIScrollViewDelegate
extension PixelPickerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }
}
