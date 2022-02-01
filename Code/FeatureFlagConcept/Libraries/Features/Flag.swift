//
//  Flag.swift
//  FeatureFlagConcept
//
//  Created by Adolfo Vera Blasco on 31/1/22.
//

import Foundation

public enum Flag: String
{
    case blackFeature = "black-feature"
    case yellowFeature = "yellow-feature"
}

extension Flag: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension Flag: Flagable {
    public var name: String {
        return self.description
    }
}
