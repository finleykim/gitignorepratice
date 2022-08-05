//
//  BookListViewModel.swift
//  Book
//
//  Created by Finley on 2022/08/05.
//

import RxSwift
import RxCocoa

struct BookListViewModel {
    let filterViewModel = FilterViewModel() //BookListView가 FilterView를 헤더로 쓰기때문에 가져와야함
    
    let bookListCellData = PublishSubject<[BookListCellData]>() //cellData에서 이름만 바꾼것(외부에서 알 수 있도록)
    let cellData: Driver<[BookListCellData]> //BookListCellData는 외부에서 데이터를 가져오고, cellData는 그 데이터를 드라이버로 전달한다.
    
    init() {
        self.cellData = bookListCellData
            .asDriver(onErrorJustReturn: [])
    } //cellData는 bookListCellData를 Driver로 바꾼거야라고 설명하는 부분
}
