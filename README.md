# CafeNomad Swift Package

一個基於 [Cafe Nomad API v1.2](https://cafenomad.tw/developers/docs/v1.2) 的 Swift package，提供簡潔的 API 來獲取台灣咖啡廳資訊。

## 特色

- ✅ **Swift 6 Concurrency** - 使用 async/await 和 Sendable
- ✅ **類型安全** - 完整的 Swift 類型定義
- ✅ **錯誤處理** - 詳細的錯誤類型和描述
- ✅ **跨平台** - 支援 iOS, macOS, watchOS
- ✅ **測試完整** - 使用 Swift Testing 框架

## 系統需求

- macOS 12.0+ / iOS 15.0+ / watchOS 8.0+
- Swift 6.2+
- Xcode 15.0+

## 安裝

### Swift Package Manager

在 Xcode 中：
1. File → Add Package Dependencies
2. 輸入 repository URL
3. 選擇版本並添加到目標

或在 `Package.swift` 中添加：

```swift
dependencies: [
  .package(url: "https://github.com/your-username/CafeNomad.git", from: "1.0.0")
]
```

## 快速開始

```swift
import CafeNomadService

let service = CafeNomadService()

// 獲取全台灣咖啡廳
do {
  let allCafes = try await service.fetchAllCafes()
  print("全台共有 \(allCafes.count) 間咖啡廳")
} catch {
  print("錯誤: \(error)")
}

// 獲取特定城市咖啡廳
do {
  let taipeiCafes = try await service.fetchCafes(for: "taipei")
  print("台北有 \(taipeiCafes.count) 間咖啡廳")
} catch {
  print("錯誤: \(error)")
}
```

## CafeNomadService

主要的服務類別，提供咖啡廳資料的 API 存取。

### 初始化

```swift
public init(session: URLSession = .shared)
```

### 方法

#### fetchAllCafes()

獲取全台灣的咖啡廳資料。

```swift
public func fetchAllCafes() async throws -> [Cafe]
```

**回傳值:** `[Cafe]` - 咖啡廳陣列

**可能拋出的錯誤:**
- `CafeNomadError.invalidURL` - URL 格式錯誤
- `CafeNomadError.invalidResponse` - 無效的伺服器回應
- `CafeNomadError.httpError(Int)` - HTTP 錯誤
- `CafeNomadError.decodingError(Error)` - 資料解碼錯誤

#### fetchCafes(for:)

獲取指定城市的咖啡廳資料。

```swift
public func fetchCafes(for city: String) async throws -> [Cafe]
```

**參數:**
- `city`: 城市名稱（例如："taipei", "hsinchu", "kaohsiung", "taichung"）

**回傳值:** `[Cafe]` - 咖啡廳陣列

## 錯誤處理

```swift
do {
  let cafes = try await service.fetchCafes(for: "taipei")
  // 處理成功結果
} catch let error as CafeNomadError {
  switch error {
  case .invalidURL(let url):
    print("無效的 URL: \(url)")
  case .invalidResponse:
    print("伺服器回應無效")
  case .httpError(let statusCode):
    print("HTTP 錯誤: \(statusCode)")
  case .decodingError(let error):
    print("資料解碼失敗: \(error)")
  }
} catch {
  print("其他錯誤: \(error)")
}
```

## 授權

本 package 基於 Cafe Nomad 的公開 API，請確保遵守其使用條款。

## 貢獻

歡迎提交 Issue 和 Pull Request！

<a href="https://buymeacoffee.com/rice.lin" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

## 相關連結

- [Cafe Nomad 官方網站](https://cafenomad.tw)
- [Cafe Nomad API 文件](https://cafenomad.tw/developers/docs/v1.2) 