//
//  instructionViewController.swift
//  Demo1
//
//  Created by Yiting Wang on 20/04/2018.
//  Copyright © 2018 COMP208. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet var pageControll: UIPageControl!
	@IBOutlet var scrollView: UIScrollView!
	
	var contentWidth: CGFloat = 0.0
	
	override func viewDidLoad() {
        super.viewDidLoad()
		scrollView.delegate = self
		
		for image in 0...4 {
			let imageToDisplay = UIImage(named: "\(image).png")
			let imageView = UIImageView(image: imageToDisplay)
			
			let xCoordinate = 0 + view.frame.width * CGFloat(image)
			contentWidth += view.frame.width
			imageView.sizeToFit()
			scrollView.addSubview(imageView)
			imageView.frame = CGRect(x: xCoordinate, y: 20, width: (imageToDisplay?.size.width)!, height: (imageToDisplay?.size.height)!)
		}
		scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
    }
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		pageControll.currentPage = Int(scrollView.contentOffset.x / CGFloat(375))
		if (scrollView.contentOffset.x > 375 * 2) {
			self.performSegue(withIdentifier: "InstructionFinished", sender: self)

		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
