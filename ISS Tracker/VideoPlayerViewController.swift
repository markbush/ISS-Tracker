//
//  VideoPlayerViewController.swift
//  ISS Tracker
//
//  Created by Mark Bush on 31/03/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: AVPlayerViewController {
  var infoViewController: TrackingOverlayViewController?

  func playVideo() {
    let mediaURL = NSURL(string: "http://iphone-streaming.ustream.tv/ustreamVideo/17074538/streams/live/playlist.m3u8")!
    let asset = AVAsset(URL: mediaURL)
    
    let playerItem = AVPlayerItem(asset: asset)
    let titleMetaData = AVMutableMetadataItem()
    titleMetaData.locale = NSLocale.currentLocale()
    titleMetaData.key = AVMetadataCommonKeyTitle
    titleMetaData.keySpace = AVMetadataKeySpaceCommon
    titleMetaData.value = "ISS High Definition Earth Viewing System (HDEV)"
    let infoMetaData = AVMutableMetadataItem()
    infoMetaData.locale = NSLocale.currentLocale()
    infoMetaData.key = AVMetadataCommonKeyDescription
    infoMetaData.keySpace = AVMetadataKeySpaceCommon
    infoMetaData.value = "Black Image = ISS is on the night side of the Earth.\n" +
        "Image of sunset with words displayed = Switching between cameras, or communications with the ISS is not available.\n" +
        "Please note: The HDEV cycling of the cameras will sometimes be halted, causing the video to only show select camera feeds. This is handled by the HDEV team, and is only scheduled on a temporary basis. Nominal video will resume once the team has finished their scheduled event."
    playerItem.externalMetadata = [titleMetaData, infoMetaData]
    self.player = AVPlayer(playerItem: playerItem)

    self.player!.play()
  }

  func loadOverlay() {
    guard self.infoViewController == nil else { return }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let viewController = storyboard.instantiateViewControllerWithIdentifier("Tracking Overlay") as? TrackingOverlayViewController {
      self.infoViewController = viewController
      self.addChildViewController(viewController)
      let bounds = self.view.bounds
      viewController.view.frame = CGRect(x: 20, y: bounds.height - 136, width: bounds.width - 40, height: 128)
      viewController.view.alpha = 0.85
      self.view.addSubview(viewController.view)
      viewController.didMoveToParentViewController(self)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadOverlay()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.playVideo()

  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.player?.pause()
    self.player = nil
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
