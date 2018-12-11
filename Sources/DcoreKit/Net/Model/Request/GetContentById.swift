import Foundation

class GetContentById: GetObjects<[Content]> {
    
    required init(contentId: ChainObject) {
        guard contentId.objectType == ObjectType.CONTENT_OBJECT else { preconditionFailure("not a valid content object id") }
        super.init(objects: [contentId], returnClass: [Content].self)
    }
}
