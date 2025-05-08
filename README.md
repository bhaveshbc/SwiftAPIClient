# APIClient

A lightweight, async/await-based Swift network client that provides a clean abstraction for making API requests using generics and protocol-oriented design.

---

## 🚀 Features

- Async/await support for clean and modern networking
- Decodable response parsing
- Automatic error handling based on HTTP status codes
- Customizable request building and session handling
- Easily extendable and testable using protocols

---

## 💠 Installation

### Swift Package Manager (SPM)

Add the package to your `Package.swift`:

```swift
.package(url: "https://github.com/bhaveshbc/APIClient.git", from: "1.0.0")
```

Then add `"APIClient"` as a dependency to your target.

---

## 📦 Usage

### 1. Define Your API Endpoints

Create an `enum` conforming to `EndPointType`:

```swift
enum UserAPI: EndPointType {
    case getUser(id: Int)

    var baseURL: URL { URL(string: "https://api.example.com")! }

    var path: String {
        switch self {
        case .getUser(let id): return "/users/\(id)"
        }
    }

    var method: HTTPMethod { .get }

    var task: HTTPTask { .request }

    var headers: HTTPHeaders? { nil }
}
```

> `EndPointType`, `HTTPMethod`, `HTTPTask`, and `HTTPHeaders` should be defined by you as part of the abstraction.

---

### 2. Initialize the Network Client

```swift
let requestBuilder = DefaultRequestBuilder() // conforming to RequestBuilderType
let client = NetWorkClient<UserAPI>(requestBuilder: requestBuilder)
```

---

### 3. Make a Request

#### 🔹 JSON Response

```swift
let response = try await client.request(apiRouter: .getUser(id: 1))
// response is [String: Any]?
```

#### 🔹 Decodable Response

```swift
struct User: Decodable {
    let id: Int
    let name: String
}

let user: User = try await client.request(apiRouter: .getUser(id: 1))
```

---

## ⚠️ Error Handling

Errors are thrown based on HTTP status codes:

| Status Code | Error                    |
|-------------|--------------------------|
| 401         | `.unauthorized`          |
| 402–500     | `.serverError`           |
| 501–599     | `.badRequest`            |
| 600         | `.outdated`              |
| Others      | `.missingURL`            |

> All errors conform to `NetworkError`.

---

## 🥪 Testing

The use of `URLSessionProtocol` allows easy mocking for unit tests.

---

## 🧹 Extending

- Implement your own `RequestBuilderType` for custom request logic.
- Add logging or retry logic in `NetWorkClient`.
- Customize error handling in `NetWorkErrorHandler`.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🙌 Contributions

Feel free to open issues or submit PRs if you'd like to improve or extend this library!

