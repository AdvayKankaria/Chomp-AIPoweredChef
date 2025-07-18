import Foundation

struct Recipe: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var cookingTime: Int // in minutes
    var servings: Int
    var difficulty: Difficulty
    var ingredients: [RecipeIngredient]
    var steps: [CookingStep]
    var tags: [String]
    var nutritionInfo: NutritionInfo?
    var imageURL: String?
    var createdAt: Date = Date()
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        
        var color: String {
            switch self {
            case .easy: return "green"
            case .medium: return "orange"
            case .hard: return "red"
            }
        }
    }
}

struct RecipeIngredient: Identifiable, Codable {
    let id = UUID()
    var name: String
    var amount: String
    var unit: String
    var notes: String?
}

struct CookingStep: Identifiable, Codable {
    let id = UUID()
    var stepNumber: Int
    var instruction: String
    var duration: Int? // in minutes
    var temperature: String?
    var tips: String?
}

struct NutritionInfo: Codable {
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double
}