//
//  TVNetwork.swift
//  TVMovieRanking
//
//  Created by 정동원 on 12/18/23.
//

import RxSwift

final class TVNetwork {
    private let network: Network<TVListModel>
    
    init(network: Network<TVListModel>) {
        self.network = network
    }
    
    func getTopRatedList() -> Observable<TVListModel> {
        return network.getItemList(path: "/movie/top_rated")
    }
}
