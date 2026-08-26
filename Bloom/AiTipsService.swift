//
//  AiTipsService.swift
//  Bloom
//
//  Created by Kylie Capes on 11/30/25.
//

import Foundation

enum AITipsServiceError: Error {
    case noAPIKey
    case invalidResponse
}

class AITipsService {

    // TODO: OpenAI API key here for live AI tips
    // If left empty, we fall back to built-in sample tips.
    private let openAIKey = ""   // "sk-..."

    func generateTips(for goals: [String], completion: @escaping (Result<[AITip], Error>) -> Void) {

        let cleanedGoals = goals
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !cleanedGoals.isEmpty else {
            completion(.success([]))
            return
        }

        // If there is NO API key, just return some built-in sample tips.
        guard !openAIKey.isEmpty else {
            let samples = makeSampleTips(for: cleanedGoals)
            completion(.success(samples))
            return
        }

        // ---------- REAL OPENAI CALL (optional, if you add key) ----------

        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let systemPrompt = """
        You are a wellness coach. Given the user's self-care goals, respond with ONLY JSON:
        [
          {
            "title": "Short title",
            "goal": "Which goal this relates to",
            "suggestion": "1–3 sentence practical, encouraging tip."
          },
          ...
        ]
        Generate 3-5 tips.
        """

        let userPrompt = "User goals: \(cleanedGoals.joined(separator: "; "))"

        let body: [String: Any] = [
            "model": "gpt-4.1-mini",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.7
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(AITipsServiceError.invalidResponse))
                return
            }

            struct ChatResponse: Decodable {
                struct Choice: Decodable {
                    struct Message: Decodable {
                        let content: String
                    }
                    let message: Message
                }
                let choices: [Choice]
            }

            do {
                let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
                guard let content = decoded.choices.first?.message.content.data(using: .utf8) else {
                    completion(.failure(AITipsServiceError.invalidResponse))
                    return
                }

                // Parse the content as JSON array of tips
                struct RawTip: Decodable {
                    let title: String
                    let goal: String
                    let suggestion: String
                }

                let rawTips = try JSONDecoder().decode([RawTip].self, from: content)
                let tips: [AITip] = rawTips.map { raw in
                    AITip(
                        id: UUID().uuidString,
                        title: raw.title,
                        goal: raw.goal,
                        suggestion: raw.suggestion,
                        createdAt: Date()
                    )
                }

                completion(.success(tips))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // MARK: - Sample tips fallback (no API key)

    private func makeSampleTips(for goals: [String]) -> [AITip] {
        var results: [AITip] = []

        for goal in goals {
            let lower = goal.lowercased()
            let (title, suggestion): (String, String)

            if lower.contains("sleep") {
                title = "Improve Sleep"
                suggestion = "Aim for a consistent bedtime and wake-up time. Try a 10-minute wind-down routine before bed, like reading or stretching."
            } else if lower.contains("water") || lower.contains("hydrate") {
                title = "Stay Hydrated"
                suggestion = "Keep a reusable water bottle nearby and set a small goal, like 1 glass every few hours."
            } else if lower.contains("stress") || lower.contains("anxiety") {
                title = "Calm Your Mind"
                suggestion = "Try a 3-minute breathing exercise: inhale for 4, hold for 4, exhale for 4. Repeat whenever you feel tense."
            } else if lower.contains("exercise") || lower.contains("workout") || lower.contains("move") {
                title = "Move Your Body"
                suggestion = "Start with something small, like a 10-minute walk, and build from there. Consistency matters more than intensity."
            } else {
                title = "Make Progress"
                suggestion = "Break this goal into one tiny step you can do today. Celebrate completing that step, no matter how small."
            }

            results.append(
                AITip(
                    id: UUID().uuidString,
                    title: title,
                    goal: goal,
                    suggestion: suggestion,
                    createdAt: Date()
                )
            )
        }

        return results
    }
}
