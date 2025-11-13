//
//  HistoryCardView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import Foundation
import SwiftUI

struct HistoryCardView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .center) {
                    Text("Заказ #A001")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray6B7280)
                    
                    Spacer()
                    
                    Text("Сегодня, 14:32")
                        .font(.system(size: 13))
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
                
                HStack(alignment: .center, spacing: 16) {
                    Text("650 ₽")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.purple8B5CF6)
                    
                    HStack(alignment: .center, spacing: 2) {
                        Image(.purpleFlashMiniIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("+50₽")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.purple8B5CF6)
                    }
                    .padding(.horizontal, 8.5)
                    .padding(.vertical, 5.5)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.purple8B5CF6.opacity(0.1))
                    )
                }
                .padding(.bottom, 28)

                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .center, spacing: 12) {
                        Image(.purpleBigAddressTag)
                            .resizable()
                            .frame(width: 33, height: 33)
                        
                        Rectangle()
                            .fill(.purple8B5CF6.opacity(0.1))
                            .frame(width: 2, height: 20)
                        
                        Image(.redBigAddressTag)
                            .resizable()
                            .frame(width: 33, height: 33)
                    }
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        VStack(alignment: .leading, spacing: .zero) {
                            
                            Text("Откуда")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            Text("Москва, Тверская, 10")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.4))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: .zero) {
                            
                            Text("Куда")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            Text("Москва, Пушкина, 5")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.4))
                        }
                    }
                    .frame(maxHeight: 113)
                    
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .strokeBorder(.black.opacity(0.1), lineWidth: 1)
                .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
        )
    }
}

#Preview {
    ZStack {
        
        Color.gray.ignoresSafeArea()
        
        HistoryCardView()
            .padding()
    }
}
