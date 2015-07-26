//
//  DetailViewController.swift
//  HowToCustomAnimateCellHeight
//
//  Created by luca silvestro on 26/07/15.
//  Copyright (c) 2015 luca silvestro. All rights reserved.
//  luca.silvestro@gmail.com

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var blurredView: UIVisualEffectView!
    @IBAction func clickedButton(sender: UIButton) {
        self.buttonCLickedCompletion()
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var fakeCellLabel: UILabel!
    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var dismissIcon: UIButton!
    @IBOutlet var viewcontainer: UIView!
    var buttonCLickedCompletion:(Void)->Void

    
    required init(coder aDecoder: NSCoder) {
        self.buttonCLickedCompletion = {Void in Void}
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("title passed: \(title)")
        self.fakeCellLabel.text = title
        self.titleLabel.text = title
        self.opacityView.setTranslatesAutoresizingMaskIntoConstraints(true)
        let image = UIImage.imageWithIonIcon(.chevron_down, height: 22, color: UIColor.blueColor())
        dismissIcon.setImage(image, forState: UIControlState.Normal)
        dismissIcon.setTitle("", forState: UIControlState.Normal)
    }
}
