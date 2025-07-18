import SwiftUI

struct StepCard: View {
    let step: CookingStep
    let isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Step Number
                Text("\(step.stepNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(isActive ? Color.blue : Color.gray)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    if let duration = step.duration {
                        Text("\(duration) minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let temperature = step.temperature {
                        Text(temperature)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
            }
            
            Text(step.instruction)
                .font(.body)
                .lineLimit(nil)
            
            if let tips = step.tips {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.yellow)
                    Text(tips)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(isActive ? Color.blue.opacity(0.1) : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isActive ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onTap()
        }
    }
}