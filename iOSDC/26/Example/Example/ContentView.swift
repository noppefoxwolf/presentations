//
//  ContentView.swift
//  Example
//
//  Created by Tomoya Hirano on 2026/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Color.clear
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.blue.gradient)
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading) {
                    Text("“お手柄警察犬” ご褒美は…？　においを追って“犯人”発見　愛知・犬山市")
                        .font(.title)
                    Text("news.yahoo.co.jp")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("12分前")
                        .font(.default)
                }
                .padding()
                .background()
                .mask(RoundedRectangle(cornerRadius: 16))
                .padding()
                .frame(width: 386)
            }
    }
}

struct FixedIssue1View: View {
    var body: some View {
        VStack {
            Text("Recommendation")
                .font(.largeTitle)
                .bold()
                .frame(width: 200, height: 50)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FixedIssue2View: View {
    var body: some View {
        VStack {
            Text("今日のおすすめ")
                .font(.largeTitle)
                .bold()
                .frame(width: 200, height: 50)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}
