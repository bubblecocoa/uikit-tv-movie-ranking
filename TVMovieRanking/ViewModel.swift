//
//  ViewModel.swift
//  TVMovieRanking
//
//  Created by 정동원 on 12/19/23.
//

import RxSwift

class ViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let tvTrigger: Observable<Void>
        let movieTrigger: Observable<Void>
    }
    
    struct Output {
        let tvList: Observable<[TV]>
//        let movieList: Observable<MovieResult>
    }
    
    func transform(input: Input) -> Output {
        input.tvTrigger.bind {
            print("TV Trigger")
        }.disposed(by: disposeBag)
        
        input.movieTrigger.bind {
            print("Movie Trigger")
        }.disposed(by: disposeBag)
        
        return Output(tvList: Observable<[TV]>.just([]))
    }
}
