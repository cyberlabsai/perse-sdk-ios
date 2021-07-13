import Foundation

public enum Environment {
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    return dict
  }()

  static let apiKey: String = {
    guard let apiKey = Environment.infoDictionary["API_KEY"] as? String else {
      fatalError("Perse API Key not set in plist for this environment")
    }
    return apiKey
  }()
}
