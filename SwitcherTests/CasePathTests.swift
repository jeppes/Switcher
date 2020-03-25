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
        _ = Switcher(value: Cases.withNothing)
                .when(Cases.withNothing) { _ -> Text in
                    matchedCase = true
                    return Text("With Nothing")
                }
                .fallback { _ -> Text in
                    XCTFail()
                    return Text("")
                }
                .body

        XCTAssertTrue(matchedCase)
    }
    
    func testEnumWithOneAssociatedValue() {
        var matchedCase = false
        _ = Switcher(value: Cases.withString("a"))
            .when(Cases.withString) { innerValue -> Text in
                XCTAssertEqual("a", innerValue)
                matchedCase = true
                return Text("With Nothing")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }

    func testCasePathWithTuple() {
        var matchedCase = false
        _ = Switcher(value: Cases.withTuple(left: 1, right: 2))
            .when(Cases.withTuple) { left, right -> Text in
                XCTAssertEqual(1, left)
                XCTAssertEqual(2, right)
                matchedCase = true
                return Text("With Nothing")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }

    func testCasePathWithArgumentlessClosure() {
        var matchedCase = false
        let matcher: () -> Text = {
            matchedCase = true
            return Text("With Nothing")
        }
        _ = Switcher(value: Cases.withTuple(left: 1, right: 2))
            .when(Cases.withTuple, unwrap: matcher)
            .body
        
        XCTAssertTrue(matchedCase)
    }
}
