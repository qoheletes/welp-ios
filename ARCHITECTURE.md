# ARCHITECTURE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Clean Architecture + Micro Feature Architecture

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         App Layer                            │
│                    (Application Entry)                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Feature Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ HomeFeature  │  │ ProfileFeat. │  │ SigninFeat.  │      │
│  │              │  │              │  │              │      │
│  │ • Demo       │  │ • Demo       │  │ • Demo       │      │
│  │ • Interface  │  │ • Interface  │  │ • Interface  │      │
│  │ • Sources    │  │ • Sources    │  │ • Sources    │      │
│  │ • Tests      │  │ • Tests      │  │ • Tests      │      │
│  │ • Testing    │  │ • Testing    │  │ • Testing    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│              (Business Logic & Entities)                     │
│  • UseCase (business logic)                                  │
│  • Entity (domain model)                                     │
│  • Repository Protocol (data abstraction)                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│               (Repository Implementation)                    │
│  • Repository implementations                                │
│  • API Client / Database                                     │
│  • DTO (Data Transfer Object)                                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Shared Layer                            │
│  • FeatureFoundation (common base classes)                   │
│  • DesignSystem (UI components)                              │
│  • Utils (utilities)                                         │
│  • ThirdPartyLibrary (external libraries)                    │
└─────────────────────────────────────────────────────────────┘
```

### 5-Layer Description

#### 1. **App Layer**
- Application entry point
- AppDelegate, SceneDelegate
- Global DI Container configuration
- App-level settings and initialization

#### 2. **Feature Layer**
- Independent module per feature (HomeFeature, ProfileFeature, etc.)
- Contains UI and Presentation logic
- Applies Micro Feature Architecture
- Each Feature can run independently (Demo target)

#### 3. **Domain Layer**
- Core of business logic
- Independent of any Framework/UI
- UseCase: implements business rules
- Entity: domain model
- Repository Protocol: data access abstraction

#### 4. **Data Layer**
- Implements the Domain Layer's Repository
- Manages data sources (API, Database, Cache)
- Converts DTOs to Entities
- Network/database access

#### 5. **Shared Layer**
- Common components and utilities
- FeatureFoundation: BaseViewController, BaseCoordinator, etc.
- DesignSystem: reusable UI components
- ThirdPartyLibrary: external dependency management

---

## Differences from MVVM

### Traditional MVVM Architecture

```
┌──────────────┐
│     View     │
│ (ViewController)
└──────┬───────┘
       │ Binding
       ▼
┌──────────────┐
│  ViewModel   │
│              │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    Model     │
│              │
└──────────────┘
```

**Limitations of traditional MVVM:**
- The Model layer is too vague (network, database, and business logic are all mixed together)
- In large projects, ViewModels become bloated
- Limited testability
- Difficult to modularize
- Dependency direction is not clear

### This Project's Clean Architecture + MVVM

```
┌──────────────────────────────────────────────────┐
│              Feature Layer (MVVM)                │
│                                                  │
│  ┌──────────────┐         ┌──────────────┐      │
│  │View          │◄────────│  Coordinator │      │
│  │              │  Route  │              │      │
│  └──────┬───────┘         └──────────────┘      │
│         │ Binding                                │
│         ▼                                        │
│  ┌──────────────┐                                │
│  │  ViewModel   │                                │
│  │ Input/Output │                                │
│  └──────┬───────┘                                │
│         │                                        │
│         │ UseCase call                           │
└─────────┼──────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────┐
│           Domain Layer                           │
│                                                  │
│  ┌──────────────┐         ┌──────────────┐      │
│  │   UseCase    │────────▶│  Repository  │      │
│  │              │         │  (Protocol)  │      │
│  └──────────────┘         └──────┬───────┘      │
│                                  │              │
└──────────────────────────────────┼──────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────┐
│            Data Layer                            │
│                                                  │
│  ┌──────────────┐         ┌──────────────┐      │
│  │ Repository   │────────▶│  API Client  │      │
│  │  Impl        │         │  Database    │      │
│  └──────────────┘         └──────────────┘      │
└──────────────────────────────────────────────────┘
```

### Key Differences

| Category | Traditional MVVM | Clean Architecture + MVVM |
|----------|-----------------|---------------------------|
| **Layer separation** | View - ViewModel - Model | Feature - Domain - Data - Shared |
| **Business logic** | Mixed inside ViewModel | Separated into UseCases |
| **Data access** | ViewModel accesses directly | Abstracted through Repository interface |
| **Dependency direction** | Bidirectional possible | Unidirectional (outer → inner) |
| **Modularization** | Difficult | Fully independent via Micro Feature |
| **Testing** | Complex Mock creation | Easy via Protocol-based design |
| **Navigation** | Handled by ViewController | Coordinator pattern |
| **Reusability** | Low | High reusability through Interfaces |

### Benefits of the Input/Output Pattern

In traditional MVVM, the ViewModel exposes various methods and properties. This project instead uses the **Input/Output pattern**:

```swift
// Traditional MVVM
class ViewModel {
    var title: String
    var isLoading: Bool
    func fetchData()
    func refresh()
    func didSelectItem(at index: Int)
}

