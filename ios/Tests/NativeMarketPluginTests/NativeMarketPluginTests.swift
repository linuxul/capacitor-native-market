import XCTest
import Capacitor
@testable import NativeMarketPlugin

class NativeMarketTests: XCTestCase {
    func testMethodTable() {
        let plugin = NativeMarket()

        XCTAssertEqual(plugin.jsName, "NativeMarket")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), ["openStoreListing", "openDevPage", "openCollection", "openEditorChoicePage", "search"])
        XCTAssertTrue(plugin.pluginMethods.allSatisfy { $0.returnType == .promise })
    }

    @MainActor
    func testOpenStoreListingWithoutAnAppIdThrows() async {
        await assertThrows("appId is missing") { try await NativeMarket().openStoreListing(Self.call("openStoreListing", [:])) }
    }

    @MainActor
    func testSearchWithoutTermsThrows() async {
        await assertThrows("terms is missing") { try await NativeMarket().search(Self.call("search", [:])) }
    }

    @MainActor
    func testALinkTheSystemCannotOpenThrows() async {
        // The test host has no App Store and does not list itms-apps in LSApplicationQueriesSchemes; the call used
        // to stay pending in this case.
        let link = "itms-apps://itunes.apple.com/app/id000000000"
        await assertThrows("Unable to open \(link)") { try await NativeMarket.open(link) }
    }

    @MainActor
    private func assertThrows(_ message: String, _ body: () async throws -> Void, line: UInt = #line) async {
        do {
            try await body()
            XCTFail("expected \(message)", line: line)
        } catch let error as CAPPluginError {
            XCTAssertEqual(error.message, message, line: line)
            XCTAssertNil(error.code, line: line)
        } catch {
            XCTFail("unexpected \(error)", line: line)
        }
    }

    private static func call(_ method: String, _ options: JSObject) -> CAPPluginCall {
        CAPPluginCall(callbackId: "test", methodName: method, options: options, success: { _, _ in
            XCTFail("\(method) answers by returning")
        }, error: { _ in
            XCTFail("\(method) answers by throwing")
        })
    }
}
