// Created by Luna on 2023-07-06.
// Copyright (c) 2023. All rights reserved.

import Foundation

/// The policy for posts on the remote host.
public struct Statuses {
    /// The number of characters a URL is assumed to take up on this instance.
    public let charactersReservedPerURL: Int
    /// The maximum length of a post on this instance, in characters.
    public let maxCharacters: Int
    /// The maximum number of media attachments any post can have on this instance.
    public let maxMediaAttachments: Int
    
    public init(charactersReservedPerURL: Int, maxCharacters: Int, maxMediaAttachments: Int) {
        self.charactersReservedPerURL = charactersReservedPerURL
        self.maxCharacters = maxCharacters
        self.maxMediaAttachments = maxMediaAttachments
    }
}
