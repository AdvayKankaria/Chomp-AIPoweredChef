import Foundation
import Combine

class AIRecipeService: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = "YOUR_OPENAI_API_KEY" // Replace with your actual API key
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func generateRecipe(from ingredients: [Ingredient]) async -> Recipe? {
        guard !ingredients.isEmpty else { return nil }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        let ingredientList = ingredients.map { "\($0.quantity) \($0.unit) \($0.name)" }.joined(separator: ", ")
        
        let prompt = """
        Create a detailed recipe using these ingredients: \(ingredientList).
        
        Please provide a JSON response with the following structure:
        {
            "title": "Recipe Name",
            "description": "Brief description",
            "cookingTime": 30,
            "servings": 4,
            "difficulty": "Easy/Medium/Hard",
            "ingredients": [
                {
                    "name": "ingredient name",
                    "amount": "1",
                    "unit": "cup",
                    "notes": "optional notes"
                }
            ],
            "steps": [
                {
                    "stepNumber": 1,
                    "instruction": "Step instruction",
                    "duration": 5,
                    "temperature": "350°F",
                    "tips": "Optional cooking tip"
                }
            ],
            "tags": ["tag1", "tag2"],
            "nutritionInfo": {
                "calories": 250,
                "protein": 15.0,
                "carbs": 30.0,
                "fat": 8.0,
                "fiber": 5.0
            }
        }
        
        Make sure the recipe is practical and uses the provided ingredients as main components.
        """
        
        do {
            let recipe = try await callOpenAI(prompt: prompt)
            await MainActor.run {
                isLoading = false
            }
            return recipe
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
            return nil
        }
    }
    
    private func callOpenAI(prompt: String) async throws -> Recipe? {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a professional chef and recipe creator. Always respond with valid JSON."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 1500,
            "temperature": 0.7
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let choices = jsonResponse["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            
            return try parseRecipeFromJSON(content)
        }
        
        throw APIError.invalidResponse
    }
    
    private func parseRecipeFromJSON(_ jsonString: String) throws -> Recipe {
        guard let data = jsonString.data(using: .utf8) else {
            throw APIError.invalidJSON
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Recipe.self, from: data)
    }
    
    enum APIError: LocalizedError {
        case invalidURL
        case invalidResponse
        case invalidJSON
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid API URL"
            case .invalidResponse:
                return "Invalid API response"
            case .invalidJSON:
                return "Could not parse recipe data"
            }
        }
    }
}