// Clean Architecture + MVVM (Input/Output)
final class HomeViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let refresh: Observable<Void>
        let itemSelected: Observable<Int>
    }
    
    struct Output {
        let title: Observable<String>
        let isLoading: Observable<Bool>
        let items: Observable<[Item]>
        let route: Observable<HomeRoutePath>
    }
    
    func transform(input: Input) -> Output {
        // Business logic
    }
}
```

**Benefits of the Input/Output pattern:**
- The ViewModel's interface is explicit and well-defined
- The flow of inputs and outputs is easy to understand at a glance
- Writing tests is straightforward
- Works seamlessly with RxSwift's reactive programming

---

## Background & Motivation

### 1. **Scalability Problems**
In a traditional MVVM structure, the following problems arise as the project grows:
- ViewModels balloon to hundreds of lines
- The Model layer is vague, mixing network, database, and business logic
- Adding features frequently requires modifying existing code (violates the Open/Closed Principle)

**Solution:**
- Separate business logic into UseCases
- Abstract data access through the Repository pattern
- Adhere to SRP (Single Responsibility Principle) through clear layer separation

### 2. **Team Collaboration Efficiency**
When multiple developers work simultaneously:
- Frequent Git conflicts from modifying the same files
- A change in one feature impacts other features
- Build times increase

**Solution:**
- Full feature independence via Micro Feature
- Each Feature can be developed and tested independently
- Module dependency management using Tuist
- Shorter build times through incremental builds

### 3. **Testability**
In traditional structures:
- ViewModels depend on concrete implementations
- Creating Mock objects is complex
- Unit testing is difficult due to UI dependencies

**Solution:**
- Protocol-based design makes creating Mocks easy
- The Domain Layer can be tested entirely independently
- Mocks are shared across features via the Testing target

### 4. **Reusability**
It is difficult to reuse the same features across different projects.

**Solution:**
- Clear contracts through Interfaces
- Independent Feature modules
- Common component management through the Shared Layer

### 5. **Maintainability**
Understanding legacy code is difficult:
- Dependency directions are unclear
- Business logic is scattered across many places
- Navigation logic is mixed inside ViewControllers

**Solution:**
- Unidirectional dependency rule
- Business logic concentrated in UseCases
- Navigation logic separated via Coordinator

---

## Micro Feature Structure

Each Feature is composed as an independent module, managed through Tuist.

### The 5 Targets of a Micro Feature

```
HomeFeature/
├── Demo/                    # Standalone runnable app
│   ├── Sources/
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   └── Resources/
│       └── LaunchScreen.storyboard
│
├── Interface/              # Externally exposed interface
│   ├── HomeFactory.swift       (Protocol)
│   └── HomeRoutePath.swift     (enum)
│
├── Sources/               # Actual implementations
│   ├── Assembly/
│   │   └── HomeAssembly.swift
│   ├── Coordinator/
│   │   └── HomeCoordinator.swift
│   ├── Factory/
│   │   └── DefaultHomeFactory.swift
│   └── Presentation/
│       ├── HomeViewController.swift
│       └── HomeViewModel.swift
│
├── Testing/               # Test Mocks
│   └── MockHomeRepository.swift
│
├── Tests/                 # Unit tests
│   └── HomeTests.swift
│
└── Project.swift          # Tuist configuration
```

### Role of Each Target

#### 1. **Demo Target**
- A standalone runnable app
- Develop and test a Feature in isolation
- Fast feedback loop

```swift
// Demo/Sources/SceneDelegate.swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
           options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController()
    
    let factory = DefaultHomeFactory()
    let coordinator = factory.makeCoordinator(
        navigationController: navigationController
    )
    coordinator.start()
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
}
```

#### 2. **Interface Target**
- The public interface exposed to the outside
- Contains only Protocols and Public types
- The only target that other Features depend on

```swift
// Interface/HomeFactory.swift
public protocol HomeFactory: Factory {
    func makeCoordinator(navigationController: UINavigationController) 
        -> BaseCoordinator<HomeRoutePath>
}

