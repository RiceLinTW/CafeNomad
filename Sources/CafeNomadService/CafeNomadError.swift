import Foundation

// MARK: - Error Types

public enum CafeNomadError: Error, LocalizedError {
  case invalidResponse
  case httpError(Int)
  case decodingError(Error)
  case invalidURL(String)
  
  public var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid response from server"
    case .httpError(let statusCode):
      return "HTTP error with status code: \(statusCode)"
    case .decodingError(let error):
      return "Failed to decode response: \(error.localizedDescription)"
    case .invalidURL(let urlString):
      return "Invalid URL: \(urlString)"
    }
  }
} 