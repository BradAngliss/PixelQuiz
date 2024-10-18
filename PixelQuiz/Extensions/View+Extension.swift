//
//  View+Extension.swift
//  DesignCode
//
//  Created by Brad Angliss on 17/04/2024.
//

import SwiftUI

// Modifier to perform conditionals on a view
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
