//
//  TootClient+Account.swift
//
//
//  Created by dave on 25/11/22.
//

import Foundation

extension TootClient {

    /// A test to make sure that the user token works, and retrieves the account information
    /// - Returns: Returns the current authenticated user's account, or throws an error if unable to retrieve
    public func verifyCredentials() async throws -> Account {
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", "verify_credentials"])
            $0.method = .get
        }
        return try await fetch(Account.self, req)
    }

    /// View information about a profile.
    /// - Parameter id: the ID of the Account in the instance database.
    /// - Returns: the account requested, or an error if unable to retrieve
    public func getAccount(by id: String) async throws -> Account {
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", id])
            $0.method = .get
        }
        return try await fetch(Account.self, req)
    }

    /// Get all accounts which follow the given account, if network is not hidden by the account owner.
    /// - Parameters
    ///     - id: the ID of the Account in the instance database.
    ///     - pageInfo: PagedInfo object for max/min/since
    ///     - limit: Maximum number of results to return. Defaults to 40 accounts. Max 80 accounts.
    /// - Returns: the accounts requested, or an error if unable to retrieve
    public func getFollowers(for id: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> PagedResult<[Account]> {
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", id, "followers"])
            $0.method = .get
            $0.query = getQueryParams(pageInfo, limit: limit)
        }

        return try await fetchPagedResult(req)
    }

    /// Get all accounts which the given account is following, if network is not hidden by the account owner.
    /// - Parameters:
    ///     - id: the ID of the Account in the instance database.
    ///     - pageInfo: PagedInfo object for max/min/since
    ///     - limit: Maximum number of results to return. Defaults to 40 accounts. Max 80 accounts.
    /// - Returns: the accounts requested, or an error if unable to retrieve
    public func getFollowing(for id: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> PagedResult<[Account]> {
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", id, "following"])
            $0.method = .get
            $0.query = getQueryParams(pageInfo, limit: limit)
        }

        return try await fetchPagedResult(req)
    }

    /// Attempts to register a user.
    ///
    /// Returns an account access token for the app that initiated the request. The app should save this token for later, and should wait for the user to confirm their account by clicking a link in their email inbox.
    public func registerAccount(params: RegisterAccountParams) async throws -> AccessToken {
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts"])
            $0.method = .post
            $0.body = try .json(params, encoder: self.encoder)
        }

        do {
            let (data, _) = try await fetch(req: req)
            return try decode(AccessToken.self, from: data)
        } catch {
            if case let TootSDKError.invalidStatusCode(data, _) = error {
                if let decoded = try? decode(RegisterAccountErrors.self, from: data), let message = decoded.error {
                    throw TootSDKError.serverError(message)
                }
            }
            throw error
        }
    }

    /// Search for matching accounts by username or display name.
    ///
    /// - Parameters:
    ///   - params: The search parameters.
    ///   - limit: Maximum number of results to return. Defaults to 40. Max 80 accounts.
    ///   - offset: Skip the first n results.
    /// - Returns: Search results.
    public func searchAccounts(params: SearchAccountsParams, limit: Int? = nil, offset: Int? = nil) async throws -> [Account] {
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", "search"])
            $0.method = .get
            $0.query = getQueryParams(limit: limit, offset: offset) + params.queryItems
        }
        return try await fetch([Account].self, req)
    }

    // swiftlint:disable todo
    // TODO: - Update account credentials

    // TODO: - Get lists containing this account
    // TODO: - Feature account on your profile
    // TODO: - Unfeature account from profile
    // TODO: - Set private note on profile

    // TODO: - Find familiar followers
    // TODO: - Lookup account ID from Webfinger address
    // swiftlint:enable todo
}
