//
//  FieldRect.swift
//  Lidora
//
//  Created by Kerby Jean on 9/14/20.
//

import UIKit 

class FieldRect: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 15, dy: 0)
    }
}

extension UITextField {
    
    func setBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.font = UIFont.systemFont(ofSize: 14)
        backgroundColor = .systemGray6
    }
    
    func setPlaceHolderColor(_ placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
}
