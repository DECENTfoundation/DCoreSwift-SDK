import Foundation

class GetContentById: GetObjects<[Content]> {
    
    required init(contentId: ChainObject) {
        
        precondition(contentId.objectType == .contentObject, "Not a valid content object id")
        super.init(objects: [contentId], returnClass: [Content].self)
    }
}
