//import XCTest
//import Combine
//@testable import SongPlayer
//
//class StatefulModelTest: BaseTest {
//
//    //----------------------------------------
//    // MARK: - Properties
//    //----------------------------------------
//
//    var viewModel: SearchViewModel!
//
//    var mockArticleStore: MockArticleStore!
//
//    var mockCoreDataStore: MockCoreDataStore!
//
//    let mockKeyword = "cat"
//
//    let mockDocumentArticlesPage1 = [
//        DocumentArticle(id: "1", abstract: "cat1", publishedDate: Date()),
//        DocumentArticle(id: "2", abstract: "cat2", publishedDate: Date()),
//        DocumentArticle(id: "3", abstract: "cat3", publishedDate: Date()),
//        // Intentional Duplication
//        DocumentArticle(id: "3", abstract: "cat3", publishedDate: Date()),
//        DocumentArticle(id: "3", abstract: "cat3", publishedDate: Date()),
//    ]
//
//    let mockDocumentArticlesPage2 = [
//        DocumentArticle(id: "4", abstract: "cat4", publishedDate: Date()),
//        DocumentArticle(id: "5", abstract: "cat5", publishedDate: Date()),
//    ]
//
//    let mockDocumentArticlesPage3 = [
//        DocumentArticle(id: "6", abstract: "cat6", publishedDate: Date()),
//        DocumentArticle(id: "7", abstract: "cat7", publishedDate: Date()),
//    ]
//
//    let mockDocumentArticlesPage4 = [
//        DocumentArticle(id: "8", abstract: "cat8", publishedDate: Date()),
//        DocumentArticle(id: "9", abstract: "cat9", publishedDate: Date()),
//    ]
//
//    let mockDocumentArticlesOtherKeywordPage1 = [
//        DocumentArticle(id: "other1", abstract: "other 1", publishedDate: Date()),
//        DocumentArticle(id: "other2", abstract: "other 2", publishedDate: Date()),
//    ]
//
//    let mockCoreDataDocumentArticles = [
//        DocumentArticle(id: "1", abstract: "coreDatatitle1", publishedDate: Date()),
//        DocumentArticle(id: "2", abstract: "coreDatatitle2", publishedDate: Date()),
//        DocumentArticle(id: "3", abstract: "coreDatatitle3", publishedDate: Date()),
//    ]
//
//    //----------------------------------------
//    // MARK: - Setup
//    //----------------------------------------
//
//    func setupViewModel() {
//        viewModel = SearchViewModel(articleStore: mockArticleStore)
//    }
//
//    override func setUp() {
//        super.setUp()
//
//        mockCoreDataStore = MockCoreDataStore(coreDataStack: mockCoreDataStack)
//        mockArticleStore = MockArticleStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore)
//
//        Cuckoo.stub(mockArticleStore) { stub in
//            when(stub.createOrUpdateDocumentArticleDataModal(documentArticle: any())).thenDoNothing()
//        }
//    }
//
//    //----------------------------------------
//    // MARK: - Tests
//    //----------------------------------------
//
//    func testSearchTextProcessingTime() {
//        setupViewModel()
//
//        verify(mockArticleStore, never()).searchDocumentArticles(keyword: any(), pageNumber: any())
//        verify(mockArticleStore, never()).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//
//        Cuckoo.stub(mockArticleStore) { stub in
//            when(stub.searchDocumentArticles(keyword: mockKeyword, pageNumber: 1)).thenReturn(Result.Publisher(.success(mockDocumentArticlesPage1))
//                .eraseToAnyPublisher())
//        }
//
//        viewModel.updateSearchKeyword(keyword: mockKeyword)
//
//        let exp = expectation(description: "Should not call search API after 0.5 seconds")
//        let result = XCTWaiter.wait(for: [exp], timeout: 0.5)
//        if result == .timedOut {
//            verify(mockArticleStore, never()).searchDocumentArticles(keyword: any(), pageNumber: any())
//            verify(mockArticleStore, never()).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//        }
//
//        let exp2 = expectation(description: "Should call search API after 0.6 seconds")
//        let result2 = XCTWaiter.wait(for: [exp2], timeout: 0.7)
//        if result2 == .timedOut {
//            verify(mockArticleStore, times(1)).searchDocumentArticles(keyword: mockKeyword, pageNumber: 1)
//            verify(mockArticleStore, times(mockDocumentArticlesPage1.count)).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//        }
//    }
//
//    func testSearchLoad() {
//        setupViewModel()
//
//        Cuckoo.stub(mockArticleStore) { stub in
//            when(stub.searchDocumentArticles(keyword: mockKeyword, pageNumber: 1)).thenReturn(Result.Publisher(.success(mockDocumentArticlesPage1))
//                .eraseToAnyPublisher())
//        }
//
//        viewModel.updateSearchKeyword(keyword: mockKeyword)
//
//        viewModel.load().sink(receiveCompletion: { completion in
//            switch completion {
//            case .finished:
//                break
//
//            case .failure:
//                XCTFail("Should not execute this block clause")
//            }
//        }, receiveValue: { value in
//            verify(self.mockArticleStore, times(1)).searchDocumentArticles(keyword: self.mockKeyword, pageNumber: 1)
//            verify(self.mockArticleStore, times(self.mockDocumentArticlesPage1.count)).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//
//            XCTAssert(value == [self.mockDocumentArticlesPage1[0], self.mockDocumentArticlesPage1[1], self.mockDocumentArticlesPage1[2]])
//        })
//    }
//
//    func testSearchPagination() {
//        let otherKeyword = "other keyword"
//        setupViewModel()
//
//        Cuckoo.stub(mockArticleStore) { stub in
//            when(stub.searchDocumentArticles(keyword: mockKeyword, pageNumber: 1)).thenReturn(Result.Publisher(.success(mockDocumentArticlesPage1))
//                .eraseToAnyPublisher())
//            when(stub.searchDocumentArticles(keyword: mockKeyword, pageNumber: 2)).thenReturn(Result.Publisher(.success(mockDocumentArticlesPage2))
//                .eraseToAnyPublisher())
//            when(stub.searchDocumentArticles(keyword: mockKeyword, pageNumber: 3)).thenReturn(Result.Publisher(.success(mockDocumentArticlesPage3))
//                .eraseToAnyPublisher())
//            when(stub.searchDocumentArticles(keyword: mockKeyword, pageNumber: 4)).thenReturn(Result.Publisher(.success(mockDocumentArticlesPage4))
//                .eraseToAnyPublisher())
//            when(stub.searchDocumentArticles(keyword: otherKeyword, pageNumber: 1)).thenReturn(Result.Publisher(.success(mockDocumentArticlesOtherKeywordPage1))
//                .eraseToAnyPublisher())
//        }
//
//        viewModel.updateSearchKeyword(keyword: mockKeyword)
//
//        let delayExpectation = expectation(description: "Should call search API after 0.6 seconds")
//        let result = XCTWaiter.wait(for: [delayExpectation], timeout: 0.7)
//        if result == .timedOut {
//            viewModel.statePublisher
//                .sink { [weak self] state in
//                    guard let self = self else { return }
//
//                    switch state {
//                    case .loaded(let value):
//                        let correctMockDocumentArticlesPage1 = [self.mockDocumentArticlesPage1[0], self.mockDocumentArticlesPage1[1], self.mockDocumentArticlesPage1[2]]
//
//                        switch self.viewModel.pageNumber {
//                        case 1:
//                            XCTAssertEqual(value, correctMockDocumentArticlesPage1)
//                            verify(self.mockArticleStore, times(self.mockDocumentArticlesPage1.count)).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//
//                        case 2:
//                            XCTAssertEqual(value, correctMockDocumentArticlesPage1 + self.mockDocumentArticlesPage2)
//                            verify(self.mockArticleStore, times(self.mockDocumentArticlesPage1.count + self.mockDocumentArticlesPage2.count)).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//
//                        case 3:
//                            XCTAssertEqual(value, correctMockDocumentArticlesPage1 + self.mockDocumentArticlesPage2 + self.mockDocumentArticlesPage3)
//                            verify(self.mockArticleStore, times(self.mockDocumentArticlesPage1.count + self.mockDocumentArticlesPage2.count + self.mockDocumentArticlesPage3.count)).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//
//                        case 4:
//                            XCTAssertEqual(value, correctMockDocumentArticlesPage1 + self.mockDocumentArticlesPage2 + self.mockDocumentArticlesPage3 + self.mockDocumentArticlesPage4)
//                            verify(self.mockArticleStore, times(self.mockDocumentArticlesPage1.count + self.mockDocumentArticlesPage2.count + self.mockDocumentArticlesPage3.count + self.mockDocumentArticlesPage4.count)).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//
//                        default:
//                            XCTFail("Should not execute this block clause")
//                        }
//
//                    default:
//                        break
//                    }
//                }.store(in: &cancellables)
//
//            viewModel.loadNextPage()
//
//            viewModel.loadNextPage()
//
//            viewModel.loadNextPage()
//        }
//    }
//
//    func testSearchLoadError() {
//        let appError = AppError.quotaViolation
//
//        Cuckoo.stub(mockArticleStore) { stub in
//            when(stub.searchDocumentArticles(keyword: any(), pageNumber: any())).thenReturn(Result.Publisher(.failure(appError))
//                .eraseToAnyPublisher())
//        }
//
//        setupViewModel()
//
//        viewModel.updateSearchKeyword(keyword: "abcdefg")
//
//        let delayExpectation = expectation(description: "Should call search API after 0.6 seconds")
//        let result = XCTWaiter.wait(for: [delayExpectation], timeout: 0.7)
//        if result == .timedOut {
//            verify(mockArticleStore, never()).createOrUpdateDocumentArticleDataModal(documentArticle: any())
//
//            viewModel.load().sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Should not execute this block clause")
//
//                case .failure(let error):
//                    XCTAssertEqual(error as? AppError, appError)
//                }
//            }, receiveValue: { value in
//                XCTFail("Should not execute this block clause")
//            }).store(in: &cancellables)
//        }
//    }
//}
