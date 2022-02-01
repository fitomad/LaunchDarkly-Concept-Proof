//
//  ViewController.swift
//  FeatureFlagConcept
//
//  Created by Adolfo Vera Blasco on 31/1/22.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet private weak var labelBlackFeatureStatus: UILabel!
    @IBOutlet private weak var labelYellowFeatureStatus: UILabel!
    
    @IBOutlet private weak var viewBlackFeatureIndicator: UIView!
    @IBOutlet private weak var viewYellowFeatureIndicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
        
        let blackFlagStatus = LaunchDarklyManager.shared.statusFor(feature: Flag.blackFeature)
        self.manageBlackFeature(oldValue: blackFlagStatus, newValue: blackFlagStatus)
        
        let yellowFlagStatus = LaunchDarklyManager.shared.statusFor(feature: Flag.yellowFeature)
        self.manageYellowFeature(oldValue: yellowFlagStatus, newValue: yellowFlagStatus)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let flagsCollection = [ Flag.yellowFeature, Flag.blackFeature ]
        
        LaunchDarklyManager.shared.trackFeatures(flags: flagsCollection,
                                                 handler: self.handleFeatureChanged)
    }
    
    /**
        Prepare the UI elements
    */
    private func prepareUI() {
        [ viewBlackFeatureIndicator, viewYellowFeatureIndicator ].forEach({ indicator in
            indicator?.layer.cornerRadius = 15
            indicator?.backgroundColor = .systemYellow
        })
    }
    
    /**
        Closure to receive feature flags modifications.
    */
    private func handleFeatureChanged(flag: Flagable, oldValue: Bool, newValue: Bool) {
        guard let flagValue = Flag(rawValue: flag.name) else
        {
            return
        }
                
        switch(flagValue) {
            case .blackFeature:
                self.manageBlackFeature(oldValue: oldValue, newValue: newValue)
            case .yellowFeature:
                self.manageYellowFeature(oldValue: oldValue, newValue: newValue)
        }
    }

    
    private func manageBlackFeature(oldValue: Bool, newValue: Bool) {
        self.labelBlackFeatureStatus.text = "old: \(oldValue) new: \(newValue)"
        self.viewBlackFeatureIndicator.backgroundColor = newValue ? .systemGreen : .systemRed
    }
    
    private func manageYellowFeature(oldValue: Bool, newValue: Bool) {
        self.labelYellowFeatureStatus.text = "old: \(oldValue) new: \(newValue)"
        self.viewYellowFeatureIndicator.backgroundColor = newValue ? .systemGreen : .systemRed
    }
}

