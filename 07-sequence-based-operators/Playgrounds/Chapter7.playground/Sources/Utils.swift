import Foundation


public func demo(describing description: String, action: () -> Void) {
    print("\n--- Example of: \(description) ---")
    action()
}
