//
//  TextFieldCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/14/20.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    var textField = FieldRect()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tertiarySystemGroupedBackground
        textField.frame = contentView.frame
        textField.textColor = .label
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(placeholder: String) {
        textField.placeholder = placeholder
    }
}
