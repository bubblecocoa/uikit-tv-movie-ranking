//
//  ViewController.swift
//  TVMovieRanking
//
//  Created by 정동원 on 12/18/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let buttonView = ButtonView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
}
