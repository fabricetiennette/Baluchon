//
//  TranslateViewModelTests.swift
//  BaluchonTests
//
//  Created by Fabrice Etiennette on 24/01/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
import Moya
@testable import Baluchon

class TranslateViewModelTests: XCTestCase {
    var translateViewModel: TranslateViewModel!
    var translateClient: TranslateClient!
    let stubbingProvider = MoyaProvider<TranslateAPI>(stubClosure: MoyaProvider.immediatelyStub)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        translateViewModel = TranslateViewModel()
        translateClient = TranslateClient()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        translateViewModel = nil
        translateClient = nil
        super.tearDown()
    }

    func testTranslationFr() {
        let sourceLanguage: Language = .fr
        let text = "Bonjour"
        let expect = expectation(description: "Hello")
        var answer: String?
        let translationBody = Translate(source: sourceLanguage, text: text)
        translateViewModel.doTranslation(translationBody: translationBody)
        translateViewModel.translatedTextHandler = { translatedText in
                answer = translatedText
                expect.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
            XCTAssertNotNil(answer)
            XCTAssertEqual(answer, "Hello")
        }
    }

    func testTranslationEn() {
        let sourceLanguage: Language = .en
        let text = "Hello"
        let expect = expectation(description: "Bonjour")
        var answer: String?
        let translationBody = Translate(source: sourceLanguage, text: text)
        translateViewModel.doTranslation(translationBody: translationBody)
        translateViewModel.translatedTextHandler = { translatedText in
                answer = translatedText
                expect.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
            XCTAssertNotNil(answer)
            XCTAssertEqual(answer, "Bonjour")
        }
    }

    func testTextHandler() {
        let expect = expectation(description: "Bonjour")
        let text = "Bonjour"
        var answer: String?

        translateViewModel.translatedTextHandler = { translatedText in
                answer = translatedText
                expect.fulfill()
        }
        translateViewModel.translatedTextHandler(text)
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertNil(error)
            XCTAssertNotNil(answer)
            XCTAssertEqual(answer, "Bonjour")
        }
    }
}
