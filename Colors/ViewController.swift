
//  ViewController.swift
//  Colors
//
//  Created by Pavel Kostin on 20.05.2024.


import UIKit

class ViewController: UIViewController {
    
    
    private var buttons: [UIButton] = []
    private let lable = UILabel()
    private var maxButtons = 6
    private let addButton = UIButton()
    private let banner = UIView()
    private let picker = UIColorPickerViewController()
    private var currentButton: UIButton?
    private var segmentetControll = UISegmentedControl()
    private var color1: UIColor?
    private var color2: UIColor?
    private var color3: UIColor?
    private var color4: UIColor?
    private var color5: UIColor?
    private var color6: UIColor?
    
    // MARK: - Update view for switch language
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchLanguage()
        
    }
    
    // MARK: - Setup text for switch language
    
    func switchLanguage() {
        lable.text = "color".translated()
        addButton.setTitle("addColor".translated(), for: .normal)
        
        guard currentButton != nil else { return }
        
        
        for button in buttons {
            if let colorName = getColorName(from: button.backgroundColor ?? .clear) {
                button.setTitle(colorName.translated(), for: .normal)
            } else {
                button.setTitle("custom".translated(), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: - ColorPicker Delegate
        picker.delegate = self
        
        // MARK: - Call functions
        setupBanner()
        setupLable()
        setupSegmented()
        setupAddButton()
        setupFirstButton()
        setupConstraint()
        
        // MARK: - Observer
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(updateConstraints),
                                                name: UIDevice.orientationDidChangeNotification,
                                                object: nil)
        
    }
    
    // MARK: - Constraint for banner and lable for banner
    private func bannerConstraints() {
        if UIDevice.current.orientation.isPortrait {
            banner.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            
        } else {
            banner.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        }
        NSLayoutConstraint.activate([
            banner.heightAnchor.constraint(equalToConstant: 80),
            lable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lable.bottomAnchor.constraint(equalTo: banner.topAnchor, constant: -10),
            segmentetControll.leadingAnchor.constraint(equalTo: banner.leadingAnchor),
            segmentetControll.bottomAnchor.constraint(equalTo: banner.topAnchor, constant: -5)
        ])
    }
    
    private func setupSegmented() {
        let titles = ["Eng", "Rus"]
        segmentetControll = UISegmentedControl(items: titles)
        segmentetControll.selectedSegmentIndex = 0
        segmentetControll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentetControll)
        segmentetControll.addTarget(self, action: #selector(targetForSegmented), for: .valueChanged)
    }
    
    // MARK: - Setup lable
    private func setupLable() {
        lable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lable)
    }
    
    // MARK: - Setup addButton and add on view
    private func setupAddButton() {
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .lightGray
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 10
        addButton.layer.borderColor = .init(gray: 0.5, alpha: 0.5)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTarget), for: .touchUpInside)
        addButton.makeSystem(addButton)
    }
    
    // MARK: - Setup banner and add on view
    private func setupBanner() {
        banner.layer.borderWidth = 1
        banner.layer.borderColor = .init(gray: 0.5, alpha: 0.5)
        banner.layer.cornerRadius = 10
        banner.backgroundColor = .clear
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
    }
    
    // MARK: - Setup all buttons and settings target
    private func setupForAllButtons() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = .init(gray: 0.5, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addPicker1), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.makeSystem(button)
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    // MARK: - Setup first button
    private func setupFirstButton() {
        let button = setupForAllButtons()
        buttons.append(button)
        view.addSubview(button)
    }
    
    // MARK: - Reload constraints
    private func setupConstraint() {
        NSLayoutConstraint.deactivate(view.constraints)
        
        bannerConstraints()
        
        let allButtons = buttons + [addButton]
        
        if UIDevice.current.orientation.isLandscape {
            makeLandscapeConstraint(for: allButtons)
        } else {
            makePortraintConstraint(for: allButtons)
        }
    }
    
    // MARK: - Setup constraints for Portrait
    private func makePortraintConstraint(for buttons: [UIButton]) {
        var previousButton: UIButton?
        var firstButtonInRow: UIButton?
        
        for (index, button) in buttons.enumerated() {
            if index % 2 == 0 {
                button.topAnchor.constraint(equalTo: previousButton?.bottomAnchor ?? banner.bottomAnchor, constant: 16).isActive = true
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
                firstButtonInRow = button
                
                if let firstButton = firstButtonInRow, let previous = previousButton {
                    previous.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
                }
            } else {
                button.topAnchor.constraint(equalTo: previousButton?.topAnchor ?? banner.bottomAnchor).isActive = true
                button.leadingAnchor.constraint(equalTo: previousButton?.trailingAnchor ?? view.trailingAnchor, constant: 16).isActive = true
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
                previousButton?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            }
            previousButton = button
            button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
    }
    
    // MARK: - Setup constraints for Landscape
    private func makeLandscapeConstraint(for buttons: [UIButton]) {
        
        var previousButton: UIButton?
        var firstButtonInRow: UIButton?
        
        for (index, button) in buttons.enumerated() {
            if index % 2 == 0 {
                button.topAnchor.constraint(equalTo: previousButton?.bottomAnchor ?? banner.bottomAnchor, constant: 8).isActive = true
                button.leadingAnchor.constraint(equalTo: banner.leadingAnchor).isActive = true
                firstButtonInRow = button
                
                if let firstButton = firstButtonInRow, let previous = previousButton {
                    previous.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
                }
            } else {
                button.topAnchor.constraint(equalTo: previousButton?.topAnchor ?? banner.bottomAnchor).isActive = true
                button.leadingAnchor.constraint(equalTo: previousButton?.trailingAnchor ?? view.trailingAnchor, constant: 16).isActive = true
                button.trailingAnchor.constraint(equalTo: banner.trailingAnchor).isActive = true
                previousButton?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            }
            previousButton = button
            button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
    }
}


// MARK: - Delegate
extension ViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let currentButton = currentButton else { return }
        
        if let index = buttons.firstIndex(of: currentButton) {
            switch index {
            case 0: color1 = viewController.selectedColor
            case 1: color2 = viewController.selectedColor
            case 2: color3 = viewController.selectedColor
            case 3: color4 = viewController.selectedColor
            case 4: color5 = viewController.selectedColor
            case 5: color6 = viewController.selectedColor
            default: break
            }
        }
        
        currentButton.backgroundColor = viewController.selectedColor
        
        if let colorName = getColorName(from: viewController.selectedColor) {
            currentButton.setTitle(colorName.translated(), for: .normal)
        } else {
            currentButton.setTitle("custom".translated(), for: .normal)
        }
        
        
        banner.backgroundColor = blendColors(color1: color1, color2: color2, color3: color3, color4: color4, color5: color5, color6: color6)
    }
}

// MARK: - Objc func for target

extension ViewController {
    
    // MARK: - Add button target
    @objc func addButtonTarget() {
        let newButton = setupForAllButtons()
        buttons.append(newButton)
        view.addSubview(newButton)
        
        if buttons.count >= maxButtons {
            addButton.isHidden = true
        }
        setupConstraint()
    }
    
    // MARK: - Add picker target
    @objc func addPicker1(_ sender: UIButton) {
        
        currentButton = sender
        picker.supportsAlpha = true
        picker.modalPresentationStyle = .popover
        self.present(picker, animated: true)
    }
    
    // MARK: - Update constraints
    @objc func updateConstraints() {
        setupConstraint()
    }
    
    @objc func targetForSegmented() {
        if segmentetControll.selectedSegmentIndex == 0 {
            localizedDefaultLanguage = "en"
            UserDefaults.standard.setValue(localizedDefaultLanguage, forKey: localizedDefaultKey)
        } else {
            localizedDefaultLanguage = "ru"
            UserDefaults.standard.setValue(localizedDefaultLanguage, forKey: localizedDefaultKey)
        }
        switchLanguage()
    }
}



