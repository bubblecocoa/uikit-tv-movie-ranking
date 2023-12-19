//
//  ViewModel.swift
//  TVMovieRanking
//
//  Created by 정동원 on 12/19/23.
//

import RxSwift

class ViewModel {
    let disposeBag = DisposeBag()
    private let tvNetwork: TVNetwork
    private let movieNetwork: MovieNetwork
    
    init() {
        let provider = NetworkProvider()
        movieNetwork = provider.makeMovieNetwork()
        tvNetwork = provider.makeTVNetwork()
    }
    
    struct Input {
        let tvTrigger: Observable<Void>
        let movieTrigger: Observable<Void>
    }
    
    struct Output {
        let tvList: Observable<[TV]>
//        let movieList: Observable<MovieResult>
    }
    
    func transform(input: Input) -> Output {
        // trigger -> 네트워크 -> Observable<T> -> VC 전달 -> VC에서 구독
        
        // tvTrigger -> Observable<Void> -> Observable<[TV]>
        let tvList = input.tvTrigger.flatMapLatest { [unowned self] _ -> Observable<[TV]> in
            // Observable<TVListModel> -> Observable<[TV]>
            return self.tvNetwork.getTopRatedList().map { $0.results }
        }
        
        input.movieTrigger.bind {
            print("Movie Trigger")
        }.disposed(by: disposeBag)
        
        return Output(tvList: tvList)
    }
}
