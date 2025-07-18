import SwiftUI

struct ContentView: View {
    @StateObject private var ingredientViewModel = IngredientViewModel()
    @StateObject private var aiService = AIRecipeService()
    @State private var showingAddIngredient = false
    @State private var generatedRecipe: Recipe?
    @State private var showingRecipe = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Selected Ingredients
                if !ingredientViewModel.selectedIngredients.isEmpty {
                    selectedIngredientsView
                }
                
                // Main Content
                ingredientListView
                
                // Generate Recipe Button
                if !ingredientViewModel.selectedIngredients.isEmpty {
                    generateRecipeButton
                }
            }
            .navigationTitle("AI Recipe Chef")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddIngredient = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddIngredient) {
            AddIngredientView(viewModel: ingredientViewModel)
        }
        .sheet(isPresented: $showingRecipe) {
            if let recipe = generatedRecipe {
                RecipeDetailView(recipe: recipe)
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What's in your kitchen?")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Select ingredients to generate personalized recipes")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search ingredients...", text: $ingredientViewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Ingredient.IngredientCategory.allCases, id: \.self) { category in
                        CategoryChip(
                            category: category,
                            isSelected: ingredientViewModel.selectedCategory == category
                        ) {
                            ingredientViewModel.selectedCategory = 
                                ingredientViewModel.selectedCategory == category ? nil : category
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private var selectedIngredientsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Selected Ingredients (\(ingredientViewModel.selectedIngredients.count))")
                    .font(.headline)
                
                Spacer()
                
                Button("Clear All") {
                    ingredientViewModel.clearSelection()
                }
                .font(.caption)
                .foregroundColor(.red)
            }
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 120))
            ], spacing: 8) {
                ForEach(ingredientViewModel.selectedIngredients) { ingredient in
                    SelectedIngredientCard(ingredient: ingredient) {
                        ingredientViewModel.toggleSelection(for: ingredient)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private var ingredientListView: some View {
        List {
            ForEach(ingredientViewModel.filteredIngredients) { ingredient in
                IngredientRow(ingredient: ingredient) {
                    ingredientViewModel.toggleSelection(for: ingredient)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let ingredient = ingredientViewModel.filteredIngredients[index]
                    ingredientViewModel.removeIngredient(ingredient)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var generateRecipeButton: some View {
        VStack(spacing: 12) {
            if aiService.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Generating recipe...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Button {
                    Task {
                        generatedRecipe = await aiService.generateRecipe(from: ingredientViewModel.selectedIngredients)
                        if generatedRecipe != nil {
                            showingRecipe = true
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Generate Recipe")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            
            if let errorMessage = aiService.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    ContentView()
}