//
//  ViewController.swift
//  NeumorphicButton
//
//  Created by Jesse Seidman on 2/19/20.
//  Copyright © 2020 Jesse Seidman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    self.view.backgroundColor = NeumorphicButton.defaultColor
    let sideLength: CGFloat = 150

    let button = NeumorphicButton(
      frame: CGRect(
        x: self.view.frame.midX - (sideLength / 2),
        y: self.view.frame.midY - (sideLength / 2),
        width: sideLength,
        height: sideLength
      )
    )

    self.view.addSubview(button)
  }


}

