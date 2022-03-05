import Foundation
import RealmSwift

class  DataManager {
    
    static let shared = DataManager()
    
    lazy var realm: Realm = {
        try! Realm()
    }()
    
    var data: Results<SavedDog>!
    
     func save(object: SavedDog) -> Bool {
        if let _ = getDogBy(name: object.name) {
            return false
        } else {
            try? realm.write{
                realm.add(object, update: .modified)
            }
            return true
        }
    }
    
     func getDogBy(name: String) -> SavedDog? {
        let dog = realm.object(ofType: SavedDog.self, forPrimaryKey: name )
        return dog
    }
    
    func get() -> [SavedDog] {
        self.data = realm.objects(SavedDog.self)
        var array = [SavedDog]()
        for object in data {
            array.append(object)
        }
        return array
    }
    
    func getNames() -> [String] {
        self.data = realm.objects(SavedDog.self)
        var names = [String]()
        for dog in  data {
            let name = dog.name
            names.append(name)
        }
        return names
    }
    
    func getBreedBy(name: String) -> String? {
        let dog = realm.object(ofType: SavedDog.self, forPrimaryKey: name) 
        let breed = dog?.breed
        return breed
    }
    
    func deleteAll() {
        try! realm.write{
            realm.delete(data)
        }
    }
    
    func deleteSelected(object: SavedDog) {
        try! realm.write{
            realm.delete(object)
        }
    }
}
