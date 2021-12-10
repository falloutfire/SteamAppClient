//
//  ViewController.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit
import RouteComposer
import Kingfisher
import Combine

class MainViewControllerFactory<VC: UINavigationController, C>: Factory {
    
    func build(with context: C) throws -> VC {
        let viewController = MainViewController()
        viewController.bind(to: FeaturedViewModel(router: viewController.router, featuredRepository: FeaturedRepository.shared))
        viewController.title = "Shop"
        
        let navViewController = UINavigationController(rootViewController: viewController)
        navViewController.navigationBar.prefersLargeTitles = true
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
    
    private var subscribitions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(filterButtonTapped(_:)))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func filterButtonTapped(_ item: UIBarButtonItem) {
        viewModel.getFeaturedItems()
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(FeaturedItemCell.self, forCellWithReuseIdentifier: FeaturedItemCell.reusableCellIdetifier)
        
        //        collectionView.register(MainViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainViewHeaderCell.reusableCellIdetifier)
        view.addSubview(collectionView)
    }
    
    func createLayout(items: [FeaturedHashableSection]? = nil) -> UICollectionViewLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if items == nil {
                guard let sectionKind = FeaturedSection(rawValue: sectionIndex) else { return nil }
                let section = self.layoutSection(for: sectionKind, layoutEnvironment: layoutEnvironment)
                return section
            } else {
                guard let sectionKind = items?[sectionIndex].type else { return nil }
                let section = self.layoutSection(for: sectionKind, layoutEnvironment: layoutEnvironment)
                return section
            }
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(275))
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(230))
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
            cell.configureView(with: item)
            cell.imageView.kf.indicatorType = .activity
            KF.url(URL(string: item.headerImage))
                .fade(duration: 1)
                .loadDiskFileSynchronously()
                .onProgress { (received, total) in print("\(indexPath.row + 1): \(received)/\(total)") }
                .onSuccess {
                    print($0)
                }
                .onFailure { err in print("Error: \(err)") }
                .set(to: cell.imageView)
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
        
        viewModel.featuredItemsPublisher
            .sink(receiveValue: { [weak self] items in
                guard let self = self, let values = items else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<FeaturedHashableSection, FeaturedItem>()
                
                var sectionsValues: [FeaturedHashableSection] = []
                values.forEach { section in
                    if let items = section.items, !items.isEmpty {
                        sectionsValues.append(section)
                    }
                }
                
                let layout = self.createLayout(items: sectionsValues)
                self.collectionView.collectionViewLayout = layout
                
                snapshot.appendSections(sectionsValues)
                
                sectionsValues.forEach { section in
                    snapshot.appendItems(section.items ?? [], toSection: section)
                }
                self.dataSource.apply(snapshot)
            })
            .store(in: &subscribitions)
        
        viewModel.getFeaturedItems()
    }
}
