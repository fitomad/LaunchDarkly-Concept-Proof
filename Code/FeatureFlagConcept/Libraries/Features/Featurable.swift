//
//  Featurable.swift
//  FeatureFlagConcept
//
//  Created by Adolfo Vera Blasco on 31/1/22.
//

import Foundation

import LaunchDarkly;

/// Closure to check a flag in real time
public typealias FeatureChangeHandler = (_ oldStatus: Bool, _ newStatus: Bool) -> Void

/// Closure to check a collection of flags in real time
public typealias FeaturesChangeHandler = (_ flag: Flagable, _ oldStatus: Bool, _ newStatus: Bool) -> Void

public protocol Featurable {
    /**
        Current status for a flag
     
        - Parameter feature: Flags unique ID
     */
    func statusFor(feature flag: Flagable) -> Bool
    
    /**
        Real time tracking for a flag
     
        - Parameters:
            - flag: Flag unique ID
            - handler: Closure where client receive flag modifications
    */
    func trackFeature(flag: Flagable, handler: FeatureChangeHandler?)
    
    /**
        Real time tracking for a flags collection
     
        - Parameters:
            - flags: An array of flag unique ID
            - handler: Closure where client receive flag modifications
    */
    func trackFeatures(flags: [Flagable], handler: FeaturesChangeHandler?)
}
