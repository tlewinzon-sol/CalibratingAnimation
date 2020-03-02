//
//  ViewController.swift
//  AnimationsSpike
//
//  Created by Tobias Lewinzon on 28/02/2020.
//  Copyright © 2020 tobiaslewinzon. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var calibratingLabel: UILabel!
    
    private var displayLink: CADisplayLink?
    
    // Instantiate AnimationView()
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get animation from JSON and configure the animationView
        let animation = Animation.named("1808-scaling-loader")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        
        // Handle animation
        animationView.play()
        animationView.loopMode = .loop
        
        view.addSubview(animationView)
        
        // SnapKit is a very intuitive way for making constraints programmatically, my personal favorite.
        animationView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(200)
        }
        
        // Observing when the app is back on foreground
        NotificationCenter.default.addObserver(self, selector: #selector(backOnForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Setup CADisplayLink
        setupCADisplayLink()
        
        // Stop label animation after a few seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.stopLabelAnimation()
        }
    }
    
    @objc func backOnForeground() {
        animationView.play()
    }
    
    // CADisplayLink is a class which calls a selector every time the screen is updated.
    /// preferredFramesPerSecond: translates to how many times per second you wish to notify the selector
    func setupCADisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(generateDots))
        displayLink?.add(to: .main, forMode: .common)
        displayLink?.preferredFramesPerSecond = 3
    }
    
    // Add one dot to the string until it contains "...", then remove them
    @objc func generateDots() {
        guard var text = calibratingLabel.text else { return }
        if !text.contains("...") {
            text = text.appending(".")
        } else {
            text = "Calibrating"
        }
        calibratingLabel.text = text
    }
    
    func stopLabelAnimation() {
        displayLink?.invalidate()
        calibratingLabel.text = "Calibrated!"
    }
    
    
}

