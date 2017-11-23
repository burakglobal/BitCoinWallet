//
//  TLColdWalletViewController.m
//  ArcBit
//
//  Created by Tim Lee on 3/18/15.
//  Copyright (c) 2015 ArcBit. All rights reserved.
//


//
//  TLColdWalletViewController.swift
//  ArcBit
//
//  Created by Timothy Lee on 3/14/15.
//  Copyright (c) 2015 Timothy Lee <stequald01@gmail.com>
//
//   This library is free software; you can redistribute it and/or
//   modify it under the terms of the GNU Lesser General Public
//   License as published by the Free Software Foundation; either
//   version 2.1 of the License, or (at your option) any later version.
//
//   This library is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//   Lesser General Public License for more details.
//
//   You should have received a copy of the GNU Lesser General Public
//   License along with this library; if not, write to the Free Software
//   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301  USA

import Foundation
import UIKit

@objc(TLColdWalletViewController) class TLColdWalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    struct STATIC_MEMBERS {
        static let kColdWalletSection = "kColdWalletSection"
        static let kColdWalletOverViewRow = "kColdWalletOverViewRow"
        static let kColdWalletCreateRow = "kColdWalletCreateRow"
        static let kColdWalletSpendtRow = "kColdWalletSpendtRow"

        static let kSeeHDWalletDataSection = "kSeeHDWalletDataSection"
        static let kSeeHDWalletDataRow = "kSeeHDWalletDataRow"
    }
    
    fileprivate var sectionArray: Array<String>?
    fileprivate var coldWalletRowArray: Array<String>?
    fileprivate var seeHDWalletDataRowArray: Array<String>?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet fileprivate var coldWalletTableView:UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
        setLogoImageView()
        
        self.navigationController!.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        if (TLPreferences.enabledAdvancedMode()) {
            self.sectionArray = [STATIC_MEMBERS.kColdWalletSection, STATIC_MEMBERS.kSeeHDWalletDataSection]
        } else {
            self.sectionArray = [STATIC_MEMBERS.kColdWalletSection]
        }
        self.coldWalletRowArray = [STATIC_MEMBERS.kColdWalletOverViewRow, STATIC_MEMBERS.kColdWalletCreateRow, STATIC_MEMBERS.kColdWalletSpendtRow]
        self.seeHDWalletDataRowArray = [STATIC_MEMBERS.kSeeHDWalletDataRow]

        
        self.coldWalletTableView!.delegate = self
        self.coldWalletTableView!.dataSource = self
        self.coldWalletTableView!.tableFooterView = UIView(frame:CGRect.zero)
    }
    
    override func viewDidAppear(_ animated:Bool) -> () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: TLNotificationEvents.EVENT_VIEW_COLD_WALLET_SCREEN()),
            object:nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender:Any!) -> () {
        if (segue.identifier == "SegueCreateColdWallet") {
            let vc = segue.destination
            vc.navigationItem.title = TLDisplayStrings.CREATE_COLD_WALLET_STRING()
        } else if (segue.identifier == "SegueSpendColdWallet") {
            let vc = segue.destination
            vc.navigationItem.title = TLDisplayStrings.AUTHORIZE_PAYMENT_STRING()
        } else if (segue.identifier == "SegueSpendColdWallet") {
            let vc = segue.destination
            vc.navigationItem.title = ""
        }
    }
    
    @IBAction fileprivate func menuButtonClicked(_ sender:UIButton) -> () {
        self.slidingViewController().anchorTopViewToRight(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        let sectionType = self.sectionArray![section]
        if(sectionType == STATIC_MEMBERS.kColdWalletSection) {
            return self.coldWalletRowArray!.count
        } else if(sectionType == STATIC_MEMBERS.kSeeHDWalletDataSection) {
            return self.seeHDWalletDataRowArray!.count
        }
        return 0
    }
    
    func numberOfSections(in tableView:UITableView) -> Int {
        return self.sectionArray!.count
    }
    
    func tableView(_ tableView:UITableView, titleForHeaderInSection section:Int) -> String? {
        let sectionType = self.sectionArray![section]
        if(sectionType == STATIC_MEMBERS.kColdWalletSection) {
            return TLDisplayStrings.COLD_WALLET_STRING()
        } else if(sectionType == STATIC_MEMBERS.kSeeHDWalletDataSection) {
            return TLDisplayStrings.SEE_INTERNAL_WALLET_DATA_STRING()
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell{
        let MyIdentifier = "ColdWalletCellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.default,
                reuseIdentifier:MyIdentifier)
        }
        let sectionType = self.sectionArray![(indexPath as NSIndexPath).section]
        if(sectionType == STATIC_MEMBERS.kColdWalletSection) {
            cell!.textLabel!.font = cell!.textLabel!.font.withSize(15)
            let row = self.coldWalletRowArray![(indexPath as NSIndexPath).row]
            if row == STATIC_MEMBERS.kColdWalletOverViewRow {
                cell!.textLabel!.text = TLDisplayStrings.COLD_WALLET_OVERVIEW_STRING()
            } else if row == STATIC_MEMBERS.kColdWalletCreateRow {
                cell!.textLabel!.text = TLDisplayStrings.CREATE_COLD_WALLET_STRING()
            } else if row == STATIC_MEMBERS.kColdWalletSpendtRow {
                cell!.textLabel!.text = TLDisplayStrings.AUTHORIZE_COLD_WALLET_ACCOUNT_PAYMENT_STRING()
            }
        } else if(sectionType == STATIC_MEMBERS.kSeeHDWalletDataSection) {
            let row = self.seeHDWalletDataRowArray![(indexPath as NSIndexPath).row]
            if row == STATIC_MEMBERS.kSeeHDWalletDataRow {
                cell!.textLabel!.text = TLDisplayStrings.SEE_INTERNAL_WALLET_DATA_STRING()
            }
        }

        return cell!
    }
    
    func tableView(_ tableView:UITableView, willSelectRowAt indexPath:IndexPath) -> IndexPath? {
        let sectionType = self.sectionArray![(indexPath as NSIndexPath).section]
        if(sectionType == STATIC_MEMBERS.kColdWalletSection) {
            let row = self.coldWalletRowArray![(indexPath as NSIndexPath).row]
            if row == STATIC_MEMBERS.kColdWalletOverViewRow {
                let msg = TLDisplayStrings.COLD_WALLET_OVERVIEW_DESC_STRING()
                TLPrompts.promtForOK(self, title:"", message: msg, success: {
                    () in
                })
            } else if row == STATIC_MEMBERS.kColdWalletCreateRow {
                performSegue(withIdentifier: "SegueCreateColdWallet", sender:self)
            } else if row == STATIC_MEMBERS.kColdWalletSpendtRow {
                performSegue(withIdentifier: "SegueSpendColdWallet", sender:self)
            }
        } else if(sectionType == STATIC_MEMBERS.kSeeHDWalletDataSection){
            let row = self.seeHDWalletDataRowArray![(indexPath as NSIndexPath).row]
            if row == STATIC_MEMBERS.kSeeHDWalletDataRow {
                performSegue(withIdentifier: "SegueSeeWalletData", sender:self)
            }
        }

        return nil
    }
}
