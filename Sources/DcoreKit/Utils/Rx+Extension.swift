import Foundation
import RxSwift

extension Single {
    func cache(size: Int = 1) -> PrimitiveSequence<SingleTrait, Element> {
        return self.asObservable().share(replay: size).asSingle()
    }
}
