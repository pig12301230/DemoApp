//
//  SearchViewModel.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/1.
//  Copyright © 2019 Winston. All rights reserved.
//

import Foundation
import RxSwift


protocol SearchViewModel {
    func search(name: String, amount: Int) -> PublishSubject<[Result]>
}

class SearchViewModelImpl: SearchViewModel {
    func search(name: String, amount: Int) -> PublishSubject<[Result]> {
        return PublishSubject()
    }
}
