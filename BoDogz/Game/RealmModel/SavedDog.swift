import RealmSwift

class SavedDog: Object {
    @objc dynamic var birthDate: Date = Date.init(timeIntervalSinceNow: 0)
    @objc dynamic var genderSegmentIndex: Int = 0
    @objc dynamic var imagePath: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var bio: String = ""
    @objc dynamic var breed: String = ""
    @objc dynamic var spayed: Bool = false
    
                                               
    override class func primaryKey() -> String? {
        return "name"
    }
}
