//
//  SearchViewModel.swift
//  Book
//
//  Created by Finley on 2022/08/05.
//

import Foundation

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    let queryText = PublishRelay<String?>() //기존 self.rx.text(텍스트변동사항)은 뷰모델이아닌 뷰가 알고있는 것이기때문에 뷰로부터 전달받는다
    let searchButtonTapped = PublishRelay<Void>()
    let shouldLoadResult: Observable<String>
    
    init() {
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" } //원래 self.rx.text가 있던자리를 대체해준다
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
    }
}
