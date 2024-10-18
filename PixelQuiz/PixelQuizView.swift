//
//  ContentView.swift
//  PixelQuiz
//
//  Created by Brad Angliss on 17/04/2024.
//

import SwiftUI

struct PixelQuizView: View {
    @StateObject var viewModel = PixelQuizViewModel()
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var linearGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, .primary.opacity(0.3), .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { reader in
                HStack(alignment: .center) {
                    Spacer()
                    Text("Pixel Game")
                        .font(.title)
                    Spacer()
                    Text(viewModel.totalScore.description)
                        .font(.title)
                }
                Divider()
                    .overlay(viewModel.tint)
                    .padding(.bottom, 15)
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 60) {
                            ForEach(0 ..< viewModel.images.count, id: \.self) { i in
                                viewModel.images[i].image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 360, height: 500)
                                    .if(viewModel.isPixelated, transform: { view in
                                        view
                                            .layerEffect(ShaderLibrary.pixellate(.float(viewModel.currentScore)), maxSampleOffset: .zero, isEnabled: viewModel.isPixelated)
                                    })
                                    .onReceive(timer, perform: { _ in
                                        viewModel.updateCurrentScore()
                                    })
                                    .cornerRadius(50)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 50)
                                            .strokeBorder(linearGradient, lineWidth: 2)
                                    }
                                    .padding(.top, 15)
                                    .shadow(color: .black, radius: 5)
                                    .offset(x: viewModel.isIncorrectImage ? -10 : 0)
                                    .id(i)
                                    .scrollTransition { content, phase in
                                        content
                                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                            .rotationEffect(.degrees(phase.isIdentity ? 0 : -30))
                                            .rotation3DEffect(.degrees(phase.isIdentity ? 0 : 60), axis: (x: -1, y: 1, z: 0))
                                            .blur(radius: phase.isIdentity ? 0 : 20)
                                            .offset(x: phase.isIdentity ? 0 : -20)
                                    }
                            }
                            
                        }
                    }
                    .scrollDisabled(true)
                    Spacer()
                    textInput(reader: reader)
                    
                }
            }
            .padding()
            .background(viewModel.background.opacity(1))
            .foregroundStyle(viewModel.tint)
        }
    }

    @ViewBuilder
    private func textInput(reader: ScrollViewProxy) -> some View {
        TextField("", text: $viewModel.answer, prompt: Text("Answer")
            .foregroundColor(.white.opacity(0.3)))
            .padding(20)
            .background(viewModel.textBackground)
            .cornerRadius(10)
            .padding(.top, 35)
            .overlay {
                textInputButton(reader: reader)
            }
    }

    @ViewBuilder
    private func textInputButton(reader: ScrollViewProxy) -> some View {
        Button {
            if viewModel.isCorrectAnswer {
                viewModel.increaseTotalScore()
                if(viewModel.incremenetImageIndex()) {
                    withAnimation(.easeInOut(duration: 3)) {
                        reader.scrollTo(viewModel.currentImageIndex)
                    }
                    viewModel.resetGameState()
                }
            } else {
                withAnimation(.bouncy) {
                    viewModel.isIncorrect.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        viewModel.isIncorrect.toggle()
                    }
                }
                withAnimation(.easeInOut.repeatCount(4).speed(4)) {
                    viewModel.isIncorrectImage.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        viewModel.isIncorrectImage.toggle()
                    }
                }
            }
        } label: {
            Circle()
                .fill(.ultraThinMaterial)
                .padding()
                .overlay {
                    Image(systemName: viewModel.isIncorrect ? "xmark" : "checkmark")
                        .contentTransition(.symbolEffect(.replace, options: .speed(3)))
                        .font(.system(size: 20))
                        .frame(width: 50, height: 50)
                        .colorMultiply(viewModel.isIncorrect ? .red : viewModel.tint)
                }
                .frame(width: 75)
        }
        .offset(x: 150, y: 17)
    }
}

#Preview {
    PixelQuizView()
}
