//
//  OrderDetailView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 08.11.2025.
//


import SwiftUI

struct OrderDetailView: View {
    
    @State var vm: OrderDetailViewModel
    
    init(order: FullOrder, router: MainRouter) {
        let coordinator = OrderDetailCoordinator(router: router)
        _vm = State(initialValue: OrderDetailViewModel(coordinator: coordinator, order: order))
    }
    
    init(order: FullOrder, router: OrdersRouter) {
        let coordinator = ActiveOrderDetailCoordinator(router: router)
        _vm = State(initialValue: OrderDetailViewModel(coordinator: coordinator, order: order))
    }
    
    @Environment(\.openURL) private var openURL

    private func callPhone(_ raw: String) {
        let allowed = Set("+0123456789")
        let cleaned = raw.filter { allowed.contains($0) }
        guard let url = URL(string: "tel://\(cleaned)") else { return }
        openURL(url)
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: .zero) {
                header
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16.fitH) {
                        mainInfo
                        
                        openMapButton
                        
                        route
                        
                        timeAndWeightViews
                        
                        payment
                        
                        note
                        
                        totalView
                            .padding(.bottom, 100)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20.fitH)
                }
                .frame(maxWidth: .infinity)
                .background(.grayF2F2F2)
                
                bottomButton
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    
    private var mainInfo: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack(alignment: .center, spacing: .zero) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .center, spacing: 16.fitW) {
                        Text("Вознаграждение")
                            .font(.system(size: 15))
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    HStack(alignment: .center, spacing: 16.fitW) {
                        Text("\(Int(vm.order.price_usd)) ₽")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        
                        HStack(alignment: .center, spacing: 4.fitW) {
                            Image(.flashMiniIcon)
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text("+80 ₽")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.2))
                        )
                    }
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 8) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.2))
                        .frame(width: 72, height: 28)
                        .overlay {
                            Text("Срочно")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.2))
                        .frame(width: 72, height: 28)
                        .overlay {
                            Text("Рядом")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.white)
                        }
                }
                
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 23.fitW) {
                HStack(alignment: .center, spacing: 6.fitW) {
                    Image(.compassMiniIcon)
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                    Text("\(String(format: "%.1f", vm.order.distance_km)) км")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white)
                }
                
                HStack(alignment: .center, spacing: 6.fitW) {
                    Image(.miniClockWhiteIcon)
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                    Text("\(vm.order.delivery_minutes) мин")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [.purple8B5CF6, .purple6D3ED6], startPoint: .top, endPoint: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(alignment: .bottomLeading) {
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 96, height: 96)
                .offset(x: -25, y: 45)
        }
        .overlay(alignment: .bottomTrailing) {
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 127, height: 127)
                .offset(x: 75, y: 70)
        }
    }
    
    private var openMapButton: some View {
        Button {
            vm.openMap()
        } label: {
            Text("Открыть карту")
                .font(.system(size: 16.fitW, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16.fitH)
                .background(Color("purple8B5CF6"))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        
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
                            
                            Text(vm.order.from_address)
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.4))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: .zero) {
                            
                            Text("Куда")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            Text(vm.order.to_address)
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
                .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
        )
    }
    
    private var timeAndWeightViews: some View {
        HStack(alignment: .center, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: .zero) {
                    Image(.timeBigIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.bottom, 12)
                    
                    Text("Время доставки")
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.4))
                        .padding(.bottom, 4)
                    
                    Text("\(vm.order.delivery_minutes) мин")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)

                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .strokeBorder(.black.opacity(0.1), lineWidth: 1)
                    .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
            )
            
            HStack {
                VStack(alignment: .leading, spacing: .zero) {
                    Image(.boxBigIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.bottom, 12)
                    
                    Text("Тип груза")
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.4))
                        .padding(.bottom, 4)
                    
                    Text("Посылка \(vm.order.weight_kg) кг")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)

                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .strokeBorder(.black.opacity(0.1), lineWidth: 1)
                    .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
            )
        }
    }
    
    private var payment: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(.moneyBigIcon)
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(spacing: 4) {
                Text("Оплата")
                    .font(.system(size: 13))
                    .foregroundStyle(.black.opacity(0.4))
                Text("Карта")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .strokeBorder(.black.opacity(0.1), lineWidth: 1)
                .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
        )
    }
    
    private var note: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(.noteIcon)
                .resizable()
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Заметка клиента")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black)
                Text(vm.order.note)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.orangeFF85021A)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.orangeFFFBEB)
                .strokeBorder(.orangeFF85021A, lineWidth: 1)
        )
    }
    
    private var totalView: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center) {
                Text("Итого к выплате")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.black.opacity(0.4))
                Spacer()
                Text("\(Int(vm.order.price_usd)) ₽")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.purple8B5CF6)
                    .lineLimit(1)
            }
            
            Divider()
                .background(.black.opacity(0.1))
                .frame(height: 1)
            
            HStack(alignment: .center) {
                HStack(spacing: 6) {
                    Image(.purpleFlashMiniIcon)
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("Бонус")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.purple8B5CF6)
                }
                Spacer()
                Text("+80 ₽")
                    .font(.system(size:15, weight: .semibold))
                    .foregroundStyle(.purple8B5CF6)
                    .lineLimit(1)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.purple8B5CF6.opacity(0.05))
                .strokeBorder(.purple8B5CF6.opacity(0.2), lineWidth: 1)
                .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
        )
    }
    // MARK: - Header (кастомный)
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
    
    
    // MARK: - Нижняя кнопка
    private var bottomButton: some View {
        VStack(alignment: .center, spacing: .zero) {
            Divider()
                .background(.black.opacity(0.1))
                .frame(height: 1)
            
            VStack(alignment: .center, spacing: 12) {
                Button {
                    vm.push()
                } label: {
                    Text("Продолжить")
                        .font(.system(size: 16.fitW, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16.fitH)
                        .background(Color("purple8B5CF6"))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                
                HStack(spacing: 12) {
                    Button {
                        callPhone(vm.order.sender_phone)
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.grayF2F2F2)
                            .frame(height: 54)
                            .overlay {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(.phoneMiniIcon)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .offset(y: 1)
                                    Text("Позвонить")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.black)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        vm.openChat()
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.grayF2F2F2)
                            .frame(height: 54)
                            .overlay {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(.chatMiniIcon)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Чат")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.black)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 20.fitH)
            .padding(.horizontal, 24.fitW)
        }
        .padding(.bottom, 10.fitH)
    }
}
