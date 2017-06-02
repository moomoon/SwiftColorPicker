//
//  ViewController.swift
//  ColorPicker
//
//  Created by moomoon on 01/06/2017.
//  Copyright © 2017 dr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var colorPicker: ColorPicker!
  override func viewDidLoad() {
    super.viewDidLoad()
    colorPicker.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), #colorLiteral(red: 0.4549019608, green: 0.2784313725, blue: 0.1843137255, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.2666666667, blue: 0.2392156863, alpha: 1), #colorLiteral(red: 0.9058823529, green: 0.1450980392, blue: 0.3960784314, alpha: 1), #colorLiteral(red: 0.6039215686, green: 0.1882352941, blue: 0.6862745098, alpha: 1), #colorLiteral(red: 0.4039215686, green: 0.2509803922, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.3294117647, blue: 0.6980392157, alpha: 1), #colorLiteral(red: 0.1725490196, green: 0.5960784314, blue: 0.9411764706, alpha: 1), #colorLiteral(red: 0.1215686275, green: 0.6666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.1254901961, green: 0.737254902, blue: 0.8274509804, alpha: 1), #colorLiteral(red: 0.09019607843, green: 0.5882352941, blue: 0.5333333333, alpha: 1), #colorLiteral(red: 0.3137254902, green: 0.6862745098, blue: 0.3333333333, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.7529411765, blue: 0.3215686275, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.9137254902, blue: 0.3098039216, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.5882352941, blue: 0.1490196078, alpha: 1), #colorLiteral(red: 0.9843137255, green: 0.3450980392, blue: 0.1882352941, alpha: 1)]
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