// Interface/HomeRoutePath.swift
public enum HomeRoutePath: RoutePath {
    case toDetail
}
```

**Benefits of Interface:**
- Hides implementation details (Encapsulation)
- Dependency inversion (Dependency Inversion)
- Compile-time safety

#### 3. **Sources Target** (Implementation)
- Actual implementation code
- Implements the Interface
- Not directly accessible from outside (Internal)

#### 4. **Testing Target**
- Test Mocks and Stubs
- Can be used by other Features' Tests

```swift
// Testing/MockHomeRepository.swift
public final class MockHomeRepository: HomeRepository {
    public var mockData: [Home] = []
    
    public func getHomeList() -> Observable<[Home]> {
        return .just(mockData)
    }
}
```

#### 5. **Tests Target**
- Unit test code
- Uses XCTest

### Tuist Project.swift Structure

```swift
let project = Project(
    name: Module.Feature.HomeFeature.rawValue,
    targets: [
        // Demo target
        .target(
            name: Module.Feature.HomeFeature.targetName(type: .demo),
            product: .app,
            sources: ["Demo/Sources/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [
                .feature(target: .HomeFeature)  // Depends on Sources
            ]
        ),
        
        // Tests target
        .tests(
            module: .feature(.HomeFeature),
            dependencies: [
                .feature(target: .HomeFeature),
                .feature(target: .HomeFeature, type: .testing),
            ]
        ),
        
        // Sources target (implementation)
        .implement(
            module: .feature(.HomeFeature),
            dependencies: [
                .feature(target: .HomeFeature, type: .interface)  // Depends on Interface
            ]
        ),
        
        // Testing target
        .testing(
            module: .feature(.HomeFeature),
            dependencies: [
                .feature(target: .HomeFeature, type: .interface)
            ]
        ),
        
        // Interface target
        .interface(
            module: .feature(.HomeFeature),
            dependencies: [
                .shared(target: .ThirdPartyLibrary),
                .shared(target: .FeatureFoundation),
            ]
        ),
    ]
)
```

### Dependency Rules

```
Demo → Sources → Interface → Shared
         ↑
      Testing → Interface
         ↑
      Tests
```

**Key Principles:**
1. Interface can only depend on other Features' Interfaces
2. Sources can only depend on its own Interface
3. Demo can only depend on Sources
4. External Features can only depend on the Interface

---

## Implementation Examples

### Scenario: Displaying a Coin List on the Home Screen

#### 1. Define the Domain Layer

```swift
// Domain/Interface/Entity/Coin.swift
public struct Coin {
    public let id: String
    public let name: String
    public let symbol: String
    public let price: Double
}

// Domain/Interface/Repository/CoinRepository.swift
public protocol CoinRepository {
    func getCoinList() -> Observable<[Coin]>
}

// Domain/Interface/UseCase/CoinListUseCase.swift
public protocol CoinListUseCase {
    func execute() -> Observable<[Coin]>
}

// Domain/Sources/UseCase/CoinListUseCaseImpl.swift
public final class CoinListUseCaseImpl: CoinListUseCase {
    private let repository: CoinRepository
    
    public init(repository: CoinRepository) {
        self.repository = repository
    }
    
    public func execute() -> Observable<[Coin]> {
        return repository.getCoinList()
            .map { coins in
                // Business logic: sort by price descending
                coins.sorted { $0.price > $1.price }
            }
    }
}
```

#### 2. Implement the Data Layer

```swift
// Data/Repository/CoinRepositoryImpl.swift
public final class CoinRepositoryImpl: CoinRepository {
    private let apiClient: CoinAPIClient
    
    public init(apiClient: CoinAPIClient) {
        self.apiClient = apiClient
    }
    
