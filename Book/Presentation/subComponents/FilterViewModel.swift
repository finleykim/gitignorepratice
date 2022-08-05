//
//  FilterViewModel.swift
//  Book
//
//  Created by Finley on 2022/08/05.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    let sortButtonTapped = PublishRelay<Void>()
} //FilterView에서 버튼 이벤트를 내뿜는 다는 것만 알고있으면 된다
