import XCTest
import SwiftyXMLParser

import class Foundation.Bundle

@testable import ReviewerFramework

final class ReviewerTests: XCTestCase {
    func testDecodeFeed() throws {
        let data = FixtureReviewAPI().data(using: .utf8)!
        let feed = try JSONDecoder().decode(Feed.self, from: data)
        let entry = feed.entry[0]

        XCTAssertEqual(entry.name, "ヤミ。")
        XCTAssertEqual(entry.rating, "4")
        XCTAssertEqual(entry.title, "神アプリ")
        XCTAssertEqual(
            entry.content,
            "とにかく周りの人皆んなが暖かく、みんなとすぐに仲良くなることができました！\n面白い人がたくさんいるので、つまらない時がありません！w\nコロナ自粛の期間に気まぐれで始めましたが、今ではやめられないほどハマりました\nだけど不具合が少し多いので、星4で"
        )
        XCTAssertEqual(entry.version, "3.4.3")
        XCTAssertEqual(entry.uri, URL(string: "https://itunes.apple.com/jp/reviews/id638572168")!)
        XCTAssertEqual(
            entry.link,
            URL(string: "https://itunes.apple.com/jp/review?id=1404176564&type=Purple%20Software")!)
    }
    
    func testDecodeFeedXML() throws {
        let data = fixtureReviewAPIXML()
        let parser = XML.parse(data)
        let entries = parser["feed"]["entry"].map { (accessor) in
            Entry.parseXML(accessor: accessor)
        }

        let entry = entries[0]
        XCTAssertEqual(entry.name, "単刀直入にさきいか")
        XCTAssertEqual(entry.rating, "5")
        XCTAssertEqual(entry.title, "髪型追加してもらいたい")
        XCTAssertEqual(
            entry.content,
            "いろんな髪型追加して欲しい\n片方ツインテールとかさまざまな髪型追加してほしいです\nゲーム機能ついているのはいいと思う"
        )
        XCTAssertEqual(entry.version, "3.5.0")
        XCTAssertEqual(entry.uri, URL(string: "https://itunes.apple.com/jp/reviews/id945418104")!)
        XCTAssertEqual(
            entry.link,
            URL(string: "https://itunes.apple.com/jp/review?id=1404176564&type=Purple%20Software")!)
        XCTAssertEqual(entry.updated, Date(timeIntervalSinceReferenceDate: 618923180.0))
    }


    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }

    static var allTests = [
        ("testDecodeFeed", testDecodeFeed)
    ]
}
