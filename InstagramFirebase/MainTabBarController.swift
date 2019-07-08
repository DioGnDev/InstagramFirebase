//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Ilham Hadi Prabawa on 3/27/19.
//  Copyright © 2019 Codenesia. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
    
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController.init(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            self.present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.isNavigationBarHidden = true
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewController()
    }

    func setupViewController(){
        
        let homeLayout = UICollectionViewFlowLayout()
        let homeController = HomeController.init(collectionViewLayout: homeLayout)
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: homeController)
        
        let userSearchController = UserSearchController.init(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: userSearchController)
        
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        let likeController = LikeController.init(collectionViewLayout: UICollectionViewFlowLayout())
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: likeController)
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileViewController.init(collectionViewLayout: layout)
        let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: userProfileController)
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                        searchNavController,
                        plusNavController,
                        likeNavController,
                        userProfileNavController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController:
        UIViewController? = UIViewController()) -> UINavigationController {
        var navController = UINavigationController(rootViewController: UIViewController())
        if let rootViewController = rootViewController {
            navController = UINavigationController(rootViewController: rootViewController)
        }
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        return navController
    }
}
