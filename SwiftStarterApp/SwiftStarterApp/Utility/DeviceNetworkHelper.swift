//
//  DeviceNetworkHelper.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 07/12/23.
//

import Foundation
import CoreTelephony

public enum CellularType: String {
  /// 2G network type
  case twoG = "2G"

  /// 3G network type
  case threeG = "3G"

  /// 4G network type
  case fourG = "4G"

  /// 5G network type
  case fiveG = "5G"

  // unknown network type
  case unKnown

  var value: String {
    self.rawValue
  }
}

class DeviceNetworkHelper {

  public class func networkInfo() -> CTTelephonyNetworkInfo {
    let networkInfo = CTTelephonyNetworkInfo()
    return networkInfo
  }

  public class func carrier() -> CTCarrier? {
    let networkInfo = self.networkInfo()
    let carrier = networkInfo.serviceSubscriberCellularProviders?.filter({ $0.value.carrierName != nil }).first?.value
    return carrier
  }

  public class func networkType() -> CellularType {

    let radioAccessTechnology = self.networkInfo().serviceCurrentRadioAccessTechnology?.values.first ?? "Not Found"
    print("radioAccessTechnology: \(radioAccessTechnology)")
    switch radioAccessTechnology {
      case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
        return CellularType.twoG
      case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD:
        return CellularType.threeG
      case CTRadioAccessTechnologyLTE:
        return CellularType.fourG
      case CTRadioAccessTechnologyNRNSA, CTRadioAccessTechnologyNR:
        return CellularType.fiveG
      default:
        return CellularType.unKnown
    }
  }
}
