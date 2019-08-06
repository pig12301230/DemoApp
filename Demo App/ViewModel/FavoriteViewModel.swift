//
//  FavoriteViewModel.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/5.
//  Copyright © 2019 Winston. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol FavoriteViewModel {
    var favorites: PublishSubject<[Result]> { get }
}

class FavoriteViewModelImpl: FavoriteViewModel {
    var favorites: PublishSubject<[Result]> = PublishSubject()
    
    init() {
        
    }
}
