import XCTest
@testable import TranslationService

final class TranslationServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TranslationService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
