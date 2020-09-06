//
//  SceneDelegate.swift
//  Lidora
//
//  Created by Kerby Jean on 8/26/20.
//

import UIKit
import SweetCurtain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        setupRootViewController()
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    private func setupRootViewController() {
        
        let navigationController = UINavigationController(rootViewController:  MainViewController())
        let cardViewController = CardViewController()
                
        let curtainController = CurtainController(content: navigationController, curtain: cardViewController)
                
        curtainController.curtain.maxHeightCoefficient = 1.0
        curtainController.curtain.midHeightCoefficient = 0.3
        curtainController.curtain.minHeightCoefficient = 0.1
        
        curtainController.curtain.showsHandleIndicator = false
        
//        curtainController.curtainDelegate = entriesViewController
        curtainController.modalPresentationStyle = .fullScreen

        self.window?.rootViewController = curtainController
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

