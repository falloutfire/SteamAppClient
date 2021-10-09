//
//  ViewController.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit
import RouteComposer

class MainViewControllerFactory<VC: UINavigationController, C>: Factory {
    
    func build(with context: C) throws -> VC {
        let viewController = MainViewController()
        viewController.bind(to: FeaturedViewModel(router: viewController.router, featuredRepository: FeaturedRepository.shared))

        let navViewController = UINavigationController(rootViewController: viewController)
        return navViewController as! VC
    }
    
    
    typealias ViewController = VC
    
    typealias Context = C
    
    init() {}
}

class MainViewController: UIViewController, BindableType {
    
    typealias ViewModelType = FeaturedViewModelProtocol
    
    var dataSource: UICollectionViewDiffableDataSource<FeaturedHashableSection, FeaturedItem>! = nil
    var collectionView: UICollectionView! = nil
    var viewModel: FeaturedViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(filterButtonTapped(_:)))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func filterButtonTapped(_ item: UIBarButtonItem) {
        if let values = viewModel.items.value {
            var snapshot = NSDiffableDataSourceSnapshot<FeaturedHashableSection, FeaturedItem>()
            
            snapshot.appendSections(values)
            values.forEach { section in
                snapshot.appendItems(section.items ?? [], toSection: section)
                //snapshot.reloadItems(section.items ?? [])
            }
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(FeaturedItemCell.self, forCellWithReuseIdentifier: FeaturedItemCell.reusableCellIdetifier)
        
//        collectionView.register(MainViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainViewHeaderCell.reusableCellIdetifier)
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = FeaturedSection(rawValue: sectionIndex) else { return nil }
            let section = self.layoutSection(for: sectionKind, layoutEnvironment: layoutEnvironment)
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16.0
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func layoutSection(for section: FeaturedSection, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch section {
        case .largeCapsulesItems:
            return largeCapsulesSection()
        case .featuredWinItems:
            return featuredWinSection()
        case .featuredMACItems:
            return featuredMACSection()
        case .featuredLinuxItems:
            return featuredWinSection()
        }
    }
    
    private func largeCapsulesSection() -> NSCollectionLayoutSection {
        let inset: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func featuredWinSection() -> NSCollectionLayoutSection {
        let inset: CGFloat = 10
            // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
        // Section
        let section = NSCollectionLayoutSection(group: group)
        // after section delcaration…
        //section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
        section.orthogonalScrollingBehavior = .continuous
        //section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func featuredMACSection() -> NSCollectionLayoutSection {
        let inset: CGFloat = 10
            // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
        // Section
        let section = NSCollectionLayoutSection(group: group)
        // after section delcaration…
        //section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
        section.orthogonalScrollingBehavior = .continuous
        //section.boundarySupplementaryItems = [header]
        return section
    }
}

extension MainViewController {
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<FeaturedHashableSection, FeaturedItem>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let self = self, let item = self.dataSource.itemIdentifier(for: indexPath) else {
                fatalError("Cannot create the cell")
                return nil
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedItemCell.reusableCellIdetifier, for: indexPath) as? FeaturedItemCell else { fatalError("Cannot create the cell") }

            let viewModel = FeaturedCellViewModel(featuredItem: item, router: self.router, featuredRepository: FeaturedRepository.shared)
            cell.bind(to: viewModel)
            return cell
        }

        
        
//        dataSource.supplementaryViewProvider = { (
//            collectionView: UICollectionView,
//            kind: String,
//            indexPath: IndexPath) -> UICollectionReusableView? in
//
//            if indexPath.section == 1 {
//                let header: MainViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainViewHeaderCell.reusableCellIdetifier, for: indexPath) as! MainViewHeaderCell
//
//                header.mainLabel.text = "Catalogue"
//                header.mainLabel.textColor = .black
//                return header
//            } else if indexPath.section == 2 {
//                let header: MainViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainViewHeaderCell.reusableCellIdetifier, for: indexPath) as! MainViewHeaderCell
//
//                header.mainLabel.text = "Collections"
//                header.mainLabel.textColor = .black
//                return header
//            } else {
//                return nil
//            }
//        }
        
    }
    
    func bindViewModel() {
        
        viewModel.items.bind({ [weak self] items in
            guard let self = self, let values = items else { return }
            var snapshot = NSDiffableDataSourceSnapshot<FeaturedHashableSection, FeaturedItem>()
            
            snapshot.appendSections(values)
            values.forEach { section in
                snapshot.appendItems(section.items ?? [], toSection: section)
            }
            self.dataSource.apply(snapshot)
        })
        
        
        viewModel.getFeaturedItems()
    }
    
    
}
