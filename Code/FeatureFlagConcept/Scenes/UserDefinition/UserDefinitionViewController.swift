//
//  UserDefinitionViewController.swift
//  FeatureFlagConcept
//
//  Created by Adolfo Vera Blasco on 2/2/22.
//

import UIKit
import Foundation

internal class UserDefinitionViewController: UIViewController {
    @IBOutlet private weak var textfieldName: UITextField!
    @IBOutlet private weak var textfieldEmail: UITextField!
    @IBOutlet private weak var textfieldCountry: UITextField!
    @IBOutlet private weak var sliderAge: UISlider!
    @IBOutlet private weak var labelAge: UILabel!
    @IBOutlet private weak var segmentDevice: UISegmentedControl!
    @IBOutlet private weak var textfieldOperatingSystem: UITextField!
    
    ///
    private var user = User()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
    }
    
    private func prepareUI() {
        self.textfieldName.delegate = self
        self.textfieldEmail.delegate = self
        self.textfieldCountry.delegate = self
        self.textfieldOperatingSystem.delegate = self
        
        self.segmentDevice.addTarget(self, action: #selector(segmentDeviceValueChanged(_ :)), for: .valueChanged)
    }
    
    //
    // MARK: - Actions -
    //
    
    @IBAction private func sliderAgeValueChanged(_ sender: UISlider) {
        let age = Int(sender.value)
        
        self.labelAge.text = "\(age)"
        
        self.user.age = age
    }
    
    @IBAction private func testButtonTap(_ sender: UIButton) {
        prepareFeatureManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "FeaturesViewController") as? FeaturesViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }    
    }
    
    @objc private func segmentDeviceValueChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                user.device = "iOS"
            case 1:
                user.device = "Android"
            case 2:
                user.device = "Web"
            default:
                user.device = "Unknown"
        }
    }
    
    private func prepareFeatureManager() {
        LaunchDarklyManager.shared.segmentationBy(user: user)
    }
}

extension UserDefinitionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === self.textfieldName {
                user.name = textField.text
        } else if textField === self.textfieldEmail {
                user.email = textField.text
        } else if textField === self.textfieldCountry {
                user.country = textField.text
        } else if textField === self.textfieldOperatingSystem {
                user.operatingSystem = textField.text
        }
    }
}
