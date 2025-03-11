import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var upperLabel: UILabel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    
    @IBOutlet private weak var ratingButton: UIButton!
    
    @IBOutlet private weak var commentsButton: UIButton!
    
    
    @IBOutlet private weak var test: UIImageView!
    
    @IBOutlet private weak var bookmarkButton: UIButton!
    
    var saved: Bool = false
    
    @IBAction func bookmarkButtonAction(_ sender: Any) {
        saved.toggle()
    
        if saved == true {
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
              do {
                  if let post = try await fetchData(subreddit: "ios", limit: 1){
                      DispatchQueue.main.async {
                          self.titleLabel.text = post.title
                                                  
                          let comments = post.num_comments
                          
                          let commentsText = comments >= 1000 ? "\(Double(comments) / 1000)k " : "\(comments)"
                  
                          
                          self.commentsButton.setTitle(commentsText, for: .normal)
                          
                          self.commentsButton.setImage(UIImage(systemName: "bubble"), for: .normal)
                          
                          self.commentsButton.configuration?.imagePadding = 5
                      
  //                        if let media = post.media_metadata.first?.value {
  //                            let imageURL = media.s.u
  //                            print("imageURL: ", imageURL)
  //
  //                            Task {
  //                                if let image = await loadImage(urlString: imageURL){
  //                                    self.pictureView.image = image
  //                                }
  //                            }
  //                        }
                          
                          
                          if let imageURL = post.preview?.images.first?.source.url {
                              print("imageURL: ", imageURL)
                              
                              Task {
                                  if let image = await loadImage(urlString: imageURL){
                                      self.test.image = image
                                  }
                              }
                          }
                          
                                                 
                          let ups = post.ups
                          let downs = post.downs
                          let rating = ups + downs
                          
                          let ratingText = rating >= 1000 ? "\(Double(rating) / 1000)k " : "\(rating)"
                          
                          self.ratingButton.setTitle(ratingText, for: .normal)
                          
                          self.ratingButton.setImage(UIImage(systemName: "arrowshape.up"), for: .normal)
                          
                          self.ratingButton.configuration?.imagePadding = 10
                          
                          
                          let timePosted = post.created_utc
                          let currentDate = Date(timeIntervalSince1970: timePosted)
                          
                          let formattedDate = calculatetime(date: currentDate)
                          
                          self.upperLabel.text = "r/\(post.author_fullname) • \(formattedDate) • \(post.domain)"
                          
                          self.titleLabel.numberOfLines = 0
                          self.titleLabel.lineBreakMode = .byWordWrapping
                          
                      
                      }
                  }
              }
              catch {
                  print("Error fetching data")
              }
          }
      }
    }


func loadImage(urlString: String) async -> UIImage? {
    let correctURLString = urlString.replacingOccurrences(of: "&amp;", with: "&")
    
    guard let url = URL(string: correctURLString) else {
        return nil
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    catch {
        print("Error: \(error.localizedDescription)")
        return nil
    }
}

func calculatetime(date: Date) -> String{
    let calender = Calendar.current
    let now = Date()
    
    let full_day = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
    
    if let year = full_day.year, year > 0 {
        return "\(year)y ago"
    }
    else if let month = full_day.month, month > 0 {
        return "\(month)mo ago"
    }
    else if let day = full_day.day, day > 0 {
        return "\(day)d ago"
    }
    else if let hour = full_day.hour, hour > 0 {
        return "\(hour) hr. ago"
    }
    else if let minute = full_day.minute, minute > 0 {
        return "\(minute) min. ago"
    }
    else if let second = full_day.second, second > 0 {
        return "\(second) sec. ago"
    }
    
    return "Just now"
}


