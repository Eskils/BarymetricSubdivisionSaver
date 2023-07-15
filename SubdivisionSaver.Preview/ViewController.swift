//
//  ViewController.swift
//  SubdivisionSaver.Preview
//
//  Created by Eskil Sviggum on 19/02/2023.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var screenSaverView: SubdivisionSaverView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        screenSaverView.startAnimation()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

