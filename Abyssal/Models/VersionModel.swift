//
//  VersionModel.swift
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
        
        var nonNumeric: Bool {
            switch self {
            case .number(_), .blank: false
            case .beta, .alpha, .patch: true
            }
        }
        
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
                "<blank>"
            }
        }
        
        var separator: String {
            nonNumeric ? "-" : "."
        }
    }
    
    var components: [Component]
    
    var string: String {
        components
            .reduce("") { result, component in
                if result.isEmpty {
                    component.semantic
                } else {
                    result + component.separator + component.semantic
                }
            }
    }
    
    static var empty: Version = .init(components: [])
    static var app: Version {
        .init(from: Bundle.main.appVersion) ?? .empty
    }
    static var remote: Version {
        VersionModel.shared.fetchedRemoteVersion
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
            case .beta, .alpha, .patch, .blank: false
            }
        case .beta:
            switch rhs {
            case .number(_), .blank: true
            case .beta, .alpha, .patch: false
            }
        case .alpha:
            switch rhs {
            case .number(_), .beta, .blank: true
            case .alpha, .patch: false
            }
        case .patch:
            switch rhs {
            case .number(_), .beta, .alpha, .patch, .blank: false
            }
        case .blank:
            switch rhs {
            case .number(_): true
            case .beta, .alpha, .patch, .blank: false
            }
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
    
    static var iterables: [Self] {
        [.beta, .alpha, .patch, .blank]
    }
    
    static var nonNumerics: [Self] {
        iterables.filter(\.nonNumeric)
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
            } else if lhsComponent > rhsComponent {
                return false
            }
            
            // Two components are equal, continue
        }
        
        return false
    }
}

@Observable
class VersionModel {
    static var shared = VersionModel()
    
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
    
    fileprivate var fetchedRemoteVersion: Version = .app
    
    private var task: URLSessionTask?
    
    var fetchState: FetchState = .initialized
    
    var empty: Version {
        .empty
    }
    
    var app: Version {
        .app
    }
    
    var remote: Version {
        fetchedRemoteVersion
    }
    
    var hasUpdate: Bool {
        Version.hasUpdate
    }
    
    func fetchLatest() {
        task?.cancel()
        
        print("Started fetching latest version...")
        fetchState = .fetching
        
        task = URLSession.shared.dataTask(with: .releaseTags) { (data, response, error) in
            guard let data else { 
                self.fetchState = .failed
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
                        self.fetchedRemoteVersion = remote
                        print("Fetched latest version: \(remote.string)")
                        print(self.app < self.remote)
                    } else {
                        print("No newer version available.")
                    }
                    
                    self.fetchState = .finished
                }
            } catch {
                self.fetchState = .failed
                print(error.localizedDescription)
            }
        }
        task?.resume()
    }
}
