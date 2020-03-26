import XCTest
import Switcher
import SwiftUI

class SwitcherTests: XCTestCase {
    func testSwitcherWithPredicate() {
        var matchedCase = false
        _ = Switcher(1)
            .when({ $0 == 1 }) { value -> Text in
                XCTAssertEqual(1, value)
                matchedCase = true
                return Text("")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }

    func testSwitcherWithEquatableValue() {
        var matchedCase = false
        _ = Switcher(1)
            .just(1) { value -> Text in
                XCTAssertEqual(1, value)
                matchedCase = true
                return Text("")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }
    
    func testSwitcherWithFallback() {
        var matchedCase = false
        _ = Switcher(1)
            .fallback { value -> Text in
                XCTAssertEqual(1, value)
                matchedCase = true
                return Text("")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }
    
    func testSwitcherMatchesArgumentsInOrder() {
        var matchedCase = false
        _ = Switcher(2)
            .just(1) { _ -> Text in
                XCTFail()
                return Text("")
            }
            .fallback { _ -> Text in
                matchedCase = true
                return Text("")
            }
            .fallback { _ -> Text in
                XCTFail()
                return Text("")
            }
            
            .body
        
        XCTAssertTrue(matchedCase)
    }
}
