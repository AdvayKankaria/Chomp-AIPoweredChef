import Foundation
import SwiftUI

class IngredientViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var selectedIngredients: [Ingredient] = []
    @Published var searchText = ""
    @Published var selectedCategory: Ingredient.IngredientCategory?
    
    private let userDefaults = UserDefaults.standard
    private let ingredientsKey = "SavedIngredients"
    
    init() {
        loadIngredients()
    }
    
    var filteredIngredients: [Ingredient] {
        var filtered = ingredients
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered
    }
    
    func addIngredient(_ ingredient: Ingredient) {
        ingredients.append(ingredient)
        saveIngredients()
    }
    
    func removeIngredient(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }
        selectedIngredients.removeAll { $0.id == ingredient.id }
        saveIngredients()
    }
    
    func toggleSelection(for ingredient: Ingredient) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients[index].isSelected.toggle()
            
            if ingredients[index].isSelected {
                selectedIngredients.append(ingredients[index])
            } else {
                selectedIngredients.removeAll { $0.id == ingredient.id }
            }
        }
    }
    
    func clearSelection() {
        selectedIngredients.removeAll()
        for index in ingredients.indices {
            ingredients[index].isSelected = false
        }
    }
    
    private func saveIngredients() {
        if let encoded = try? JSONEncoder().encode(ingredients) {
            userDefaults.set(encoded, forKey: ingredientsKey)
        }
    }
    
    private func loadIngredients() {
        if let data = userDefaults.data(forKey: ingredientsKey),
           let decoded = try? JSONDecoder().decode([Ingredient].self, from: data) {
            ingredients = decoded
        }
    }
}