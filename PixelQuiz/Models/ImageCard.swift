//
//  ImageCard.swift
//  PixelQuiz
//
//  Created by Brad Angliss on 17/04/2024.
//

import SwiftUI

public struct ImageCard: Identifiable {
    public var id = UUID()
    var image: Image
    var answer: String
}
