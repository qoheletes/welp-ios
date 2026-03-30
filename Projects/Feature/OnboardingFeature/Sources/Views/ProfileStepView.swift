import SwiftUI
import Shared

struct ProfileStepView: View {
    @State private var selectedAgeGroup: String? = nil
    @State private var selectedGender: String? = nil
    @State private var appeared = false

    private let ageGroups = ["Under 20", "20s", "30s", "40s", "50+"]
    private let genders   = ["Male", "Female", "Non-binary", "Prefer not to say"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Heading
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick intro")
                        .font(.sbAggroBold(28))
                        .foregroundStyle(Color.welpTextPrimary)
                        .kerning(-0.8)

                    Text("Totally optional — helps us tailor your answers.")
                        .font(.sbAggroLight(15))
                        .foregroundStyle(Color.welpTextSpoken)
                        .lineSpacing(6)
                }

                // Age group
                VStack(alignment: .leading, spacing: 12) {
                    Text("Age group")
                        .font(.sbAggroMedium(13))
                        .foregroundStyle(Color.welpTextMuted)
                        .textCase(.uppercase)
                        .kerning(0.5)

                    FlowLayout(spacing: 8) {
                        ForEach(ageGroups, id: \.self) { group in
                            SelectChip(
                                label: group,
                                isSelected: selectedAgeGroup == group
                            ) {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    selectedAgeGroup = selectedAgeGroup == group ? nil : group
                                }
                            }
                        }
                    }
                }

                // Gender
                VStack(alignment: .leading, spacing: 12) {
                    Text("Gender")
                        .font(.sbAggroMedium(13))
                        .foregroundStyle(Color.welpTextMuted)
                        .textCase(.uppercase)
                        .kerning(0.5)

                    FlowLayout(spacing: 8) {
                        ForEach(genders, id: \.self) { gender in
                            SelectChip(
                                label: gender,
                                isSelected: selectedGender == gender
                            ) {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    selectedGender = selectedGender == gender ? nil : gender
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 32)
            .padding(.bottom, 24)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.45).delay(0.15)) {
                appeared = true
            }
        }
    }
}

// MARK: - SelectChip

private struct SelectChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.sbAggroMedium(14))
                .foregroundStyle(isSelected ? Color.welpTextPrimary : Color.welpTextSpoken)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.welpTextAccent : Color.welpBgCardAlt)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? Color.welpTextAccent : Color.welpBgTrack,
                            lineWidth: 1.5
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - FlowLayout

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        return layout(subviews: subviews, in: width).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(subviews: subviews, in: bounds.width)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    private func layout(subviews: Subviews, in width: CGFloat) -> (size: CGSize, frames: [CGRect]) {
        var frames: [CGRect] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxWidth = max(maxWidth, x)
        }
        return (CGSize(width: maxWidth, height: y + rowHeight), frames)
    }
}
