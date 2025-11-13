//
//  MapView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 09.11.2025.
//

import Foundation
import SwiftUI
import MapKit

struct OrderMapView: View {
    let order: FullOrder
    let router: MainRouter

    @State private var camera: MapCameraPosition = .automatic
    @State private var currentRegion: MKCoordinateRegion?
    @State private var zoom: Double = 1.0

    private var pointA: CLLocationCoordinate2D? { .init(latitude: order.from_point_lat, longitude: order.from_point_lon) }
    private var pointB: CLLocationCoordinate2D? { .init(latitude: order.to_point_lat, longitude: order.to_point_lon) }

    var body: some View {
        ZStack {
            Map(position: $camera, interactionModes: [.pan, .zoom, .rotate]) {
                if let a = pointA {
                    Annotation("", coordinate: a) {
                        VStack(spacing: 4) {
                            Text("Точка А")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(.white)
                                        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                                )
                                .overlay(
                                    Capsule().stroke(Color.purple8B5CF6.opacity(0.1), lineWidth: 1)
                                )
                            
                            Image(.pinForMapIcon)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .shadow(color: .purple8B5CF6.opacity(0.5), radius: 8, y: 8)
                        }
                    }
                }
                if let b = pointB {
                    Annotation("", coordinate: b) {
                        VStack(spacing: 4) {
                            Text("Точка Б")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(.white)
                                        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                                )
                                .overlay(
                                    Capsule().stroke(Color.purple8B5CF6.opacity(0.1), lineWidth: 1)
                                )
                            
                            Image(.redPinForMapIcon)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .shadow(color: .redFB2C361A.opacity(0.5), radius: 8, y: 8)
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
        .onAppear { fitRouteIfPossible() }
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .top) {
            HStack {
                Button {
                    router.pop()
                } label: {
                    Image(.closeIcon)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    callClient(order.sender_phone)
                } label: {
                    Image(.callIcon)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Button {
                        zoomIn()
                    } label: {
                        Image(.plusIcon)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                    }
                    .buttonStyle(.plain)

                    Button {
                        zoomOut()
                    } label: {
                        Image(.minusIcon)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                    }
                    .buttonStyle(.plain)
                }
                Button {
                    recenter()
                } label: {
                    Image(.detectGeoIcon)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
    }

    private func fitRouteIfPossible() {
        guard let a = pointA, let b = pointB else { return }
        let rect = MKMapRect.bounding(a, b)
        var region = MKCoordinateRegion(rect)
        region = region.scaled(by: 1.3)
        apply(region)
    }

    private func recenter() {
        if let r = currentRegion {
            apply(r)
        } else {
            fitRouteIfPossible()
        }
    }

    private func zoomIn() {
        guard var r = currentRegion else { fitRouteIfPossible(); return }
        r = r.scaled(by: 0.75)
        apply(r)
    }

    private func zoomOut() {
        guard var r = currentRegion else { fitRouteIfPossible(); return }
        r = r.scaled(by: 1.25)
        apply(r)
    }

    private func apply(_ region: MKCoordinateRegion) {
        currentRegion = region.clamped(minSpan: 0.0005, maxSpan: 100.0)
        camera = .region(currentRegion!)
    }

    private func callClient(_ raw: String) {
        let allowed = Set("+0123456789")
        let cleaned = raw.filter { allowed.contains($0) }
        guard let url = URL(string: "tel://\(cleaned)") else { return }
        UIApplication.shared.open(url)
    }
}

private extension MKMapRect {
    static func bounding(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> MKMapRect {
        let p1 = MKMapPoint(a), p2 = MKMapPoint(b)
        return MKMapRect(
            x: min(p1.x, p2.x),
            y: min(p1.y, p2.y),
            width: abs(p1.x - p2.x),
            height: abs(p1.y - p2.y)
        ).insetBy(dx: -10000, dy: -10000) // немного паддинга
    }
}
private extension MKCoordinateRegion {
    // масштабируем span, не меняя центр
    func scaled(by factor: Double) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: span.latitudeDelta * factor,
                longitudeDelta: span.longitudeDelta * factor
            )
        )
    }
    // ограничение зума
    func clamped(minSpan: CLLocationDegrees, maxSpan: CLLocationDegrees) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: span.latitudeDelta.clamped(minSpan, maxSpan),
                longitudeDelta: span.longitudeDelta.clamped(minSpan, maxSpan)
            )
        )
    }
}

