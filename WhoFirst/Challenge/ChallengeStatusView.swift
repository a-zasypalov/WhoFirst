//
//  ChallengeStatusView.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import SwiftUI

struct ChallengeStatusView: View {
    
    @ObservedObject private var viewModel = ChallengeViewModel()
    
    let lightGreyColor = Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, opacity: 1.0)
    let blueColor = Color(red: 77.0/255.0, green: 97.0/255.0, blue: 252.0/255.0, opacity: 1.0)
    let blueLightColor = Color(red: 77.0/255.0, green: 97.0/255.0, blue: 252.0/255.0, opacity: 0.8)
    
    init() {
        viewModel.getChallenge()
    }
    
    var body: some View {
        if(viewModel.challenge == nil || viewModel.current == nil) {
            VStack(alignment: .center) {
                Image(viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 20)
                ProgressView()
            }
        } else {
            VStack(alignment: .center) {
                
                Image(viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 40)
                
                Text(viewModel.challenge!.title)
                    .fontWeight(.medium)
                    .font(.largeTitle)
                    .padding(.bottom, 2)
                
                if(viewModel.status == ChallengeViewModel.STATUS_PLAY) {
                    Spacer()
                    Button(action: {
                        viewModel.tryToWinToday()
                    }){
                        Text(viewModel.challenge!.button).font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(blueColor)
                            .cornerRadius(15.0)
                    }
                } else if(viewModel.status == ChallengeViewModel.STATUS_WINNER) {
                    Text(viewModel.challenge!.winnerText)
                        .fontWeight(.medium)
                        .font(.largeTitle)
                } else if(viewModel.status == ChallengeViewModel.STATUS_LOSER) {
                    Text(viewModel.challenge!.loserText)
                        .fontWeight(.medium)
                        .font(.largeTitle)
                }
                
            }.padding()
        }
    }
    
}
