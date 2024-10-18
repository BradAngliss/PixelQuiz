//
//  PixelQuizViewModel.swift
//  PixelQuiz
//
//  Created by Brad Angliss on 18/10/2024.
//

import SwiftUI

public class PixelQuizViewModel: ObservableObject, Identifiable {
    @Published var currentScore: Float = 20
    @Published var totalScore: Int = 0
    @Published var answer: String = ""

    @Published var isPixelated: Bool = true
    @Published var isIncorrect: Bool = false
    @Published var isIncorrectImage: Bool = false    
    @Published var currentImageIndex: Int = 0

    // Custom color definitions
    public let background: Color = Color(hex: "#09111F")
    public let tint: Color = Color(hex: "#C9CBA3")
    public let textBackground: Color = Color(hex: "#12233F")

    public let images: [ImageCard] = [
        ImageCard(image: Image(.cat2), answer: "cat"),
        ImageCard(image: Image(.dog), answer: "dog"),
        ImageCard(image: Image(.shark), answer: "shark")
    ]

    public var isCorrectAnswer: Bool {
        images[currentImageIndex].answer == answer.lowercased()
    }

    public func increaseTotalScore() -> Void {
        totalScore += Int(currentScore)
    }
    
    public func updateCurrentScore() -> Void {
        guard isPixelated else { return }
        currentScore -= 0.4
        if currentScore <= 0 {
            isPixelated = false
            currentScore = 0
        }
    }

    public func incremenetImageIndex() -> Bool {
        if currentImageIndex + 1 >= images.count { return false }
        currentImageIndex += 1
        return true
    }

    public func resetGameState() -> Void {
        answer = ""
        currentScore = 20
        isPixelated = true
    }
}
