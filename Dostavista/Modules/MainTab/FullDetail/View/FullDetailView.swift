//
//  FullDetailView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct FullDetailView: View {
    
    @State var vm: FullDetailViewModel
    @State private var isDetailsExpanded: Bool = false
    @State private var showCamera = false
    @State private var photoTaken = false

    @Environment(\.openURL) private var openURL

    private func callPhone(_ raw: String) {
        let allowed = Set("+0123456789")
        let cleaned = raw.filter { allowed.contains($0) }
        guard let url = URL(string: "tel://\(cleaned)") else { return }
        openURL(url)
    }
    
    init(router: MainRouter, order: FullOrder) {
        let coordinator = FullDetailCoordinator(router: router)
        _vm = State(initialValue: FullDetailViewModel(coordinator: coordinator, order: order))
    }
    
    init(ordersRouter: OrdersRouter, order: FullOrder) {
        let coordinator = FullDetailCoordinatorForOrders(router: ordersRouter)
        _vm = State(initialValue: FullDetailViewModel(coordinator: coordinator, order: order))
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: .zero) {
                header
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24.fitH) {
                        status
                            .padding(.horizontal, 12.fitW)
                        
                        senderOrRecepient
                            .padding(.horizontal, 16.fitW)
                        
                        expandableDetailsSection
                        
                        checkAndForgerSection
                            .padding(.horizontal, 16.fitW)
                    }
                    .padding(.top, 20.fitH)
                    .padding(.bottom, 134)
                }
                .frame(maxWidth: .infinity)
                .background(.grayF2F2F2)
                
                bottomButton
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var status: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(fisrtViewIcon)
                .resizable()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(vm.firstViewTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)
                
                HStack(alignment: .center, spacing: 24) {
                    HStack(alignment: .center, spacing: 6) {
                        Image(.grayMiniGeoIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("\(String(format: "%.1f", vm.order.distance_km)) км")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.black.opacity(0.6))
                    }
                    
                    HStack(alignment: .center, spacing: 6) {
                        Image(.grayMiniClockIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("\(vm.order.delivery_minutes) мин")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.black.opacity(0.6))
                    }
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
    
    @ViewBuilder
    private var senderOrRecepient: some View {
        switch vm.state {
        case .roadA:
            senderView
        case .took:
            senderView
        case .roadB:
            recepientView
        case .finish:
            recepientView
        }
    }
    private var senderView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                Image(.senderIcon)
                    .resizable()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Отправитель")
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.4))
                    
                    Text(vm.order.sender_name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Text("\(Int(vm.order.price_usd)) ₽")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.purple8B5CF6)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.purple8B5CF6.opacity(0.05))
                            .strokeBorder(.purple8B5CF6.opacity(0.2), lineWidth: 1)
                    }
            }
            
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center, spacing: 8) {
                    Image(.grayMiniGeoIcon2)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(vm.order.from_address)
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                }
                
                HStack(alignment: .center, spacing: 8) {
                    Image(.grayMiniPhoneIcon)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(vm.order.sender_phone)
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    private var recepientView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                Image(.recipientIcon)
                    .resizable()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Получатель")
                        .font(.system(size: 13))
                        .foregroundStyle(.black.opacity(0.4))
                    
                    Text(vm.order.receiver_name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Text("\(Int(vm.order.price_usd)) ₽")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.purple8B5CF6)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.purple8B5CF6.opacity(0.05))
                            .strokeBorder(.purple8B5CF6.opacity(0.2), lineWidth: 1)
                    }
            }
            
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center, spacing: 8) {
                    Image(.grayMiniGeoIcon2)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(vm.order.to_address)
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                }
                
                HStack(alignment: .center, spacing: 8) {
                    Image(.grayMiniPhoneIcon)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(vm.order.receiver_phone)
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                }
            }
            HStack(alignment: .center, spacing: 8) {
                Image(.purpleInfoIcon)
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text("Позвоните за 5 минут до прибытия")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.purple8B5CF6)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.grayF2F2F2)
                    .strokeBorder(.purple8B5CF6.opacity(0.2), lineWidth: 1)
            )
        }
    }
    private var expandableDetailsSection: some View {
        VStack(spacing: .zero) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isDetailsExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("Детали заказа")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(isDetailsExpanded ? .chevronUpMiniIcon : .chevronDownMiniIcon)
                        .resizable()
                        .frame(width: 12, height: 7)
                }
                .padding()
                .background(
                    Rectangle()
                        .strokeBorder(.black.opacity(0.1), lineWidth: 1)
                )
                .contentShape(
                    Rectangle()
                )
            }
            .buttonStyle(.plain)
            
            if isDetailsExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    detailRow(left: "Тип груза", right: "Посылка \(vm.order.weight_kg) кг")
                    detailRow(left: "Время доставки", right: "\(vm.order.delivery_minutes) мин")
                    detailRow(left: "Оплата", right: "Карта")
                        .padding(.bottom, 2)
                    
                    Divider().background(.black.opacity(0.1))
                        .padding(.bottom, 2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Примечание:")
                            .font(.system(size: 13))
                            .foregroundStyle(.black.opacity(0.4))
                        Text(vm.order.note)
                            .font(.system(size: 15))
                            .foregroundStyle(.black)
                    }
                }
                .padding()
                .background(.white)
            }
        }
    }
    
    @ViewBuilder
    private var checkAndForgerSection: some View {
        if vm.state == .roadB {
            HStack(alignment: .top, spacing: 12) {
                Image(.blueMiniInfoIcon)
                    .resizable()
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Не забудьте")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                    Text("Позвонить получателю за 5 минут до прибытия")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.blue2B7FFF1A)
                        .lineLimit(2)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.blue2B7FFF1A.opacity(0.1))
                    .strokeBorder(.blue2B7FFF1A.opacity(0.3), lineWidth: 1)
            )
        } else if vm.state == .finish {
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 12) {
                    Image(.noteIcon)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Проверьте")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.black)
                        Text("Убедитесь что груз передан получателю лично")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.orangeFF85021A)
                            .lineLimit(2)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.orangeFF85021A.opacity(0.05))
                        .strokeBorder(.orangeFF85021A, lineWidth: 0.5)
                )
                if photoTaken == false {
                    Button {
                        showCamera = true
                    } label: {
                        VStack(alignment: .center, spacing: .zero) {
                            Image(.getPhotoIcon)
                                .resizable()
                                .frame(width: 64, height: 64)
                                .padding(.bottom, 12)
                                .shadow(color: .black.opacity(0.3), radius: 3, y: 4)
                            
                            Text("Сделать фото доставки")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding(.bottom, 2)
                            
                            Text("Сфотографируйте переданную посылку")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(.black.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.purple8B5CF6.opacity(0.1))
                                .strokeBorder(.purple8B5CF6.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showCamera) {
                        CameraView { image in
                            photoTaken = true
                        }
                    }
                } else {
                    VStack(alignment: .center, spacing: .zero) {
                        Image(.greenBigDoneIcon2)
                            .resizable()
                            .frame(width: 64, height: 64)
                            .padding(.bottom, 12)
                            .shadow(color: .black.opacity(0.3), radius: 3, y: 4)
                        
                        Text("Фото загружено")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black)
                            .padding(.bottom, 2)
                        
                        Text("1 фотография")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(.black.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.green00D40E1A.opacity(0.1))
                            .strokeBorder(.green00D40E1A.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private func detailRow(left: String, right: String) -> some View {
        HStack {
            Text(left)
                .font(.system(size: 15))
                .foregroundStyle(.black.opacity(0.4))
            Spacer()
            Text(right)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.black)
        }
    }
    
    private var header: some View {
        VStack(spacing: .zero) {
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
            
            Divider()
                .background(.black.opacity(0.1))
            
            HStack(alignment: .center, spacing: 40.fitW) {
                StepView(title: "В пути к А", visual: vm.visual(for: .roadA))
                StepView(title: "Забрал", visual: vm.visual(for: .took))
                StepView(title: "В пути к Б", visual: vm.visual(for: .roadB))
                StepView(title: "Доставлено", visual: vm.visual(for: .finish))
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
    
    private var bottomButton: some View {
        VStack(alignment: .center, spacing: .zero) {
            Divider()
                .background(.black.opacity(0.1))
                .frame(height: 1)
            
            VStack(alignment: .center, spacing: 12) {
                Button {
                    if vm.state == .finish {
                        if photoTaken == true {
                            vm.finish()
                        }
                    } else {
                        vm.advance()
                    }
                } label: {
                    Text(vm.buttonTitle)
                        .font(.system(size: 16.fitW, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16.fitH)
                        .background(Color("purple8B5CF6"))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                .disabled((vm.state == .finish && photoTaken == false))
                
                if vm.state != .finish {
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
                            vm.chat()
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
            }
            .padding(.top, 20.fitH)
            .padding(.horizontal, 24.fitW)
        }
        .padding(.bottom, 10.fitH)
    }
    
    private var fisrtViewIcon: ImageResource {
        switch vm.state {
        case .roadA: .purpleBigGeoIcon
        case .took: .orangeBigBoxIcon
        case .roadB: .purpleBigGeoIcon
        case .finish: .greenBigDoneIcon
        }
    }
}
