//
//  WCFunctionListView.swift
//  ControlShow
//
//  Created by Howard-Zjun on 2023/8/9.
//

import UIKit
import MyBaseExtension

class WCFunctionListView: UIView {

    var items: [[ItemModel]] = [
        [
            .init(iconStr: "figure.walk", titleText: "走", isHint: false, detailText: nil, detailIconStr: nil),
            .init(iconStr: "figure.run", titleText: "跑", isHint: false, detailText: nil, detailIconStr: nil)
        ],
        [
            .init(iconStr: "figure.roll", titleText: "推", isHint: true, detailText: nil, detailIconStr: nil),
            .init(iconStr: "figure.american.football", titleText: "扔", isHint: true, detailText: nil, detailIconStr: nil)
        ]
    ]
    
    // MARK: - view
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: bounds, style: .grouped)
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            
        }
        tableView.sectionFooterHeight = 0
        return tableView
    }()
    
    // MARK: - life time
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - config
    func configUI() {
        addSubview(tableView)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WCFunctionListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseId, for: indexPath) as! ItemCell
        cell.itemModel = items[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = self.tableView(tableView, heightForHeaderInSection: section)
        let view = UIView(frame: .init(x: 0, y: 0, width: tableView.kwidth, height: height))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
}

extension WCFunctionListView {
    
    class ItemModel: NSObject {
        
        let iconStr: String
        
        let titleText: String
        
        var isHint: Bool
        
        var detailText: String?
        
        var detailIconStr: String?
        
        init(iconStr: String, titleText: String, isHint: Bool, detailText: String?, detailIconStr: String?) {
            self.iconStr = iconStr
            self.titleText = titleText
            self.isHint = isHint
            self.detailText = detailText
            self.detailIconStr = detailIconStr
        }
    }
    
    class ItemCell: UITableViewCell {
        
        var itemModel: ItemModel! {
            didSet {
                iconImgV.image = .init(systemName: itemModel.iconStr)
                titleLab.text = itemModel.titleText
                hintImgV.isHidden = !itemModel.isHint
            }
        }
        
        static var reuseId: String {
            NSStringFromClass(ItemCell.self)
        }
        
        lazy var iconImgV: UIImageView = {
            let iconImgV = UIImageView(frame: .init(x: 10, y: (contentView.kheight - 30) * 0.5, width: 30, height: 30))
            return iconImgV
        }()
        
        lazy var titleLab: UILabel = {
            let titleLab = UILabel(frame: .init(x: iconImgV.kmaxX + 10, y: (contentView.kheight - 25) * 0.5, width: 200, height: 25))
            titleLab.font = .italicSystemFont(ofSize: 14)
            titleLab.textColor = .black
            titleLab.textAlignment = .left
            return titleLab
        }()
        
        lazy var hintImgV: UIImageView = {
            let hintImgV = UIImageView(frame: .init(x: titleLab.kmaxX, y: (contentView.kheight - 30) * 0.5, width: 30, height: 30))
            hintImgV.image = .init(named: "")
            return hintImgV
        }()
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configUI() {
            contentView.addSubview(iconImgV)
            contentView.addSubview(titleLab)
            contentView.addSubview(hintImgV)
        }
    }
}
