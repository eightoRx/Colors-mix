//
//  Extension.swift
//  Colors
//
//  Created by Pavel Kostin on 23.05.2024.
//

import Foundation
import UIKit

let localizedDefaultKey = "localizedDefaultKey"
var localizedDefaultLanguage = "en"

// MARK: - Animation for button

 extension UIButton {
    func makeSystem(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn), for: [
            .touchDown,
            .touchDragInside
        ])
        
        button.addTarget(self, action: #selector(handleOut), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) { self.alpha = 0.55 }
    }
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.15) { self.alpha = 1 }
    }
}


// MARK: - Extension ViewController

 extension ViewController {
    
    // MARK: - Mixed colors
    
    func blendColors(color1: UIColor? = nil, color2: UIColor? = nil, color3: UIColor? = nil, color4: UIColor? = nil, color5: UIColor? = nil, color6: UIColor? = nil) -> UIColor {
        
        var colors: Array<UIColor> = []
        
        if let color = color1 { colors.append(color) }
        if let color = color2 { colors.append(color) }
        if let color = color3 { colors.append(color) }
        if let color = color4 { colors.append(color) }
        if let color = color5 { colors.append(color) }
        if let color = color6 { colors.append(color) }
        
        let countColors = CGFloat(colors.count)
        
        var (sumR, sumG, sumB, sumA) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        for color in colors {
            var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            sumR += r
            sumG += g
            sumB += b
            sumA += a
        }
        
        return UIColor(red: sumR / countColors, green: sumG / countColors, blue: sumB / countColors, alpha: sumA / countColors)
    }
    
    // MARK: - Make color name for title button
    
    func getColorName(from color: UIColor) -> String? {
        let ciColor = CIColor(color: color)
        
        let colorNames: [String: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)] = [
            "red".translated(): (1, 0, 0, 1),
            "green".translated(): (0, 1, 0, 1),
            "blue".translated(): (0, 0, 1, 1),
            "yellow".translated(): (1, 1, 0, 1),
            "black".translated(): (0, 0, 0, 1),
            "white".translated(): (1, 1, 1, 1),
            "gray".translated(): (0.5, 0.5, 0.5, 1),
            "cyan".translated(): (0, 1, 1, 1),
            "magenta".translated(): (1, 0, 1, 1),
            "orange".translated(): (1, 0.5, 0, 1),
            "purple".translated(): (0.5, 0, 0.5, 1),
            "brown".translated(): (0.6, 0.4, 0.2, 1)
        ]
        
        // MARK: - To compare to colors
        
        for (name, components) in  colorNames {
            if isSimilar(r1: ciColor.red, g1: ciColor.green, b1: ciColor.blue, a1: ciColor.alpha, r2: components.r, g2: components.g, b2: components.b, a2: components.a) {
                return name
            }
        }
        return nil
    }
    
    // MARK: - Compare two colors
    
    func isSimilar(r1: CGFloat, g1: CGFloat, b1: CGFloat, a1: CGFloat, r2: CGFloat, g2: CGFloat, b2: CGFloat, a2: CGFloat) -> Bool {
        return abs(r1 - r2) <= 0.01 &&
        abs(g1 - g2) <= 0.01 &&
        abs(b1 - b2) <= 0.01 &&
        abs(a1 - a2) <= 0.01
    }
}

// MARK: - Extension string translated

extension String {
    func translated() -> String {
        if let path = Bundle.main.path(forResource: localizedDefaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return ""
    }
}
