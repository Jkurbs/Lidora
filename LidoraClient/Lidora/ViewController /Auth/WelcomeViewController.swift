//
//  WelcomeViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/15/20.
//

import UIKit
import AVFoundation
import Foundation


class WelcomeViewController: UIViewController {
    
    var label = UILabel()
    var descriptionLabel = UILabel()
    let signUpButton = LoadingButton()
    let loginButton = UIButton()
    
    var authChoice = AuthChoice.login
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        avPlayer.pause()
        paused = true
    }
    
    
    func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        let theURL = Bundle.main.url(forResource:"chef", withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        label.textColor = .white
        label.text = "Welcome to Lidora"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Affordable healthy meals cooked by a chef\nnear you delivered to your door!"
        descriptionLabel.numberOfLines = 4
        descriptionLabel.textAlignment = .left
        descriptionLabel.sizeToFit()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signUpButton)
        signUpButton.enable()
        signUpButton.setTitle("Sign up with email", for: .normal)
        signUpButton.addTarget(self, action: #selector(self.goToSignUp), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.backgroundColor = .systemGreen
        
        view.addSubview(loginButton)
        loginButton.setTitle("Already have an account? Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginButton.addTarget(self, action: #selector(self.goToLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80.0),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0),
            descriptionLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -16.0),
            
            signUpButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32.0),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50.0),
            
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32.0),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }
    
    @objc func goToSignUp() {
        let vc = AuthViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        vc.authChoice = .register
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func goToLogin() {
        let vc = AuthViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        vc.authChoice = .login
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: .zero)
    }
}
