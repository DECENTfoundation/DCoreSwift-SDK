import Foundation

class GetConfig: BaseRequest<Config> {

    required init() {
        super.init(api: .DATABASE, method: "get_config", returnClass: Config.self)
    }
}
