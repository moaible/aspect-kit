// 
// Copyright (c) moaparts.
// All rights reserved.
//

import XCTest
@testable import RuntimeKit

class RuntimeKitTests: XCTestCase {
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Runtime tests
    
    // MARK: get class name
    
    func testClassName_NSObject() {
        let NSObjectClassNameFromRuntime = Runtime.className(NSObject.self)
        let NSObjectClassNameFromFoundation = NSStringFromClass(NSObject.self)
        XCTAssertEqual(NSObjectClassNameFromRuntime, "NSObject")
        XCTAssertEqual(NSObjectClassNameFromRuntime, NSObjectClassNameFromFoundation)
    }
    
    func testClass_SwiftPureClass() {
        do {
            // SwiftPureClass.SwiftPureClass
            let SwiftNestedPureClassNameFromRuntime = Runtime.className(SwiftPureClass.SwiftPureClass.self)
            let SwiftNestedPureClassNameFromFoundation = NSStringFromClass(SwiftPureClass.SwiftPureClass.self)
            XCTAssertEqual(SwiftNestedPureClassNameFromRuntime, SwiftNestedPureClassNameFromFoundation)
        }
        do {
            // SwiftPureClass.SwiftPureClass.SwiftPureClass
            let SwiftNestedPureClassNameFromRuntime = Runtime.className(SwiftPureClass.SwiftPureClass.SwiftPureClass.self)
            let SwiftNestedPureClassNameFromFoundation = NSStringFromClass(SwiftPureClass.SwiftPureClass.SwiftPureClass.self)
            XCTAssertEqual(SwiftNestedPureClassNameFromRuntime, SwiftNestedPureClassNameFromFoundation)
        }
    }
    
    func testClass_SwiftPureStruct_SwiftPureClass() {
        do {
            // SwiftPureStruct.SwiftPureClass
            let SwiftNestedPureClassNameFromRuntime = Runtime.className(SwiftPureStruct.SwiftPureClass.self)
            let SwiftNestedPureClassNameFromFoundation = NSStringFromClass(SwiftPureStruct.SwiftPureClass.self)
            XCTAssertEqual(SwiftNestedPureClassNameFromRuntime, SwiftNestedPureClassNameFromFoundation)
        }
        do {
            // SwiftPureStruct.SwiftPureClass.SwiftPureClass
            let SwiftNestedPureClassNameFromRuntime = Runtime.className(SwiftPureStruct.SwiftPureClass.SwiftPureClass.self)
            let SwiftNestedPureClassNameFromFoundation = NSStringFromClass(SwiftPureStruct.SwiftPureClass.SwiftPureClass.self)
            XCTAssertEqual(SwiftNestedPureClassNameFromRuntime, SwiftNestedPureClassNameFromFoundation)
        }
    }
    
    func testClass_NSObjectSubclass() {
        // NSObjectSubclass
        let NSObjectSubclassFromRuntime = Runtime.className(NSObjectSubclass.self)
        let NSObjectSubClassFromFoundation = NSStringFromClass(NSObjectSubclass.self)
        XCTAssertEqual(NSObjectSubclassFromRuntime, NSObjectSubClassFromFoundation)
    }
    
    func testClass_NSObjectSubclass_NSObjectSubclass() {
        // NSObjectSubclass.NSObjectSubclass
        let NSObjectSubclassFromRuntime = Runtime.className(NSObjectSubclass.NSObjectSubclass.self)
        let NSObjectSubClassFromFoundation = NSStringFromClass(NSObjectSubclass.NSObjectSubclass.self)
        XCTAssertEqual(NSObjectSubclassFromRuntime, NSObjectSubClassFromFoundation)
    }
    
    // MARK: get class
    
    func testClass_NSObject() {
        guard let NSObjectClassFromRuntime: AnyClass = Runtime.class("NSObject") else {
            fatalError("failed NSObjectClassFromRuntime")
        }
        let NSObjectClass = NSObject.self
        XCTAssertEqual(NSStringFromClass(NSObjectClassFromRuntime), NSStringFromClass(NSObjectClass))
    }
    
