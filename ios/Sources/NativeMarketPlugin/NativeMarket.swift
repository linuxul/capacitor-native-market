import Foundation
import UIKit
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NativeMarketPlugin)
public class NativeMarket: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "NativeMarket"
    public let jsName = "NativeMarket"
    public let pluginMethods: [CAPPluginMethod] = [
        .async("openStoreListing", NativeMarket.openStoreListing),
        .promise("openDevPage", NativeMarket.openDevPage),
        .promise("openCollection", NativeMarket.openCollection),
        .promise("openEditorChoicePage", NativeMarket.openEditorChoicePage),
        .async("search", NativeMarket.search)
    ]

    /// Opens the App Store page of the app. UIApplication is main-thread API, so the method runs on the main actor.
    @MainActor
    func openStoreListing(_ call: CAPPluginCall) async throws {
        guard let appId = call.getString("appId") else {
            throw CAPPluginError("appId is missing")
        }
        try await Self.open("itms-apps://itunes.apple.com/app/" + appId)
    }

    // openDevPage, openCollection and openEditorChoicePage are Google Play pages the App Store has no counterpart for.
    // They are not supported on iOS and resolve without opening anything, as they always have.

    func openDevPage(_ call: CAPPluginCall) {
        call.resolve()
    }

    func openCollection(_ call: CAPPluginCall) {
        call.resolve()
    }

    func openEditorChoicePage(_ call: CAPPluginCall) {
        call.resolve()
    }

    /// Opens an App Store search. UIApplication is main-thread API, so the method runs on the main actor.
    @MainActor
    func search(_ call: CAPPluginCall) async throws {
        guard let terms = call.getString("terms") else {
            throw CAPPluginError("terms is missing")
        }
        try await Self.open("itms-apps://itunes.apple.com/search?term=" + terms)
    }

    /// Opens `link` and returns once UIApplication handled it, whether or not it succeeded, as before. Throws when
    /// `link` is not a URL or the system cannot open it (no App Store, as on the simulator, or `itms-apps` missing
    /// from `LSApplicationQueriesSchemes`).
    @MainActor
    static func open(_ link: String) async throws {
        guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            throw CAPPluginError("Unable to open \(link)")
        }
        _ = await UIApplication.shared.open(url, options: [:])
    }
}
