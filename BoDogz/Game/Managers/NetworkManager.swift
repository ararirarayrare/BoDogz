import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    static let internet = NetworkReachabilityManager()!
          
    static var isConnectedToInternet:Bool {
        return self.internet.isReachable
      }
    
    func requestListOfBreeds(completion: @escaping(([List]) -> ())) {
        
        AF.request(Constants.breedURL).responseDecodable(of: [List].self) { responce in
            guard let value = responce.value else { return }
            completion(value)
        }
    }
    
    func requestFact(completion: @escaping((String) -> ())) {
        
        AF.request(Constants.factURL).responseDecodable(of: Fact.self) { responce in
            guard let value = responce.value else { return }
            guard let fact = value.facts?.first else { return }
            completion(fact)
        }
    }
}
