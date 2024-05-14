//
//  Future.swift
//  AmityUIKit
//
//  Created by Mateusz Nadolski on 14/05/2024.
//  Copyright © 2024 Amity. All rights reserved.
//

import Combine
import Foundation

extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
