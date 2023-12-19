//
//  ViewController.swift
//  TVMovieRanking
//
//  Created by 정동원 on 12/18/23.
//

import UIKit
import SnapKit
import RxSwift

// 레이아웃
enum Section: Hashable {
    case double
}

// 셀
enum Item: Hashable {
    case normal(TV)
}

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    let buttonView = ButtonView()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(NormalCollectionViewCell.self, forCellWithReuseIdentifier: NormalCollectionViewCell.id)
        
        return collectionView
    }()
    let viewModel = ViewModel()
    // Subject - 이벤트를 발생 시키면서 Observable 형태도 됨
    let tvTrigger = PublishSubject<Void>()
    let movieTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        bindView()
        tvTrigger.onNext(())
    }
    
    private func setUI() {
        self.view.addSubview(buttonView)
        self.view.addSubview(collectionView)
        
        collectionView.backgroundColor = .blue
        
        buttonView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonView.snp.bottom)
        }
    }
    
    private func bindViewModel() {
        let input = ViewModel.Input(tvTrigger: tvTrigger, movieTrigger: movieTrigger)
        let output = viewModel.transform(input: input)
        
        output.tvList.bind { tvList in
            print("TV List: \(tvList)")
        }.disposed(by: disposeBag) // VC가 메모리 해제될 때 바인딩이 끝나게 됨
        
        output.movieResult.bind { movieResult in
            print("Movie Result: \(movieResult)")
        }.disposed(by: disposeBag)
    }
    
    private func bindView() {
        buttonView.tvButton.rx.tap.bind { [weak self] in
            self?.tvTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        buttonView.movieButton.rx.tap.bind { [weak self] in
            self?.movieTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
         let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            return self?.createDoubleSection()
        }, configuration: config)
    }
    
    private func createDoubleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup(layoutSize: groupSize)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .normal(let tvData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: indexPath) as? NormalCollectionViewCell
                cell?.configure(title: tvData.name, review: tvData.vote, desc: tvData.overview, ImageURL: tvData.posterURL)
                
                return cell
            }
        })
    }
}
