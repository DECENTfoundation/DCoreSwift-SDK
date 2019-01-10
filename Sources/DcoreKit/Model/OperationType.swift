import Foundation

public enum OperationType: Int, Codable {
    case
    transferOperation = 0,
    accountCreateOperation,
    accountUpdateOperation,
    assetCreateOperation,
    assetIssueOperation,
    assetPublishFeedOperation,
    minerCreateOperation,
    minerUpdateOperation,
    minerUpdateGlobalParamatersOperation,
    proposalCreateOperation,
    proposalUpdateOperation,      //10
    proposalDeleteOperation,
    withdrawPermissionCreateOperation,
    withdrawPermissionUpdateOperation,
    withdrawPermissionClaimOperation,
    withdrawPermissionDeleteOperation,   //15
    vestingBalanceCreateOperation,
    vestingBalanceWithdrawOperation,
    customOperation,
    assertOperation,
    contentSubmitOperation,       //20
    requestToBuyOperation,
    leaveRatingAndCommentOperation,
    readyToPublishOperation,
    proofOfCustodyOperation,
    deliverKeysOperation,                 //25
    subscribeOperation,
    subscribeByAuthorOperation,
    automaticRenewalOfSubscriptionOperation,
    reportStatsOperation,
    setPublishingManagerOperation, //30
    setPublishingRightOperation,
    contentCancellationOperation,
    assetFundPoolsOperation,
    assetReserveOperation,
    assetClaimFeesOperation,     //35
    updateUserIssuedAssetOperation,
    updateMonitoredAssetOperation,
    readyToPublishTwoOperation,
    transferTwoOperation,
    disallowAutomaticRenewalOfSubscriptionOperation,    // VIRTUAL 40
    returnEscrowSubmissionOperation,                    // VIRTUAL
    returnEscrowBuyingOperation,                        // VIRTUAL
    paySeederOperation,                                 // VIRTUAL
    finishBuyingOperation,                              // VIRTUAL
    renewalOfSubscriptionOperation                      // VIRTUAL 45
}

extension OperationType: CustomStringConvertible {
    public var description: String {
        return "\(self)"
    }
}
