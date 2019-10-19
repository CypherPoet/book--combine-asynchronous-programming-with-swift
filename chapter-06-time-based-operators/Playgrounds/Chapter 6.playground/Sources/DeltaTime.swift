import Foundation


let start = Date()


let deltaFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.negativePrefix = ""
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    
    return formatter
}()



/// A simple delta time formatter suitable for use in playground pages: start date is initialized every time the page starts running
public var deltaTime: String {
    return deltaFormatter.string(for: Date().timeIntervalSince(start))!
}
