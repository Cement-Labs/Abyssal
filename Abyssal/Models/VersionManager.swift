//
//  VersionManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import Foundation

struct Version: Codable {
    enum Component: Codable {
        case number(UInt)
        case beta
        case alpha
        case patch
        case blank
        
        var semantic: String {
            switch self {
            case .number(let uInt):
                String(uInt)
            case .beta:
                "beta"
            case .alpha:
                "alpha"
            case .patch:
                "patch"
            case .blank:
                "blank"
            }
        }
        
        static var nonNumerics: [Self] {
            [.beta, .alpha, .patch]
        }
    }
    
    var components: [Component]
    
    var string: String {
        components
            .map(\.semantic)
            .joined(separator: ".")
    }
    
    static var empty: Version = .init(components: [])
    static var app: Version {
        .init(from: Bundle.main.appVersion) ?? .empty
    }
    static var remote: Version {
        VersionManager.remoteVersion
    }
    
    static var hasUpdate: Bool {
        app < remote
    }
    
    init(components: [Component]) {
        self.components = components
    }
    
    init?(from: String) {
        let parts = from
            .replacing(/\s/, with: "")
            .split(separator: /[\.-]/) // Split by `.` or `-`
        let components = parts.compactMap({ Component(parsing: String($0)) })
        
        if components.isEmpty {
            return nil
        } else {
            self.components = components
        }
    }
}

extension Version.Component: Comparable {
    static func <(lhs: Self, rhs: Self) -> Bool {
        guard lhs != rhs else { return false }
        
        return switch lhs {
        case .number(let this):
            switch rhs {
            case .number(let other):
                this < other
            default: true
            }
        case .beta:
            switch rhs {
            case .number(_): false
            default: true
            }
        case .alpha:
            switch rhs {
            case .number(_), .beta: false
            default: true
            }
        case .patch:
            switch rhs {
            case .number(_), .beta, .alpha: false
            default: true
            }
        case .blank: true
        }
    }
}

extension Version.Component {
    init?(parsing: String) {
        for nonNumeric in Self.nonNumerics {
            if parsing.lowercased() == nonNumeric.semantic.lowercased() {
                self = nonNumeric
                return
            }
        }
        
        if let number = UInt(parsing) {
            self = .number(number)
            return
        }
        
        return nil
    }
}

extension Version: Comparable {
    static func <(lhs: Self, rhs: Self) -> Bool {
        guard lhs != rhs else { return false }
        
        let count = max(lhs.components.count, rhs.components.count)
        for index in 0..<count {
            let lhsComponent = index < lhs.components.count ? lhs.components[index] : .blank
            let rhsComponent = index < rhs.components.count ? rhs.components[index] : .blank
            
            if lhsComponent < rhsComponent {
                return true
            }
        }
        
        return false
    }
}

struct VersionManager {
    enum FetchState {
        case initialized // Before first fetch
        case fetching
        case finished // Fetch succeed
        case failed // Fetch failed
        
        var idle: Bool {
            switch self {
            case .fetching:
                false
            case .initialized, .finished, .failed:
                true
            }
        }
    }
    
    fileprivate static var remoteVersion: Version = .app
    
    private static var task: URLSessionTask?
    
    static var fetchState: FetchState = .initialized
    
    static func fetchLatest() {
        task?.cancel()
        
        print("Started fetching latest version...")
        fetchState = .fetching
        
        task = URLSession.shared.dataTask(with: .releaseTags) { (data, response, error) in
            guard let data else { 
                fetchState = .failed
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let tags = json
                        .compactMap { element in
                            element["name"] as? String
                        }
                        .compactMap { Version(from: $0) }
                        .sorted(by: >)
                    
                    if let remote = tags.first, remote > .app {
                        VersionManager.remoteVersion = remote
                        print("Fetched latest version: \(remote.string)")
                    } else {
                        print("No newer version available.")
                    }
                    
                    fetchState = .finished
                }
            } catch {
                fetchState = .failed
                print(error.localizedDescription)
            }
        }
        task?.resume()
    }
}
