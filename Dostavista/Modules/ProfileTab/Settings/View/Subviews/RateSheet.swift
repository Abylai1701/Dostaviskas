//
//  RateSheet.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import SwiftUI
import StoreKit

struct RateSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: .zero) {
            header
                .padding(.bottom, 20)
            
            Spacer()
            
            
            content
                .padding(.horizontal)
                .padding(.bottom, 24)
            
            Spacer()
            Spacer()
        }
        .background(.grayF2F2F2)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var content: some View {
        VStack(alignment: .center) {
            Image(.girlIcon)
                .resizable()
                .frame(width: 215, height: 323)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .grayF2F2F2, .grayF2F2F2],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 331, height: 170)
                        .offset(y: 30)
                        .overlay(alignment: .bottom) {
                            VStack(alignment: .center, spacing: .zero) {
                                Text("Вам нравится наше приложение?")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.black)
                                    .padding(.bottom, 8)
                                
                                Text("Оцените наше приложение, чтобы мы могли его улучшить и сделать еще круче!")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                                
                                HStack(spacing: 12) {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Text("Позже")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundStyle(.purple8B5CF6)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(.purple8B5CF6.opacity(0.2))
                                            )
                                    }
                                    
                                    Button {
                                        requestReviewOrOpenStore()
                                    } label: {
                                        Text("Оценить")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(.purple8B5CF6)
                                            )
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            .offset(y: 80)
                        }
                }
            
        }
    }
    
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(.backIcon)
                    .resizable()
                    .frame(width: 20, height: 16)
                    .padding(16)
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .overlay {
            Text("Оценить")
                .font(.system(size: 17.fitW, weight: .semibold))
                .foregroundStyle(.black)
        }
        .padding(.bottom, 8)
        .background(.white)
    }
    
    func requestReviewOrOpenStore() {
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    RateSheet()
}
