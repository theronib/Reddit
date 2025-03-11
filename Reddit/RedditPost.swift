import Foundation

struct Response: Codable {
    var kind: String
    var data: RedditData
}

struct RedditData: Codable {
    var children: [RedditPostData]
}

struct RedditPostData: Codable {
    var kind: String
    var data: RedditPost
}

struct RedditPost: Codable {
    var author_fullname: String
    var created_utc: Double
    var domain: String
    var title: String
    var preview: Preview?
    var ups: Int
    var downs: Int
    var num_comments: Int
}

struct Preview: Codable {
    var images: [PreviewImage]
}

struct PreviewImage: Codable {
    var source: ImageSource
}

struct ImageSource: Codable {
    var url: String
}

//struct RedditPost: Codable {
//    var author_fullname: String
//    var created_utc: Double
//    var domain: String
//    var title: String
//    var media_metadata: [String: MediaMetadata]
//    var ups: Int
//    var downs: Int
//    var num_comments: Int
//}
//
//struct MediaMetadata: Codable {
//    var status: String
//    var e: String
//    var m: String
//    var p: [ImagePreview]
//    var s: ImageSource
//}
//
//struct ImagePreview: Codable {
//    var y: Int
//    var x: Int
//    var u: String
//}
//
//struct ImageSource: Codable {
//    var y: Int
//    var x: Int
//    var u: String
//}


func fetchData(subreddit: String, limit: Int, after: String = "") async throws -> RedditPost? {
    let urlComponents = URLComponents(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)&after=\(after)")

    
    guard let url = urlComponents?.url else {
        throw URLError(.badURL)
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let jsonString = String(data: data, encoding: .utf8){
            print("JSON: \(jsonString)")
        }
        
    
        do {
            let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                return decodedResponse.data.children.first?.data
            
        }
        catch {
            print("Error decoding response: \(error.localizedDescription)")
            return nil
        }
        

    } catch {
        print("Error. Try again later.")
        throw error
    }
}