    func testClass_HogeStruct() {
        
        struct Hoge {}
        
        guard let _: AnyClass = Runtime.class("Hoge") else {
            XCTAssertTrue(true, "not found struct definition from objc runtime")
            return
        }
        XCTFail("should not found struct definition from objc runtime")
    }
    
    func testClass_SwiftPureProtocol() {
        let desc = "should not found swift pure protocol definition from objc runtime"
        guard let _: AnyClass = Runtime.class("SwiftPureProtocol") else {
            return precondition(true, desc)
        }
        XCTFail(desc)
    }
    
    // MARK: get all class
    
    func testAllClasses() {
        XCTAssertTrue(Runtime.allClass().count > 0)
    }
    
    func testNSObjectInAllClasses() {
        let desc = "should found NSObject definition from objc runtime"
        guard let NSObjectClassFromRuntime = Runtime.allClass(isIncluded: { anyClazz in
            NSStringFromClass(anyClazz) == NSStringFromClass(NSObject.self)
        }).first else {
            return precondition(true, desc)
        }
        let NSObjectClass = NSObject.self
        XCTAssertEqual(NSStringFromClass(NSObjectClassFromRuntime), NSStringFromClass(NSObjectClass))
    }
    
    // MARK: get meta class
    
    func testMetaClass_NSObject() {
        guard let NSObjectMetaClassFromRuntime: AnyClass = Runtime.metaClass(NSObject.self) else {
            fatalError("failed NSObjectClassFromRuntime")
        }
        let NSObjectClass = NSObject.self
        XCTAssertEqual(NSStringFromClass(NSObjectMetaClassFromRuntime), NSStringFromClass(NSObjectClass))
    }
    
    // MARK: is meta class
    
    func testIsMetaClass_NSObject() {
        guard let NSObjectMetaClassFromRuntime: AnyClass = Runtime.metaClass(NSObject.self) else {
            fatalError("failed NSObjectClassFromRuntime")
        }
        let NSObjectClass = NSObject.self
        XCTAssertTrue(Runtime.isMetaClass(NSObjectMetaClassFromRuntime))
        XCTAssertFalse(Runtime.isMetaClass(NSObjectClass))
    }
    
    // MARK: get super class
    
    func testSuperClass_NSDictionary() {
        guard let NSDictionarySuperClassFromRuntime: AnyClass = Runtime.superClass(NSDictionary.self) else {
            fatalError("failed NSObjectClassFromRuntime")
        }
        let NSObjectClass = NSObject.self
        XCTAssertEqual(NSStringFromClass(NSDictionarySuperClassFromRuntime), NSStringFromClass(NSObjectClass))
    }
    
    // MARK: get & set class version
    
    func testClassVersion_NSObject() {
        var NSObjectClassVersion = Runtime.classVersion(NSObject.self)
        XCTAssertEqual(NSObjectClassVersion, 0)
        Runtime.setClassVersion(NSObject.self, version: 1)
        NSObjectClassVersion = Runtime.classVersion(NSObject.self)
        XCTAssertEqual(NSObjectClassVersion, 1)
        Runtime.setClassVersion(NSObject.self, version: 0)
        NSObjectClassVersion = Runtime.classVersion(NSObject.self)
        XCTAssertEqual(NSObjectClassVersion, 0)
    }
    
    // MARK: get class instance size
    
    func testClassInstanceSize_NSObject() {
        let NSObjectClassInstanceSize = Runtime.classInstanceSize(NSObject.self)
        XCTAssertEqual(NSObjectClassInstanceSize, 8)
        XCTAssertEqual(NSObjectClassInstanceSize, MemoryLayout<NSObject>.size)
    }
    
    // MARK: -
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            
        }
    }
}
