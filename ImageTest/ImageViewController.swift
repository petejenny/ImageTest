//
//  ImageViewController.swift
//  ImageTest
//
//  Created by Peter Forward on 3/23/19.
//  Copyright © 2019 Peter Forward. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
            
        }
    }
    
    // MARKL Private Implementation
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    private func fetchImage() {
        if let url = imageURL {
            // this next line of code can throw an error
            // and it also will block the UI entirely while accessing the network
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data:imageData)
                    }
                    
                } 
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        // Set the imageURL for testing
        //imageURL = URL(string: "http://www-media.stanford.edu/wp-content/uploads/2017/03/24182714/about_landing-1.jpg")
        
        spinner.center = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
        
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    private var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
}

extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
