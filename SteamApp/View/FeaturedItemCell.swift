//
//  FeaturedItemCell.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import UIKit
import Kingfisher

class FeaturedItemCell: UICollectionViewCell {
    
    static let reusableCellIdetifier = "FeaturedItemCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "icloud.circle")
        imageView.backgroundColor = UIColor.init(red: 14, green: 24, blue: 34)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 40, green: 88, blue: 124)
        
        view.addSubview(mainLabel)
        mainLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return view
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.text = "Placeholder"
        return label
    }()
    
    lazy var originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.text = "200"
        return label
    }()
    
    lazy var finalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        label.text = "100"
        return label
    }()
    
    lazy var discountValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.backgroundColor = UIColor.init(red: 81, green: 105, blue: 41)
        label.textColor = UIColor.init(red: 170, green: 205, blue: 64)
        label.text = " -50% "
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        addSubview(mainView)
        
        mainView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
        
        addSubview(imageView)
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: mainView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func configureView(with item: FeaturedItem) {
        mainLabel.text = item.name
        
        if item.discounted {
            mainView.addSubview(discountValueLabel)
            mainView.addSubview(originalPriceLabel)
            mainView.addSubview(finalPriceLabel)
            discountValueLabel.anchor(top: mainLabel.bottomAnchor, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)

            originalPriceLabel.anchor(top: discountValueLabel.topAnchor, left: discountValueLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

            finalPriceLabel.anchor(top: originalPriceLabel.bottomAnchor, left: originalPriceLabel.leftAnchor, bottom: discountValueLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            discountValueLabel.text = item.discountPercent?.numberForServer
            
            originalPriceLabel.text = item.originalPrice.numberForServer
            
            finalPriceLabel.text = item.finalPrice?.numberForServer
            
        } else {
            mainView.addSubview(originalPriceLabel)

            originalPriceLabel.anchor(top: mainLabel.bottomAnchor, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
            
            originalPriceLabel.text = item.originalPrice.numberForServer
            
            originalPriceLabel.font = UIFont.systemFont(ofSize: 30)
        }
    }
    
}

#if DEBUG
import SwiftUI

struct FeaturedItemCell_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            FeaturedItemCell()
        }
    }
}

#endif
