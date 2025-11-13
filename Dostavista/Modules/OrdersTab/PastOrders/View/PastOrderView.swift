//
//  PastOrderView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct PastOrderView: View {
    
    @State var vm: PastOrdersViewModel
    
    init(router: OrdersRouter) {
        let coordinator = PastOrdersCoordinator(router: router)
        _vm = State(initialValue: PastOrdersViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: .zero) {
                header
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16.fitH) {
                        mainInfo
                        
                        raiting
                            .padding(.horizontal)

                        detailInfo
                            .padding(.horizontal)

                        route
                            .padding(.horizontal)
                        
                        troubles
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.grayF2F2F2)

            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    
    private var mainInfo: some View {
        VStack(alignment: .center, spacing: .zero) {
            Image(.greenBigDoneIcon2)
                .resizable()
                .frame(width: 80, height: 80)
                .shadow(color: .green00D40E1A.opacity(0.6), radius: 10, x: 0, y: 7)
                .padding(.bottom)
            
            Text("Заказ выполнен!")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .padding(.bottom, 8)

            Text("Сегодня, 14:32")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.gray6B7280)
                .padding(.bottom)
            
            VStack(alignment: .center, spacing: 12) {
                Text("790 ₽")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.purple8B5CF6)
                
                HStack {
                    Text("Базовая оплата")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray6B7280)
                    
                    Spacer()
                    
                    Text("710 ₽")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.gray6B7280)
                }
                
                HStack {
                    HStack(spacing: 2) {
                        Image(.purpleFlashMiniIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("Бонус")
                            .font(.system(size: 15))
                            .foregroundStyle(.purple8B5CF6)
                    }
                    Spacer()
                    
                    Text("+80 ₽")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.purple8B5CF6)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 5)
            )

        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(
            LinearGradient(
                colors: [.whiteF0FDF4, .whiteF5F3FF],
                startPoint: .top, endPoint: .bottom
            )
        )
    }
    
    @ViewBuilder
    private var raiting: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Оценка клиента")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)
                Text("Отлично!")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.black.opacity(0.4))
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(0..<5) { _ in
                    Image(.starIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .strokeBorder(.black.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var detailInfo: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .center, spacing: .zero) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("#102")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Text("Отлично!")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.gray6B7280)
                }
                
                Spacer()
                
                Pill(
                    text: OrderTag.urgent.title,
                    foreground: OrderTag.urgent.foreground,
                    background: OrderTag.urgent.background,
                    forMain: false
                )
            }
            .padding(.bottom)
            
            Divider()
                .padding(.bottom)

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(.grayMiniClockIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("Время")
                            .font(.system(size: 13))
                            .foregroundStyle(.black.opacity(0.4))
                    }
                    
                    Text("24 мин")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(.grayMiniGeoIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("Дистанция")
                            .font(.system(size: 13))
                            .foregroundStyle(.black.opacity(0.4))
                    }
                    
                    Text("2.3 км")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(.miniBoxIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("Тип")
                            .font(.system(size: 13))
                            .foregroundStyle(.black.opacity(0.4))
                    }
                    
                    Text("Посылка 3 кг")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
                
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .strokeBorder(.black.opacity(0.1), lineWidth: 0.5)
        )
    }
    private var route: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Маршрут")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                
                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .center, spacing: 20) {
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
                    .frame(maxHeight: 135)
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .strokeBorder(.black.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var troubles: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(.dialogBlueIcon)
                .resizable()
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Проблемы с заказом?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black)
                Text("Свяжитесь со службой поддержки")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.blue2B7FFF1A)
                    .lineLimit(2)
                    .padding(.bottom, 4)
                
                Text("Написать в поддержку")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.blue2B7FFF1A)
                    .lineLimit(2)
                    .onTapGesture {
                        print("TAP")
                    }
            }
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.blue2B7FFF1A.opacity(0.1))
                .strokeBorder(.blue2B7FFF1A.opacity(0.3), lineWidth: 1)
        )
    }
    private var header: some View {
        HStack {
            Button {
                vm.pop()
                print("pop")
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
            Text("Детали заказа")
                .font(.system(size: 17.fitW, weight: .semibold))
                .foregroundStyle(.black)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    PastOrderView(router: OrdersRouter())
}
