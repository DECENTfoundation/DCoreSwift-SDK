import Foundation

class GetConfig: BaseRequest<Config> {

    required init() {
        super.init(.database, api: "get_config", returnClass: Config.self)
    }
}
