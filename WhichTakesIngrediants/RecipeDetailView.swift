import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Recipe Header
                    recipeHeader
                    
                    // Recipe Info
                    recipeInfoCards
                    
                    // Ingredients Section
                    ingredientsSection
                    
                    // Cooking Steps
                    cookingStepsSection
                    
                    // Nutrition Info
                    if let nutrition = recipe.nutritionInfo {
                        nutritionSection(nutrition)
                    }
                }
                .padding()
            }
            .navigationTitle("Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var recipeHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(recipe.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(recipe.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private var recipeInfoCards: some View {
        HStack(spacing: 16) {
            InfoCard(icon: "clock", title: "Time", value: "\(recipe.cookingTime) min")
            InfoCard(icon: "person.2", title: "Servings", value: "\(recipe.servings)")
            InfoCard(icon: "chart.bar", title: "Difficulty", value: recipe.difficulty.rawValue)
        }
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                ForEach(recipe.ingredients) { ingredient in
                    HStack {
                        Text("• \(ingredient.amount) \(ingredient.unit) \(ingredient.name)")
                            .font(.body)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var cookingStepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cooking Steps")
                .font(.title2)
                .fontWeight(.semibold)
            
            ForEach(recipe.steps) { step in
                StepCard(step: step, isActive: currentStep == step.stepNumber - 1) {
                    currentStep = step.stepNumber - 1
                }
            }
        }
    }
    
    private func nutritionSection(_ nutrition: NutritionInfo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition Information")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                NutritionCard(label: "Calories", value: "\(nutrition.calories)")
                NutritionCard(label: "Protein", value: "\(nutrition.protein, specifier: "%.1f")g")
                NutritionCard(label: "Carbs", value: "\(nutrition.carbs, specifier: "%.1f")g")
                NutritionCard(label: "Fat", value: "\(nutrition.fat, specifier: "%.1f")g")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}