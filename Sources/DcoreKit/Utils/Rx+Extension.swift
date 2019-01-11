import Foundation
import RxSwift

extension Single {
    func cache(size: Int = 1) -> PrimitiveSequence<SingleTrait, Element> {
        return self.asObservable().share(replay: size).asSingle()
    }
    
    func mapTo<T>(_ value: T) -> PrimitiveSequence<SingleTrait, T> {
        return self.asObservable().mapTo(value).asSingle()
    }
    
    func asObservableMapTo<T>(_ value: T) -> Observable<T> {
        return self.asObservable().mapTo(value)
    }
}

extension AsyncSubject {
    func applySingle(_ value: E) {
        onNext(value)
        onCompleted()
    }
}

extension CompositeDisposable {
    
    @discardableResult
    func add(_ disposable: Disposable) -> DisposeKey? {
        return self.insert(disposable)
    }
    
    func add(many disposables: [Disposable]) {
        disposables.forEach{ [unowned self] in self.add($0) }
    }
}

// RxSwift Extensions (https://github.com/RxSwiftCommunity/RxSwiftExt)
// Copyright © 2016 RxSwift Community. All rights reserved.

enum FilterMap<Result> {
    case ignore
    case map(Result)
    
    fileprivate var asOperator: AnyOperator<Result> {
        switch self {
        case .ignore: return .filter
        case .map(let value): return .map(value)
        }
    }
}

protocol CustomOperator {
    associatedtype Result
    func apply(_ sink: (Result) -> Void)
}

struct AnyOperator<Result>: CustomOperator {
    typealias Sink = (Result) -> Void
    private let _apply: (Sink) -> Void
    
    init(_ apply: @escaping (Sink) -> Void) { self._apply = apply }
    
    func apply(_ sink: Sink) { _apply(sink) }
}

extension CustomOperator {
    static var filter: AnyOperator<Result> {
        return AnyOperator { _ in }
    }
    
    static func map(_ values: Result...) -> AnyOperator<Result> {
        return AnyOperator { sink in values.forEach { sink($0) } }
    }
}

extension ObservableType {
        
    func ofType<T>(_ type: T.Type) -> Observable<T> {
        return self.filterMap {
            guard let result = $0 as? T else { return .ignore }
            return .map(result)
        }
    }
    
    func mapTo<T>(_ value: T) -> Observable<T> {
        return map { _ in value }
    }
    
    func flatMapSync<O: CustomOperator>(_ transform: @escaping (E) -> O) -> Observable<O.Result> {
        return Observable.create { observer in
            return self.subscribe { event in
                switch event {
                case .next(let element): transform(element).apply { observer.onNext($0) }
                case .completed: observer.onCompleted()
                case .error(let error): observer.onError(error)
                }
            }
        }
    }
    
    func filterMap<T>(_ transform: @escaping (E) -> FilterMap<T>) -> Observable<T> {
        return flatMapSync { transform($0).asOperator }
    }
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
}
