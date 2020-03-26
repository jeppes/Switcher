import XCTest
import Switcher
import SwiftUI

final class CasePathTests: XCTestCase {
    private enum Cases: Equatable {
        case withNothing
        case withString(String)
        case withTuple(left: Int, right: Int)
    }

    func testEnumWithNoAssociatedValues() {
        var matchedCase = false
        _ = Switcher(Cases.withNothing)
                .just(Cases.withNothing) { _ -> Text in
                    matchedCase = true
                    return Text("With Nothing")
                }
                .body

        XCTAssertTrue(matchedCase)
    }
    
    func testEnumWithOneAssociatedValue() {
        var matchedCase = false
        _ = Switcher(Cases.withString("a"))
            .match(Cases.withString) { innerValue -> Text in
                XCTAssertEqual("a", innerValue)
                matchedCase = true
                return Text("With Nothing")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }

    func testCasePathWithTuple() {
        var matchedCase = false
        _ = Switcher(Cases.withTuple(left: 1, right: 2))
            .match(Cases.withTuple) { left, right -> Text in
                XCTAssertEqual(1, left)
                XCTAssertEqual(2, right)
                matchedCase = true
                return Text("With Nothing")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }
}
