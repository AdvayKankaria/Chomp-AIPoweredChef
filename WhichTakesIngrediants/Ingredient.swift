import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var quantity: String
    var unit: String
    var category: IngredientCategory
    var isSelected: Bool = false
    
    enum IngredientCategory: String, CaseIterable, Codable {
        case protein = "Protein"
        case vegetables = "Vegetables"
        case fruits = "Fruits"
        case grains = "Grains"
        case dairy = "Dairy"
        case spices = "Spices"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .protein: return "🥩"
            case .vegetables: return "🥕"
            case .fruits: return "🍎"
            case .grains: return "🌾"
            case .dairy: return "🥛"
            case .spices: return "🧂"
            case .other: return "🥫"
            }
        }
    }
}