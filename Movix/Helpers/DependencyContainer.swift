//
//  DependencyContainer.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

final class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    private var registry: [ObjectIdentifier: Any] = [:]
    
    private init() {}
    
    func register<T>(type: T.Type, object: T) {
        let identifier = ObjectIdentifier(type)
        registry[identifier] = object
    }
    
    func resolve<T>() -> T? {
        let identifier = ObjectIdentifier(T.self)
        return registry[identifier] as? T
    }
    
}
