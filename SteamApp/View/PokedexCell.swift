//
//  PokedexCell.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit

class PokedexCell: UICollectionViewCell {
    
    static let reusableCellIdetifier = "PokedexCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        view.addSubview(mainLabel)
        mainLabel.center(inView: view)
        return view
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
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        addSubview(imageView)
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.width - 30)
        
        addSubview(mainView)
        mainView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
    }
    
    func configure(with title: String, image: UIImage?) {
        imageView.image = image
        mainLabel.text = title
    }
}

#if DEBUG
import SwiftUI

struct PokedexCell_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            PokedexCell()
        }
    }
}

#endif
