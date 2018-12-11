import Foundation

public enum SearchAccountHistoryOrder: String {
    case
    TYPE_ASC = "+type",
    TO_ASC = "+to",
    FROM_ASC = "+from",
    PRICE_ASC = "+price",
    FEE_ASC = "+fee",
    DESCRIPTION_ASC = "+description",
    TIME_ASC = "+time",
    TYPE_DESC = "-type",
    TO_DESC = "-to",
    FROM_DESC = "-from",
    PRICE_DESC = "-price",
    FEE_DESC = "-fee",
    DESCRIPTION_DESC = "-description",
    TIME_DESC = "-time"
}

public enum SearchContentOrder: String {
    case
    AUTHOR_ASC = "+author",
    RATING_ASC = "+rating",
    SIZE_ASC = "+size",
    PRICE_ASC = "+price",
    CREATED_ASC = "+created",
    EXPIRATION_ASC = "+expiration",
    AUTHOR_DESC = "-author",
    RATING_DESC = "-rating",
    SIZE_DESC = "-size",
    PRICE_DESC = "-price",
    CREATED_DESC = "-created",
    EXPIRATION_DESC = "-expiration"
}

public enum SearchPurchasesOrder: String {
    case
    SIZE_ASC = "+size",
    PRICE_ASC = "+price",
    CREATED_ASC = "+created",
    PURCHASED_ASC = "+purchased",
    SIZE_DESC = "-size",
    PRICE_DESC = "-price",
    CREATED_DESC = "-created",
    PURCHASED_DESC = "-purchased"
}

public enum SearchAccountsOrder: String {
    case
    ID_ASC = "+id",
    NAME_ASC = "+name",
    ID_DESC = "-id",
    NAME_DESC = "-name"
}

public enum SearchMinerVotingOrder: String {
    case
    NAME_ASC = "+name",
    NAME_DESC = "-name"
}
