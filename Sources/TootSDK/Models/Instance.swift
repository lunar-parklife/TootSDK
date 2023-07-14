// Created by konstantin on 02/11/2022
// Copyright (c) 2022. All rights reserved.

import Foundation

/// General information about an instance
public struct Instance: Codable, Hashable {
    public init(uri: String? = nil, title: String? = nil, description: String? = nil, shortDescription: String? = nil, email: String? = nil, version: String, languages: [String]? = nil, registrations: Bool? = nil, approvalRequired: Bool? = nil, invitesEnabled: Bool? = nil, urls: Instance.InstanceURLs, stats: Instance.Stats, thumbnail: String? = nil, contactAccount: Account? = nil, statuses: Statuses? = nil) {
        self.uri = uri
        self.title = title
        self.description = description
        self.shortDescription = shortDescription
        self.email = email
        self.version = version
        self.languages = languages
        self.registrations = registrations
        self.approvalRequired = approvalRequired
        self.invitesEnabled = invitesEnabled
        self.urls = urls
        self.stats = stats
        self.thumbnail = thumbnail
        self.contactAccount = contactAccount
        self.statuses = statuses
    }

    /// The domain name of the instance.
    public var uri: String?
    /// The title of the website.
    public var title: String?
    /// Admin-defined description of the Fediverse site.
    public var description: String?
    /// A shorter description defined by the admin.
    public var shortDescription: String?
    /// An email that may be contacted for any inquiries.
    public var email: String?
    /// The version of  the server installed on the instance.
    public var version: String
    /// Primary languages of the website and its staff.
    public var languages: [String]?
    /// Whether registrations are enabled.
    public var registrations: Bool?
    /// Whether registrations require moderator approval.
    public var approvalRequired: Bool?
    /// Whether invites are enabled.
    public var invitesEnabled: Bool?
    /// URLs of interest for clients apps.
    public var urls: InstanceURLs?
    /// Statistics about how much information the instance contains.
    public var stats: Stats
    /// Banner image for the website.
    public var thumbnail: String?
    /// A user that can be contacted, as an alternative to email.
    public var contactAccount: Account?
    /// Information about what statuses can contain on this instance.
    public var statuses: Statuses?

    public struct InstanceURLs: Codable, Hashable {
        /// Websockets address for push streaming. String (URL).
        public var streamingApi: String?
    }

    public struct Stats: Codable, Hashable {
        /// Users registered on this instance. Number.
        public var userCount: Int?
        /// Posts authored by users on instance. Number.
        public var postCount: Int?
        /// Domains federated with this instance. Number.
        public var domainCount: Int?

        enum CodingKeys: String, CodingKey { // swiftlint:disable:this nesting
            case userCount
            case postCount = "status_count"
            case domainCount
        }
    }
}

public extension Instance {
    var majorVersion: Int? {
        guard let majorVersionString = version.split(separator: ".").first else { return nil }

        return Int(majorVersionString)
    }

    var minorVersion: Int? {
        let versionComponents = version.split(separator: ".")

        guard versionComponents.count > 1 else { return nil }

        return Int(versionComponents[1])
    }

    var patchVersion: String? {
        let versionComponents = version.split(separator: ".")

        guard versionComponents.count > 2 else { return nil }

        return String(versionComponents[2])
    }

    var canShowProfileDirectory: Bool {
        guard let majorVersion = majorVersion else { return false }

        return majorVersion >= 3
    }
}

public extension Instance {
    var flavour: TootSDKFlavour {
        if version.lowercased().contains("pleroma") {
            return .pleroma
        }
        if version.lowercased().contains("pixelfed") {
            return .pixelfed
        }
        if version.lowercased().contains("friendica") {
            return .friendica
        }
        if version.lowercased().contains("akkoma") {
            return .akkoma
        }
        return .mastodon
    }
}
