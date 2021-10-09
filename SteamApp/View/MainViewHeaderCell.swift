//
//  MainViewHeaderCell.swift
//  Pokedex
//
//  Created by Ilya Manny on 26.09.2021.
//

import UIKit
 
class MainViewHeaderCell: UICollectionViewCell {
    
    static let reusableCellIdetifier = "MainViewHeaderCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.text = "Placeholder"
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
        addSubview(mainLabel)
        addSubview(imageView)
        
        mainLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        
        imageView.anchor(top: mainLabel.topAnchor, left: nil, bottom: mainLabel.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 20, height: 20)
        imageView.image = UIImage(systemName: "chevron.right")
    }
    
}

#if DEBUG
import SwiftUI

struct MainViewHeaderCell_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            MainViewHeaderCell()
        }
    }
}

#endif

