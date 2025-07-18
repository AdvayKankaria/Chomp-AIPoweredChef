import SwiftUI

struct IngredientRow: View {
    let ingredient: Ingredient
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            // Category Icon
            Text(ingredient.category.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                    .font(.headline)
                    .foregroundColor(ingredient.isSelected ? .blue : .primary)
                
                Text("\(ingredient.quantity) \(ingredient.unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Selection Indicator
            if ingredient.isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
                    .font(.title2)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}