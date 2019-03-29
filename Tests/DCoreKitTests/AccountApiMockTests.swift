import XCTest
import Hippolyte
import RxBlocking

@testable import DCoreKit

class AccountApiMockTests: MockTestCase {

    private let url = "https://stagesocket.decentgo.com:8090/rpc"

    func testGetAccountByIdUsingRest() {
        
        let rest = DCore.Sdk.create(forRest: url)
        let data = """
        {"id":1,"result":[{"id":"1.2.35","registrar":"1.2.15","name":"u3a7b78084e7d3956442d5a4d439dad51","owner":{"weight_threshold":1,"account_auths":[],"key_auths":[["DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP",1]]},"active":{"weight_threshold":1,"account_auths":[],"key_auths":[["DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP",1]]},"options":{"memo_key":"DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP","voting_account":"1.2.3","num_miner":0,"votes":[],"extensions":[],"allow_subscription":false,"price_per_subscribe":{"amount":0,"asset_id":"1.3.0"},"subscription_period":0},"rights_to_publish":{"is_publishing_manager":false,"publishing_rights_received":[],"publishing_rights_forwarded":[]},"statistics":"2.5.35","top_n_control_flags":0}]}
        """.asEncoded()
     
        mock(using: url, data: data)
        
        let account = try? rest.account.get(byId: "1.2.35".dcore.chainObject!).debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.35".dcore.chainObject)
    }
    
    func testGetAccountByNameUsingRest() {
        
        let rest = DCore.Sdk.create(forRest: url)
        let data = """
        {"id":1,"result":{"id":"1.2.34","registrar":"1.2.15","name":"u961279ec8b7ae7bd62f304f7c1c3d345","owner":{"weight_threshold":1,"account_auths":[],"key_auths":[["DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz",1]]},"active":{"weight_threshold":1,"account_auths":[],"key_auths":[["DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz",1]]},"options":{"memo_key":"DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz","voting_account":"1.2.3","num_miner":0,"votes":[],"extensions":[],"allow_subscription":false,"price_per_subscribe":{"amount":0,"asset_id":"1.3.0"},"subscription_period":0},"rights_to_publish":{"is_publishing_manager":false,"publishing_rights_received":[],"publishing_rights_forwarded":[]},"statistics":"2.5.34","top_n_control_flags":0}}
        """.asEncoded()
        
        mock(using: url, data: data)
        
        let account = try? rest.account.get(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.34".dcore.chainObject)
    }
}