    public func getCoinList() -> Observable<[Coin]> {
        return apiClient.fetchCoinList()
            .map { dtos in
                dtos.map { dto in
                    Coin(
                        id: dto.id,
                        name: dto.name,
                        symbol: dto.symbol,
                        price: dto.currentPrice
                    )
                }
            }
    }
}

// Data/API/CoinAPIClient.swift
public final class CoinAPIClient {
    func fetchCoinList() -> Observable<[CoinDTO]> {
        // Network request
    }
}
```

#### 3. Implement the Feature Layer

```swift
// HomeFeature/Interface/HomeRoutePath.swift
public enum HomeRoutePath: RoutePath {
    case toCoinDetail(coinId: String)
}

// HomeFeature/Interface/HomeFactory.swift
public protocol HomeFactory: Factory {
    func makeCoordinator(navigationController: UINavigationController) 
        -> BaseCoordinator<HomeRoutePath>
}

// HomeFeature/Sources/Presentation/HomeViewModel.swift
final class HomeViewModel: ViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let coinSelected: Observable<String>
    }
    
    struct Output {
        let coins: Observable<[Coin]>
        let isLoading: Observable<Bool>
        let route: Observable<HomeRoutePath>
    }
    
    private let coinListUseCase: CoinListUseCase
    
    init(coinListUseCase: CoinListUseCase) {
        self.coinListUseCase = coinListUseCase
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let coins = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[Coin]> in
                guard let self = self else { return .empty() }
                return self.coinListUseCase.execute()
                    .trackActivity(activityIndicator)
            }
            .share(replay: 1)
        
        let route = input.coinSelected
            .map { coinId in
                HomeRoutePath.toCoinDetail(coinId: coinId)
            }
        
        return Output(
            coins: coins,
            isLoading: activityIndicator.asObservable(),
            route: route
        )
    }
}

// HomeFeature/Sources/Presentation/HomeViewController.swift
public final class HomeViewController: BaseViewController {
    
    private let viewModel: HomeViewModel
    private let _routes = PublishSubject<HomeRoutePath>()
    var routes: Observable<HomeRoutePath> { _routes.asObservable() }
    
    private let coinSelected = PublishSubject<String>()
    private var tableView: UITableView!
    private var dataSource: [Coin] = []
    
    override public func setupSubviews() {
        tableView = UITableView()
        tableView.register(CoinCell.self, forCellReuseIdentifier: "CoinCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override public func bindState() {
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: viewDidLoadPublisher,
                coinSelected: coinSelected.asObservable()
            )
        )
        
        output.coins
            .subscribe(onNext: { [weak self] coins in
                self?.dataSource = coins
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.route
            .bind(to: _routes)
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = dataSource[indexPath.row]
        coinSelected.onNext(coin.id)
    }
}

// HomeFeature/Sources/Coordinator/HomeCoordinator.swift
public final class HomeCoordinator: BaseCoordinator<HomeRoutePath> {
    private let router: Router
    private let homeViewController: HomeViewController
    private let coinDetailFactory: CoinDetailFactory
    
    init(
        router: Router,
        viewController: HomeViewController,
        coinDetailFactory: CoinDetailFactory
    ) {
        self.router = router
        self.homeViewController = viewController
        self.coinDetailFactory = coinDetailFactory
        super.init()
    }
    
