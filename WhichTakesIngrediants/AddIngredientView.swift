import SwiftUI

struct AddIngredientView: View {
    @ObservedObject var viewModel: IngredientViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = "pieces"
    @State private var selectedCategory: Ingredient.IngredientCategory = .other
    
    private let units = ["pieces", "cups", "tablespoons", "teaspoons", "pounds", "ounces", "grams", "liters", "milliliters"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Ingredient Details") {
                    TextField("Ingredient name", text: $name)
                    
                    HStack {
                        TextField("Quantity", text: $quantity)
                            .keyboardType(.decimalPad)
                        
                        Picker("Unit", selection: $unit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Ingredient.IngredientCategory.allCases, id: \.self) { category in
                            HStack {
                                Text(category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section {
                    Button("Add Ingredient") {
                        let ingredient = Ingredient(
                            name: name,
                            quantity: quantity,
                            unit: unit,
                            category: selectedCategory
                        )
                        viewModel.addIngredient(ingredient)
                        dismiss()
                    }
                    .disabled(name.isEmpty || quantity.isEmpty)
                }
            }
            .navigationTitle("Add Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}