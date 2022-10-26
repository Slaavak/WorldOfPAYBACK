//
//  MappableHelper.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class MappableHelper: ImmutableMappable {

    // MARK: - Construction

    required public init(map: Map) throws {
        self.map = map
    }

    // MARK: - Variables
    private var map: Map
}
