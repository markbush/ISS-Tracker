//
//  CrewTableViewController.swift
//  ISS Tracker
//
//  Created by Mark Bush on 09/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit

class CrewTableViewController: UITableViewController {
  var crewList = [CrewMember]()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    let alekseyOvchinin = CrewMember(name: "Aleksey Ovchinin", nationality: "Russian", twitterHandle: nil, imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Aleksey_Ovchinin.jpg/800px-Aleksey_Ovchinin.jpg", arrives: NSDate(dateString: "18-03-2016"), departs: NSDate(dateString: "04-09-2016"))
    let jeffreyWilliams = CrewMember(name: "Jeff Williams", nationality: "American", twitterHandle: "Astro_Jeff", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Jeffrey_N._Williams_2009.jpg/800px-Jeffrey_N._Williams_2009.jpg", arrives: NSDate(dateString: "18-03-2016"), departs: NSDate(dateString: "04-09-2016"))
    let olegSkripochka = CrewMember(name: "Oleg Skripochka", nationality: "Russian", twitterHandle: nil, imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Oleg_Skripochka.jpg/800px-Oleg_Skripochka.jpg", arrives: NSDate(dateString: "18-03-2016"), departs: NSDate(dateString: "04-09-2016"))
    let timKopra = CrewMember(name: "Tim Kopra", nationality: "American", twitterHandle: "astro_tim", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/TimotyKorpav2.jpg/800px-TimotyKorpav2.jpg", arrives: NSDate(dateString: "15-12-2015"), departs: NSDate(dateString: "18-06-2016"))
    let timPeake = CrewMember(name: "Tim Peake", nationality: "British", twitterHandle: "astro_timpeake", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Timothy_Peake%2C_official_portrait.jpg/800px-Timothy_Peake%2C_official_portrait.jpg", arrives: NSDate(dateString: "15-12-2015"), departs: NSDate(dateString: "18-06-2016"))
    let yuriMalenchenko = CrewMember(name: "Yuri Malenchenko", nationality: "Russian", twitterHandle: nil, imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/YuriMalenchenko.jpg/800px-YuriMalenchenko.jpg", arrives: NSDate(dateString: "15-12-2015"), departs: NSDate(dateString: "18-06-2016"))
    crewList = [CrewMember.issItem, alekseyOvchinin, jeffreyWilliams, olegSkripochka, timKopra, timPeake, yuriMalenchenko]
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return crewList.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Crew Member", forIndexPath: indexPath) as! CrewMemberTableViewCell

    let crewMember = crewList[indexPath.row]
    cell.crewNameLabel?.text = crewMember.name
    if let nationality = crewMember.nationality,
      let flagImage = UIImage(named: nationality) {
      cell.flagImageView?.image = flagImage
    }
    if let imageUrl = crewMember.imageUrl {
      let queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
      dispatch_async(queue, {
        if let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!) {
          dispatch_async(dispatch_get_main_queue()) {
            cell.crewImageView?.image = UIImage(data: imageData)
          }
        }
      })
    }

    return cell
  }

  /*
   // Override to support conditional editing of the table view.
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */

  /*
   // Override to support editing the table view.
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   if editingStyle == .Delete {
   // Delete the row from the data source
   tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
   } else if editingStyle == .Insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */

  /*
   // Override to support rearranging the table view.
   override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

   }
   */

  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */

   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      switch identifier {
        case "Show Crew Member":
          if let cell = sender as? UITableViewCell,
            let indexPath = self.tableView.indexPathForCell(cell),
            let crewMemberViewController = segue.destinationViewController as? CrewMemberViewController {
            crewMemberViewController.crewMember = crewList[indexPath.row]
          }
        default: break
      }
    }
   }

}
