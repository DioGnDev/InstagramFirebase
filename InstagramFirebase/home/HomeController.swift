//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Ilham Hadi Prabawa on 4/3/19.
//  Copyright © 2019 Codenesia. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    let cellId = "cellId"
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl

        setupNavigationItem()
        fetchAllPosts()
    }
    
    @objc fileprivate func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc fileprivate func handleRefresh(){
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts(){
        fetchPosts()
        fetchFollowingIdsPosts()
    }
    
    fileprivate func setupNavigationItem(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc fileprivate func handleCamera(){
        let cameraControl = CameraController()
        self.present(cameraControl, animated: true, completion: nil)
    }
    
    fileprivate func fetchFollowingIdsPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let followingIdsDictionary = snapshot.value as? [String: Any] else { return }
            followingIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWith(uid: key, completion: { user in
                    self.fetchPostsWith(with: user)
                })
            })
        }) { err in
            print("Failed to fetch following posts", err)
        }
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWith(uid: uid) { (user) in
            self.fetchPostsWith(with: user)
        }
    }
    
    fileprivate func fetchPostsWith(with user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (snapshot, text) in
            
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                self.posts.insert(post, at: 0)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch posts \(error)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 80
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        if posts.count > 0 {
            cell.post = posts[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
    //MARK: Cell Custom Delegate
    func didTapComment(post: Post) {
        let commentsController = CommentsController.init(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        self.navigationController?.pushViewController(commentsController, animated: true)
    }

}
