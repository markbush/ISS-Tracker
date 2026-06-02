//
//  CrewMemberTableViewCell.swift
//  ISS Tracker
//
//  Created by Mark Bush on 09/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit

class CrewMemberTableViewCell: UITableViewCell {
  @IBOutlet weak var crewImageView: UIImageView! {
    didSet {
      crewImageView.backgroundColor = UIColor.clearColor()
      crewImageView.layer.cornerRadius = 0.8
      crewImageView.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var crewNameLabel: UILabel!
  @IBOutlet weak var flagImageView: UIImageView! {
    didSet {
      flagImageView.backgroundColor = UIColor.clearColor()
      flagImageView.layer.masksToBounds = true
      flagImageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
  }

}
