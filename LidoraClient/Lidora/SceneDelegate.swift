//
//  SceneDelegate.swift
//  Lidora
//
//  Created by Kerby Jean on 8/26/20.
//

import UIKit
import FirebaseAuth
import SweetCurtain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?
    var locationService = LocationService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        print("SCENE")
        observeAuthorisedState()
        locationService.requestLocation()
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    
    func observeAuthorisedState() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user == nil {
                self.setupRootViewController(viewController: WelcomeViewController())
            } else {
                // Fetch user
                guard let user = user else { return }
                DataService.shared.fetchUser(userId: user.uid) { (user, error) in
                    if let error = error {
                        print("Error: ", error)
                    } else {
                        let mainViewController = MainViewController()
                        mainViewController.user = user
                        self.locationService.locationView = mainViewController.locationView
                        let navigationController = UINavigationController(rootViewController: mainViewController)
                        let cardViewController = CardViewController()
                        let cardNavigationController = UINavigationController(rootViewController:  cardViewController)

                        cardViewController.user = user
                                
                        let curtainController = CurtainController(content: navigationController, curtain: cardNavigationController)
                                
                        curtainController.curtain.maxHeightCoefficient = 0.95
                        curtainController.curtain.midHeightCoefficient = 0.5
                        curtainController.curtain.minHeightCoefficient = 0.12

                        curtainController.curtain.handleIndicatorColor = .lightGray
                        curtainController.curtain.showsHandleIndicator = true
                        curtainController.curtain.bottomBounce = false
                        curtainController.curtain.topBounce = false
                        curtainController.curtainDelegate = cardViewController
                        curtainController.modalPresentationStyle = .fullScreen
                        
                        self.window?.rootViewController = curtainController
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
            Auth.auth().removeStateDidChangeListener(self.handle!)
        }
    }
    
    private func setupRootViewController(viewController: UIViewController) {
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

