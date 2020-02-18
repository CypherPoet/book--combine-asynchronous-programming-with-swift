import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "http://numbersapi.com/random/math")!


URLSession.shared.dataTask(with: url) { (data, response, error) in
    print(String(data: data!, encoding: .utf8)!)
    
    guard let response = response as? HTTPURLResponse else { return }
    
    print(response.value(forHTTPHeaderField: "X-Numbers-API-Number"))
    print(response.value(forHTTPHeaderField: "X-Numbers-API-Type"))
    
    PlaygroundPage.current.finishExecution()
}
.resume()
