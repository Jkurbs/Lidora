//
//  CardViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit
import SweetCurtain

class CardViewController: UIViewController {
    
    let emptyView = EmptyView()
    var cardButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.systemBackground
        
        cardButton.setTitle("View Bag - 1", for: .normal)
        cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        cardButton.setTitleColor(.darkText, for: .normal)
        cardButton.frame = CGRect(x: 0, y: 5, width: view.frame.width, height: 60)
        cardButton.addTarget(self, action: #selector(handleCardButton), for: .touchUpInside)
        view.addSubview(cardButton)
        view.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    @objc func handleCardButton() {
        self.curtainController?.moveCurtain(to: .max, animated: true)
    }
}

// MARK: - CurtainDelegate
extension CardViewController: CurtainDelegate {
    
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState) {
        switch heightState {
        
        case .min:
            emptyView.isHidden = true
        case .mid:
            emptyView.isHidden = false
        case .max:
            emptyView.isHidden = false
        default:
            break
        }
    }
    
    func curtainDidDrag(_ curtain: Curtain) {
       
    }
}
