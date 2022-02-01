//
//  Flagable.swift
//  FeatureFlagConcept
//
//  Created by Adolfo Vera Blasco on 1/2/22.
//

import Foundation

public protocol Flagable {
    /// The Feature flag unique ID
    var name: String { get }
}
