//
//  URL+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import Foundation

extension URL {
    static let sourceCode = URL(string: "https://github.com/\(repository)")!
    
    static let release = URL(string: "https://github.com/\(repository)/releases/\(VersionManager.latestTag)")!
    
    static let releaseTags = URL(string: "https://api.github.com/repos/\(repository)/tags")!
}