private extension CLLocationDegrees {
    func clamped(_ min: CLLocationDegrees, _ max: CLLocationDegrees) -> CLLocationDegrees {
        Swift.max(min, Swift.min(self, max))
    }
}

struct OrderMapViewForOrders: View {
    let order: FullOrder
    let router: OrdersRouter

    @State private var camera: MapCameraPosition = .automatic
    @State private var currentRegion: MKCoordinateRegion?
    @State private var zoom: Double = 1.0

    private var pointA: CLLocationCoordinate2D? { .init(latitude: order.from_point_lat, longitude: order.from_point_lon) }
    private var pointB: CLLocationCoordinate2D? { .init(latitude: order.to_point_lat, longitude: order.to_point_lon) }

    var body: some View {
        ZStack {
            Map(position: $camera, interactionModes: [.pan, .zoom, .rotate]) {
                if let a = pointA {
                    Annotation("", coordinate: a) {
                        VStack(spacing: 4) {
                            Text("Точка А")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(.white)
                                        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                                )
                                .overlay(
                                    Capsule().stroke(Color.purple8B5CF6.opacity(0.1), lineWidth: 1)
                                )
                            
                            Image(.pinForMapIcon)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .shadow(color: .purple8B5CF6.opacity(0.5), radius: 8, y: 8)
                        }
                    }
                }
                if let b = pointB {
                    Annotation("", coordinate: b) {
                        VStack(spacing: 4) {
                            Text("Точка Б")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(.white)
                                        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                                )
                                .overlay(
                                    Capsule().stroke(Color.purple8B5CF6.opacity(0.1), lineWidth: 1)
                                )
                            
                            Image(.redPinForMapIcon)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .shadow(color: .redFB2C361A.opacity(0.5), radius: 8, y: 8)
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
        .onAppear { fitRouteIfPossible() }
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .top) {
            HStack {
                Button {
                    router.pop()
                } label: {
                    Image(.closeIcon)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    callClient(order.sender_phone)
                } label: {
                    Image(.callIcon)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Button {
                        zoomIn()
                    } label: {
                        Image(.plusIcon)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                    }
                    .buttonStyle(.plain)

                    Button {
                        zoomOut()
                    } label: {
                        Image(.minusIcon)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                    }
                    .buttonStyle(.plain)
                }
                Button {
                    recenter()
                } label: {
                    Image(.detectGeoIcon)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
    }

    private func fitRouteIfPossible() {
        guard let a = pointA, let b = pointB else { return }
        let rect = MKMapRect.bounding(a, b)
        var region = MKCoordinateRegion(rect)
        region = region.scaled(by: 1.3)
        apply(region)
    }

    private func recenter() {
        if let r = currentRegion {
            apply(r)
        } else {
            fitRouteIfPossible()
        }
    }

    private func zoomIn() {
        guard var r = currentRegion else { fitRouteIfPossible(); return }
        r = r.scaled(by: 0.75)
        apply(r)
    }

    private func zoomOut() {
        guard var r = currentRegion else { fitRouteIfPossible(); return }
        r = r.scaled(by: 1.25)
        apply(r)
    }

    private func apply(_ region: MKCoordinateRegion) {
        currentRegion = region.clamped(minSpan: 0.0005, maxSpan: 100.0)
        camera = .region(currentRegion!)
    }

    private func callClient(_ raw: String) {
        let allowed = Set("+0123456789")
        let cleaned = raw.filter { allowed.contains($0) }
        guard let url = URL(string: "tel://\(cleaned)") else { return }
        UIApplication.shared.open(url)
    }
}
