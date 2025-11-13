//
//  TextHelpers.swift
//  Helpers
//
//  Created by Abylaikhan Abilkayr on 05.11.2025.
//


import SwiftUI

extension Text {
    func oneLineMinimumScale() -> some View {
        self.multipleLinesMinimumScale(1)
    }
    
    func multipleLinesMinimumScale(_ linesCount: Int) -> some View {
        self.lineLimit(linesCount).minimumScaleFactor(0.5)
    }
}
