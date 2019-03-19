import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(back_office_webTests.allTests),
    ]
}
#endif