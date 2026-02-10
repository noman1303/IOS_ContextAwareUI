//
//  ContextCard.swift
//  ContextAware
//
//  Created by Noman belim on 10/02/26.
//

import SwiftUI

struct ContextCard: View {

    let icon: String
    let title: String
    let subtitle: String
    let badge: String
    let color: Color
    let reduceMotion: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .animation(
                    reduceMotion ? nil : .easeInOut(duration: 0.3),
                    value: color
                )

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Rectangle()
                        .fill(color)
                        .frame(width: 4)

                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 28))

                    Spacer()
                }

                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()

            Text(badge)
                .font(.caption.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(color)
                .cornerRadius(12)
                .padding(12)
        }
        .frame(height: 110)
    }
}


