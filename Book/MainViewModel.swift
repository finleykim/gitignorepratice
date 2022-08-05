//
//  MainViewModel.swift
//  Book
//
//  Created by Finley on 2022/08/05.
//

import RxSwift
import RxCocoa

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let searchBarViewModel = SearchBarViewModel()
    let bookListViewModel = BookListViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        let bookResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBook)
            .share()
        
        let bookValue = bookResult
            .map(model.getBookValue)
            .filter { $0 != nil }
        
        let bookError = bookResult
            .map(model.getBookError)
            .filter { $0 != nil }
        
        //네트워크를 통해 가져온 값을 CellData로 변환
        let cellData = bookValue
            .map(model.getBookListCellData)
        
        //FilterView를 선택했을 때 나오는 alertsheet를 선택했을 때 type
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        //MainViewController -> ListView
        Observable
            .combineLatest( //소스두개를받아 resultSeletor까지 안내한다
                            sortedType,
                            cellData, //이 두개 소스를 받아
                            resultSelector: model.sort //여기로 안내
                        )
            .bind(to: bookListViewModel.bookListCellData)
//뷰모델이 listView를 모르기때문에(listView는 뷰에 정의되어있음)listView.cellData였던걸 bookListViewModel.bookListCellData로 바꾼다. (이런식으로 listView는 다 바꿔주면됨)
            .disposed(by: disposeBag)
        
        let alertSheetForSorting = bookListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = bookError
            .do(onNext: { message in
                print("error: \(message ?? "")")
            })
            .map { _ -> MainViewController.Alert in
                return (
                    title: "앗!",
                    message: "예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        self.shouldPresentAlert = Observable //뷰모델에서 이벤트 스트림을 하나로 묶기위해 정의한 shouldPresentAlert이 이런 애라는 걸 알려준다.
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
