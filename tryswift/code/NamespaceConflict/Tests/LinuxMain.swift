import XCTest

import NamespaceConflictTests

var tests = [XCTestCaseEntry]()
tests += NamespaceConflictTests.allTests()
XCTMain(tests)