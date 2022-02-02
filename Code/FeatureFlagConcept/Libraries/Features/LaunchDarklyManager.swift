//
//  FeatureManager.swift
//  FeatureFlagConcept
//
//  Created by Adolfo Vera Blasco on 31/1/22.
//

import Foundation

import LaunchDarkly

public class LaunchDarklyManager {
    /// Singleton
    public static let shared = LaunchDarklyManager()
    /// LaunchDarkly client
    private var darklyClient: LDClient?
    
    /**
        Configure the LaunchDarkly connection
    */
    private init() {
        let config = LDConfig(mobileKey: "mob-3bbfcc62-b811-4ad4-af0d-bdf730573264")
        
        LDClient.start(config: config)
        
        self.darklyClient = LDClient.get()
    }
    
    /**
        Adds support to segmentation
     
        - Parameter user: Contains all *filters* for this session
     */
    public func segmentationBy(user: User) {
        guard let darklyClient = self.darklyClient else
        {
            return
        }
        
        var launchDarlyUser = makeLDUser(from: user)
        
        darklyClient.identify(user: launchDarlyUser)
    }
    
    /**
        Convert an `User` struct to an expected `LDUser` struct
    */
    private func makeLDUser(from user: User) -> LDUser {
        var ldUser = LDUser()
        
        ldUser.name = user.name
        ldUser.email = user.email
        ldUser.country = user.country
        
        ldUser.device = user.device
        ldUser.operatingSystem = user.operatingSystem
        
        if let age = user.age {
            ldUser.custom = [
                "age" : age
            ]
        }
        
        return ldUser
    }
}

extension LaunchDarklyManager: Featurable {
    /**
        Tracks a flag un real time
    */
    public func trackFeature(flag: Flagable, handler: FeatureChangeHandler?) {
        guard let darklyClient = self.darklyClient else
        {
            return
        }
        
        darklyClient.observe(key: flag.name, owner: self) { changedFlag in
            guard let oldValue = changedFlag.oldValue as? Bool,
                  let newValue = changedFlag.newValue as? Bool
            else
            {
                return
            }
            
            if let handler = handler {
                handler(oldValue, newValue)
            }
        }
    }
    
    /**
        Tracks a collection of flags in real time
    */
    public func trackFeatures(flags: [Flagable], handler: FeaturesChangeHandler?) -> Void {
        guard let darklyClient = self.darklyClient else
        {
            return
        }
        
        let flagsDescriptions = flags.map({ $0.name })
        
        darklyClient.observe(keys: flagsDescriptions, owner: self) { changedFlags in
            changedFlags.keys.forEach({ key in
                guard let changedFlag = changedFlags[key],
                      let oldValue = changedFlag.oldValue as? Bool,
                      let newValue = changedFlag.newValue as? Bool
                else
                {
                    return
                }
                
                if let handler = handler,
                    let flag = Flag(rawValue: key)
                {
                    handler(flag, oldValue, newValue)
                }
            })
        }
    }
    
    /**
        Check flag current status 
     */
    public func statusFor(feature flag: Flagable) -> Bool {
        guard let darklyClient = self.darklyClient else
        {
            return false
        }
        
        let status = darklyClient.variation(forKey: flag.name, defaultValue: false)
        
        return status
    }
}
