import Foundation

public enum SearchOrder {
    
    public enum AccountHistory: String, Codable {
        case
        typeAsc = "+type",
        toAsc = "+to",
        fromAsc = "+from",
        priceAsc = "+price",
        feeAsc = "+fee",
        descriptionAsc = "+description",
        timeAsc = "+time",
        typeDesc = "-type",
        toDesc = "-to",
        fromDesc = "-from",
        priceDesc = "-price",
        feeDesc = "-fee",
        descriptionDesc = "-description",
        timeDesc = "-time"
    }
    
    public enum Content: String, Codable {
        case
        authorAsc = "+author",
        ratingAsc = "+rating",
        sizeAsc = "+size",
        priceAsc = "+price",
        createdAsc = "+created",
        expirationAsc = "+expiration",
        authorDesc = "-author",
        ratingDesc = "-rating",
        sizeDesc = "-size",
        priceDesc = "-price",
        createdDesc = "-created",
        expirationDesc = "-expiration"
    }
    
    public enum Purchases: String, Codable {
        case
        sizeAsc = "+size",
        priceAsc = "+price",
        createdAsc = "+created",
        purchasedAsc = "+purchased",
        sizeDesc = "-size",
        priceDesc = "-price",
        createdDesc = "-created",
        purchasedDesc = "-purchased"
    }
    
    public enum Accounts: String, Codable {
        case
        idAsc = "+id",
        nameAsc = "+name",
        idDesc = "-id",
        nameDesc = "-name"
    }
    
    public enum MinerVoting: String, Codable {
        case
        nameAsc = "+name",
        nameDesc = "-name"
    }

}
