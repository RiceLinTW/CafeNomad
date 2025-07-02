import Foundation

// MARK: - Service

public final class CafeNomadService: Sendable {
  
  private let baseURL = "https://cafenomad.tw/api/v1.2/cafes"
  private let session: URLSession
  
  public init(session: URLSession = .shared) {
    self.session = session
  }
  
  // MARK: - Public Methods
  
  /// 取得全台灣咖啡廳資料
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, *)
  public func fetchAllCafes() async throws -> [Cafe] {
    guard let url = URL(string: baseURL) else {
      throw CafeNomadError.invalidURL(baseURL)
    }
    return try await fetchCafes(from: url)
  }
  
  /// 取得指定城市咖啡廳資料
  /// - Parameter city: 城市名稱 (例如: "taipei", "hsinchu", "kaohsiung")
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, *)
  public func fetchCafes(for city: String) async throws -> [Cafe] {
    let urlString = "\(baseURL)/\(city)"
    guard let url = URL(string: urlString) else {
      throw CafeNomadError.invalidURL(urlString)
    }
    return try await fetchCafes(from: url)
  }
  
  // MARK: - Private Methods
  
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, *)
  private func fetchCafes(from url: URL) async throws -> [Cafe] {
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw CafeNomadError.invalidResponse
    }
    
    guard 200...299 ~= httpResponse.statusCode else {
      throw CafeNomadError.httpError(httpResponse.statusCode)
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode([Cafe].self, from: data)
    } catch {
      throw CafeNomadError.decodingError(error)
    }
  }
}




