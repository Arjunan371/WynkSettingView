//
//  ContentView.swift
//  WynkSettingView
//
//  Created by Arjunan on 03/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    StickyHeader()
}

struct StickyHeader: View {
    @State private var offsetHeader: CGFloat = .zero
    @State private var offsetContent: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Image(systemName: "chevron.backward.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Group {
                        if offsetContent <= offsetHeader {
                            Text("Header2")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Header1")
                                    .font(.largeTitle)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue)
                .zIndex(0)
                .background(GeometryReader { proxy in
                    Color.clear
                        .preference(key: CalculateValue.self, value: proxy.frame(in: .global).maxY)
                }.frame(height: 0))
                
                ScrollView {
                    VStack(spacing: 0) {
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: CalculateContentMinY.self, value: proxy.frame(in: .global).minY)
                        }
                        .frame(height: 0)
                        
                        ForEach(1..<30) { index in
                            Text("Row \(index)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .border(Color.gray.opacity(0.2), width: 1)
                        }
                    }
                }
                .onPreferenceChange(CalculateValue.self) { value in
                    print("headerValue====>", value)
                    offsetHeader = value
                }
                .onPreferenceChange(CalculateContentMinY.self) { value in
                    print("contentValue====>", value)
                    offsetContent = value
                }
            }
        }
    }
}

struct CalculateValue: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CalculateContentMinY: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
