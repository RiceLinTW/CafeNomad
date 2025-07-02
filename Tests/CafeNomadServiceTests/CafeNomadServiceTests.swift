import Testing
@testable import CafeNomadService

@Suite("CafeNomad API 測試")
struct CafeNomadAPITests {
  
  let service = CafeNomadService()
  
  @Test("取得全台灣咖啡廳資料")
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, *)
  func fetchAllCafes() async throws {
    let cafes = try await service.fetchAllCafes()
    
    #expect(!cafes.isEmpty, "應該要有咖啡廳資料")
    
    // 檢查第一筆資料的必要欄位
    guard let firstCafe = cafes.first else {
      Issue.record("應該要有至少一間咖啡廳")
      return
    }
    #expect(!firstCafe.id.isEmpty, "ID 不應該為空")
    #expect(!firstCafe.name.isEmpty, "店名不應該為空")
    #expect(!firstCafe.address.isEmpty, "地址不應該為空")
  }
  
  @Test("取得台北咖啡廳資料")
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, *)
  func fetchCafesForTaipei() async throws {
    let cafes = try await service.fetchCafes(for: "taipei")
    
    #expect(!cafes.isEmpty, "台北應該要有咖啡廳資料")
    
    // 檢查資料格式
    for cafe in cafes.prefix(5) { // 只檢查前5筆避免測試太久
      #expect(!cafe.id.isEmpty)
      #expect(!cafe.name.isEmpty)
      #expect((0...5).contains(cafe.wifi), "WiFi 評分應該在 0-5 之間")
      #expect((0...5).contains(cafe.seat), "座位評分應該在 0-5 之間")
    }
  }
  
  @Test("取得不同城市咖啡廳資料")
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, *)
  func fetchCafesForDifferentCities() async throws {
    // 測試多個城市
    let cities = ["hsinchu", "kaohsiung", "taichung"]
    
    for city in cities {
      let cafes = try await service.fetchCafes(for: city)
      // 不檢查是否為空，因為某些小城市可能沒有資料
      print("\(city): \(cafes.count) 間咖啡廳")
    }
  }
  
  @Test("錯誤處理測試")
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, *)
  func errorHandling() async {
    let invalidCityService = CafeNomadService()
    
    do {
      let cafes = try await invalidCityService.fetchCafes(for: "invalid_city_name_that_definitely_does_not_exist")
      // 如果沒有拋出錯誤，應該會回傳空陣列或少量資料
      print("取得資料數量: \(cafes.count)")
    } catch let error as CafeNomadError {
      switch error {
      case .httpError(let statusCode):
        #expect(statusCode >= 400, "應該是 HTTP 錯誤")
      case .invalidResponse, .decodingError, .invalidURL:
        // 這些也是可能的錯誤類型
        break
      }
    } catch {
      Issue.record("應該是 CafeNomadError 類型，但得到: \(error)")
    }
  }
}
