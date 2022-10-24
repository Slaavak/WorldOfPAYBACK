//
//  PBAliasOM.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class PBAliasOM: MappableHelper {

    /// Ссылка
    public private(set) var reference: String

    required public init(map: Map) throws {
        reference = try map.value(Constants.reference)

        try super.init(map: map)
    }

    public func mapping(map: Map) {
        super.mapping(map: map)

        reference <- map[Constants.reference]
    }

    // MARK: - Constants

    private enum Constants {
        static let reference = "reference"
    }
}
