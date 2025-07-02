import Foundation

// MARK: - Data Models

public struct Cafe: Codable, Sendable {
  public let id: String
  public let name: String
  public let wifi: Double
  public let seat: Double
  public let quiet: Double
  public let tasty: Double
  public let cheap: Double
  public let music: Double
  public let address: String
  public let latitude: String
  public let longitude: String
  public let url: String
  public let limitedTime: LimitedTime?
  public let socket: Socket?
  public let standingDesk: StandingDesk?
  public let mrt: String?
  public let openTime: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name, wifi, seat, quiet, tasty, cheap, music
    case address, latitude, longitude, url, mrt
    case limitedTime = "limited_time"
    case socket
    case standingDesk = "standing_desk"
    case openTime = "open_time"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    wifi = try container.decode(Double.self, forKey: .wifi)
    seat = try container.decode(Double.self, forKey: .seat)
    quiet = try container.decode(Double.self, forKey: .quiet)
    tasty = try container.decode(Double.self, forKey: .tasty)
    cheap = try container.decode(Double.self, forKey: .cheap)
    music = try container.decode(Double.self, forKey: .music)
    address = try container.decode(String.self, forKey: .address)
    latitude = try container.decode(String.self, forKey: .latitude)
    longitude = try container.decode(String.self, forKey: .longitude)
    url = try container.decode(String.self, forKey: .url)
    mrt = try container.decodeIfPresent(String.self, forKey: .mrt)
    openTime = try container.decodeIfPresent(String.self, forKey: .openTime)
    
    // 處理可能為空字串的列舉欄位
    if let limitedTimeString = try container.decodeIfPresent(String.self, forKey: .limitedTime),
       !limitedTimeString.isEmpty {
      limitedTime = LimitedTime(rawValue: limitedTimeString)
    } else {
      limitedTime = nil
    }
    
    if let socketString = try container.decodeIfPresent(String.self, forKey: .socket),
       !socketString.isEmpty {
      socket = Socket(rawValue: socketString)
    } else {
      socket = nil
    }
    
    if let standingDeskString = try container.decodeIfPresent(String.self, forKey: .standingDesk),
       !standingDeskString.isEmpty {
      standingDesk = StandingDesk(rawValue: standingDeskString)
    } else {
      standingDesk = nil
    }
  }
}

public enum LimitedTime: String, Codable, Sendable {
  case yes = "yes"     // 一律有限時
  case maybe = "maybe" // 看情況，假日或客滿限時
  case no = "no"       // 一律不限時
}

public enum Socket: String, Codable, Sendable {
  case yes = "yes"     // 很多
  case maybe = "maybe" // 還好，看座位
  case no = "no"       // 很少
}

public enum StandingDesk: String, Codable, Sendable {
  case yes = "yes"     // 有些座位可以
  case no = "no"       // 無法
} 