    override public func start() {
        router.setRoot(homeViewController, animated: false)
        
        homeViewController.routes
            .subscribe(onNext: { [weak self] routePath in
                self?.handleRoute(routePath)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleRoute(_ routePath: HomeRoutePath) {
        switch routePath {
        case .toCoinDetail(let coinId):
            let coordinator = coinDetailFactory.makeCoordinator(
                navigationController: router.navigationController,
                coinId: coinId
            )
            addChild(coordinator)
            coordinator.start()
        }
    }
}

// HomeFeature/Sources/Factory/DefaultHomeFactory.swift
public struct DefaultHomeFactory: HomeFactory {
    
    private let coinListUseCase: CoinListUseCase
    private let coinDetailFactory: CoinDetailFactory
    
    public init(
        coinListUseCase: CoinListUseCase,
        coinDetailFactory: CoinDetailFactory
    ) {
        self.coinListUseCase = coinListUseCase
        self.coinDetailFactory = coinDetailFactory
    }
    
    public func makeCoordinator(navigationController: UINavigationController) 
        -> BaseCoordinator<HomeRoutePath> {
        let router = NavigationRouter(navigationController: navigationController)
        let viewModel = HomeViewModel(coinListUseCase: coinListUseCase)
        let viewController = HomeViewController(viewModel: viewModel)
        
        return HomeCoordinator(
            router: router,
            viewController: viewController,
            coinDetailFactory: coinDetailFactory
        )
    }
}

// HomeFeature/Sources/Assembly/HomeAssembly.swift
public final class HomeAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        // Repository
        container.register(CoinRepository.self) { _ in
            CoinRepositoryImpl(apiClient: CoinAPIClient())
        }
        
        // UseCase
        container.register(CoinListUseCase.self) { resolver in
            CoinListUseCaseImpl(
                repository: resolver.resolve(CoinRepository.self)!
            )
        }
        
        // Factory
        container.register(HomeFactory.self) { resolver in
            DefaultHomeFactory(
                coinListUseCase: resolver.resolve(CoinListUseCase.self)!,
                coinDetailFactory: resolver.resolve(CoinDetailFactory.self)!
            )
        }
    }
}
```

#### 4. Writing Tests

```swift
// HomeFeature/Tests/HomeViewModelTests.swift
import XCTest
import RxSwift
import RxTest
@testable import HomeFeature
@testable import HomeFeatureTesting

final class HomeViewModelTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockUseCase: MockCoinListUseCase!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockUseCase = MockCoinListUseCase()
        viewModel = HomeViewModel(coinListUseCase: mockUseCase)
    }
    
    func testCoinListLoad() {
        // Given
        let mockCoins = [
            Coin(id: "1", name: "Bitcoin", symbol: "BTC", price: 50000),
            Coin(id: "2", name: "Ethereum", symbol: "ETH", price: 3000)
        ]
        mockUseCase.mockCoins = mockCoins
        
        let viewDidLoad = scheduler.createHotObservable([
            .next(10, ())
        ])
        
        // When
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: viewDidLoad.asObservable(),
                coinSelected: .empty()
            )
        )
        
        let observer = scheduler.createObserver([Coin].self)
        output.coins
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element?.count, 2)
    }
}

// HomeFeature/Testing/MockCoinListUseCase.swift
public final class MockCoinListUseCase: CoinListUseCase {
    public var mockCoins: [Coin] = []
    
    public func execute() -> Observable<[Coin]> {
        return .just(mockCoins)
    }
}
```

---

## Data Flow Summary

### Full Flow

```
User Action
    │
    ▼
┌─────────────────────┐
│  View               │ ◄── Inherits BaseViewController
│  (bindState)        │     setupSubviews, setupLayout
└──────────┬──────────┘
           │ Input (Observable)
           ▼
┌─────────────────────┐
│    ViewModel        │ ◄── Input/Output pattern
│    (transform)      │     Implements ViewModel Protocol
└──────────┬──────────┘
           │ UseCase.execute()
           ▼
┌─────────────────────┐
│     UseCase         │ ◄── Business logic
│  (business rules)   │     sorting, filtering, combining
└──────────┬──────────┘
           │ Repository Protocol
           ▼
┌─────────────────────┐
│   Repository Impl   │ ◄── Data source abstraction
│  (data access)      │     API, Database
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  API / Database     │
│  (actual data)      │
└─────────────────────┘
           │
           ▼
     Output (Observable)
           │
           ▼
┌─────────────────────┐
│  View               │
│  (UI update)        │
└─────────────────────┘
```

### Navigation Flow

```
User Action (button tap)
    │
    ▼
View
    │ routes.onNext(RoutePath)
    ▼
Coordinator
    │ switch routePath
    ▼
Factory.makeCoordinator()
    │
    ▼
New Coordinator.start()
    │
    ▼
Router.push(View)
```
---

## References

- [Clean Architecture (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [iOS Clean Architecture (Uber Engineering)](https://eng.uber.com/clean-architecture/)
- [Micro Feature Architecture](https://docs.tuist.io/guides/develop/projects/synthesized-files)
- [Coordinator Pattern](https://khanlou.com/2015/10/coordinators-redux/)
- [Input/Output Pattern with RxSwift](https://medium.com/@sanghwanJang/input-output-pattern-with-rxswift-805ea5c92cdc)

---
