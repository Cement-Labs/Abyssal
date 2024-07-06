//
//  VersionTests.swift
//  AbyssalTests
//
//  Created by KrLite on 2024/7/5.
//

import Testing
@testable import Abyssal

struct VersionTests {
    @Test func parseComponent() async throws {
        let componentString = "42"
        let component = Version.Component(parsing: componentString)
        
        #expect(component != nil)
        #expect(component == .number(42))
    }
    
    @Test func parseVersion() async throws {
        let versionString = "1.0.0.0-alpha. 2.34 .567 -patch. beta-2, 1 ,2.3"
        let version = Version(from: versionString)
        
        #expect(version != nil)
        #expect(version?.string == "1.0.0.0-alpha.2.34.567-patch-beta.3")
    }
    
    @Test func compareVersions() async throws {
        let version1 = Version(from: "3.3.1")!
        let version2 = Version(from: "4.0.0-alpha.1")!
        let version3 = Version(from: "4.0.0")!
        
        // Equalities
        #expect(!(version1 < version1))
        #expect(!(version1 > version1))
        
        #expect(!(version2 < version2))
        #expect(!(version2 > version2))
        
        #expect(!(version3 < version3))
        #expect(!(version3 > version3))
        
        // Comparisons
        #expect(version1 != version2)
        #expect(version1 < version2)
        #expect(version2 > version1)
        #expect(!(version1 > version2))
        #expect(!(version2 < version1))
        
        #expect(version1 != version3)
        #expect(version1 < version3)
        #expect(version3 > version1)
        #expect(!(version1 > version3))
        #expect(!(version3 < version1))
        
        #expect(version2 != version3)
        #expect(version2 < version3)
        #expect(version3 > version2)
        #expect(!(version2 > version3))
        #expect(!(version3 < version2))
    }
}
