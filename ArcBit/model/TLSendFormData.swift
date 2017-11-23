//
//  TLSendFormData.swift
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

enum TLSelectObjectType:Int {
    case unknown       = 0
    case account       = 1
    case address       = 2
}

class TLSendFormData {
    struct STATIC_MEMBERS{
        static var _instance:TLSendFormData? = nil
    }
    
    var useAllFunds = false
    var beforeSendBalance: TLCoin? = nil
    var fromLabel:String?
    fileprivate var address:String?
    fileprivate var amount:String?
    fileprivate var fiatAmount:String?

    var toAmount:TLCoin?
    var feeAmount:TLCoin?

    class func instance() -> (TLSendFormData) {
        if(STATIC_MEMBERS._instance == nil) {
            STATIC_MEMBERS._instance = TLSendFormData()
        }
        return STATIC_MEMBERS._instance!
    }
    
    init() {
        self.address = nil
        self.amount = nil
        self.fiatAmount = nil
    }
    
    func setAddress(_ address:String?) -> () {
        self.address = address
    }
    
    func getAddress() -> (String?) {
        return self.address
    }
    
    func setAmount(_ amount:String?) -> () {
        self.amount = amount
    }
    
    func getAmount() -> (String?) {
        return self.amount
    }
    
    func setFiatAmount(_ fiatAmount:String?) -> () {
        self.fiatAmount = fiatAmount
    }
    
    func getFiatAmount() -> (String?) {
        return self.fiatAmount
    }
}

