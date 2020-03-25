import XCTest
import Switcher
import SwiftUI

class SwitcherTests: XCTestCase {
    func testSwitcherWithPredicate() {
        var matchedCase = false
        _ = Switcher(value: 1)
            .when({ $0 == 1 }) { value -> Text in
                XCTAssertEqual(1, value)
                matchedCase = true
                return Text("")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }

    func testSwitcherWithPredicateAndArgumentlessClosure() {
        var matchedCase = false
        let unwrap: () -> Text = {
            matchedCase = true
            return Text("")
        }
        _ = Switcher(value: 1)
            .when({ $0 == 1 }, unwrap: unwrap)
            .body
        
        XCTAssertTrue(matchedCase)
    }
    
    func testSwitcherWithEquatableValue() {
        var matchedCase = false
        _ = Switcher(value: 1)
            .when(1) { value -> Text in
                XCTAssertEqual(1, value)
                matchedCase = true
                return Text("")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }
    
    func testSwitcherWithEquatableAndArgumentlessClosure() {
        var matchedCase = false
        let unwrap: () -> Text = {
            matchedCase = true
            return Text("")
        }
        _ = Switcher(value: 1)
            .when({ $0 == 1 }, unwrap: unwrap)
            .body
        
        XCTAssertTrue(matchedCase)
    }
    
    func testSwitcherWithFallback() {
        var matchedCase = false
        _ = Switcher(value: 1)
            .fallback { value -> Text in
                XCTAssertEqual(1, value)
                matchedCase = true
                return Text("")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }
    
    func testSwitcherWithFallbackAndArgumentlessClosure() {
        var matchedCase = false
        let unwrap: () -> Text = {
            matchedCase = true
            return Text("")
        }
        _ = Switcher(value: 1)
            .fallback(unwrap)
            .body
        
        XCTAssertTrue(matchedCase)
    }
    
    func testSwitcherMatchesArgumentsInOrder() {
        var matchedCase = false
        _ = Switcher(value: 1)
            .fallback { _ -> Text in
                matchedCase = true
                return Text("")
            }
            .fallback { _ -> Text in
                matchedCase = false
                XCTFail()
                return Text("")
            }
            .body
        
        XCTAssertTrue(matchedCase)
    }
}
