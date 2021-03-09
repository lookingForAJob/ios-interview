@testable import PracticeProject
import XCTest

class SpyActivityIndicatorCoordinator: ActivityIndicatorCoordinator {
    private(set) var startCallCount = 0
    override func start() {
        startCallCount += 1
    }
}

class ActivityIndicatorCoordinator: Coordinator {
    func start() {}
}

class SpyRaywenderlichLibraryCoordinator: RaywenderlichLibraryCoordinator {
    private(set) var startCallCount = 0
    override func start() {
        startCallCount += 1
    }
}

class RaywenderlichLibraryCoordinator: Coordinator {
    func start() {}
}

class SpyRetryFetchCoordinator: RetryFetchCoordinator {
    private(set) var startCallCount = 0
    override func start() {
        startCallCount += 1
    }
}

class RetryFetchCoordinator: Coordinator {
    func start() {}
}

class AppCoordinator: Coordinator {
    private let activityIndicatorCoordinator: ActivityIndicatorCoordinator
    private let raywenderlichLibraryCoordinator: RaywenderlichLibraryCoordinator
    private let retryFetchCoordinator: RetryFetchCoordinator

    init(activityIndicatorCoordinator: ActivityIndicatorCoordinator,
         raywenderlichLibraryCoordinator: RaywenderlichLibraryCoordinator,
         retryFetchCoordinator: RetryFetchCoordinator) {
        self.activityIndicatorCoordinator = activityIndicatorCoordinator
        self.raywenderlichLibraryCoordinator = raywenderlichLibraryCoordinator
        self.retryFetchCoordinator = retryFetchCoordinator
    }

    func start() {
        activityIndicatorCoordinator.start()
    }
}

class AppCoordinatorTests: XCTestCase {
    private var spyActivityIndicatorCoordinator: SpyActivityIndicatorCoordinator!
    private var spyRaywenderlichLibraryCoordinator: SpyRaywenderlichLibraryCoordinator!
    private var spyRetryFetchCoordinator: SpyRetryFetchCoordinator!

    override func setUp() {
        spyActivityIndicatorCoordinator = SpyActivityIndicatorCoordinator()
        spyRaywenderlichLibraryCoordinator = SpyRaywenderlichLibraryCoordinator()
        spyRetryFetchCoordinator = SpyRetryFetchCoordinator()
    }

    func test_requestInFlight() {
        let appCoordinator = AppCoordinator(
            activityIndicatorCoordinator: spyActivityIndicatorCoordinator,
            raywenderlichLibraryCoordinator: spyRaywenderlichLibraryCoordinator,
            retryFetchCoordinator: spyRetryFetchCoordinator)

        appCoordinator.start()

        XCTAssertEqual(spyActivityIndicatorCoordinator.startCallCount, 1)
        XCTAssertEqual(spyRaywenderlichLibraryCoordinator.startCallCount, 0)
        XCTAssertEqual(spyRetryFetchCoordinator.startCallCount, 0)
    }

    func test_requestFails() {
        let appCoordinator = AppCoordinator(
            activityIndicatorCoordinator: spyActivityIndicatorCoordinator,
            raywenderlichLibraryCoordinator: spyRaywenderlichLibraryCoordinator,
            retryFetchCoordinator: spyRetryFetchCoordinator)
        appCoordinator.start()

        // TODO: trigger request failure

        XCTAssertEqual(spyActivityIndicatorCoordinator.startCallCount, 0)
        XCTAssertEqual(spyRaywenderlichLibraryCoordinator.startCallCount, 0)
        XCTAssertEqual(spyRetryFetchCoordinator.startCallCount, 1)
    }

    func test_requestSucceeds() {
        let appCoordinator = AppCoordinator(
            activityIndicatorCoordinator: spyActivityIndicatorCoordinator,
            raywenderlichLibraryCoordinator: spyRaywenderlichLibraryCoordinator,
            retryFetchCoordinator: spyRetryFetchCoordinator)
        appCoordinator.start()

        // TODO: trigger request success

        XCTAssertEqual(spyActivityIndicatorCoordinator.startCallCount, 0)
        XCTAssertEqual(spyRaywenderlichLibraryCoordinator.startCallCount, 1)
        XCTAssertEqual(spyRetryFetchCoordinator.startCallCount, 0)
    }
}
