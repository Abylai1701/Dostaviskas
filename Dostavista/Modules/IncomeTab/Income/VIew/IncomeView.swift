//
//  IncomeView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct IncomeView: View {
    @State var vm: IncomeViewModel
    @State private var isWithdrawSheetPresented = false

    init(vm: IncomeViewModel) {
        _vm = State(initialValue: vm)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: .zero) {
                header
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .zero) {
                        firstSection
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                            .padding(.top, 20)
                        
                        Text("Начисления")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.black)
                            .padding(.horizontal)
                            .padding(.bottom, 14)
                        
                        secondSection
                            .padding(.horizontal)
                            .padding(.bottom, 130)

                    }
                }
            }
            .background(.grayF2F2F2)
            
            if isWithdrawSheetPresented {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isWithdrawSheetPresented) {
            WithdrawSheetView()
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.hidden)
        }
        .animation(.spring(duration: 0.4), value: isWithdrawSheetPresented)
    }
    
    private var firstSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: 30.fitW) {
                    Image(.blueCheckIcon)
                        .resizable()
                        .frame(width: 32.fitW, height: 32.fitW)
                    
                    Text("+0")
                        .font(.system(size: 12.fitW))
                        .foregroundStyle(.green00D40E1A)
                }
                .padding(.bottom, 12)
                
                Text("0")
                    .font(.system(size: 17.fitW, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.bottom, 8)
                
                Text("Заказов \nвыполнено")
                    .font(.system(size: 12.fitW))
                    .foregroundStyle(.gray6B7280)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12.fitW)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
            )
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: .zero) {
                    HStack(spacing: 30.fitW) {
                        Image(.greenChartIcon)
                            .resizable()
                            .frame(width: 32.fitW, height: 32.fitW)
                        
                        Text("+0")
                            .font(.system(size: 12.fitW))
                            .foregroundStyle(.green00D40E1A)
                    }
                    .padding(.bottom, 12)
                    
                    Text("0₽")
                        .font(.system(size: 17.fitW, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.bottom, 8)
                    
                    Text("Средний \nдоход/час")
                        .font(.system(size: 12.fitW))
                        .foregroundStyle(.gray6B7280)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12.fitW)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
                )
            }
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: .zero) {
                    HStack(spacing: 30.fitW) {
                        Image(.orangeStarIcon)
                            .resizable()
                            .frame(width: 32.fitW, height: 32.fitW)
                        
                        Text("+0")
                            .font(.system(size: 12.fitW))
                            .foregroundStyle(.green00D40E1A)
                    }
                    .padding(.bottom, 12)
                    
                    Text("5")
                        .font(.system(size: 17.fitW, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.bottom, 8)
                    
                    Text("Средний \nРейтинг")
                        .font(.system(size: 12.fitW))
                        .foregroundStyle(.gray6B7280)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12.fitW)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
                )
            }
        }
    }
    
    private var secondSection: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Image(.blueCheckIcon)
                    .resizable()
                    .size(48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Заказы")
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.4))
                    
                    Text("0 ₽")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
            )
            
            HStack(alignment: .center, spacing: 12) {
                Image(.giftIcon)
                    .resizable()
                    .size(48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Бонусы")
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.4))
                    
                    Text("0 ₽")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
            )
            
            HStack(alignment: .center, spacing: 12) {
                Image(.orangeStarIcon)
                    .resizable()
                    .size(48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Чаевые")
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.4))
                    
                    Text("0 ₽")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
            )
        }
    }
    private var header: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Доход")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    isWithdrawSheetPresented = true
                } label: {
                    Image(.walletIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Доступно к выводу")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.8))
                
                HStack(alignment: .bottom, spacing: 6) {
                    Text("0")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("₽")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
        }
        .padding(.horizontal ,24)
        .padding(.bottom ,24)
        .safeTopPadding(12)
        .background(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.purple8B5CF6, .purple6D3ED6],
                        startPoint: .top, endPoint: .bottom
                    )
                )
        )
        .overlay(alignment: .bottomLeading) {
            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 127, height: 127)
                .offset(x: -65, y: 100)
        }
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 160, height: 160)
                .offset(x: 75, y: -85)
        }
    }
}

#Preview {
    IncomeView(vm: IncomeViewModel())
}
