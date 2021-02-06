import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
/*
 struct Blog: Website {
     enum SectionID: String, WebsiteSectionID {
         case articles
         case about
     }
 }

 */
struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        case articles
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        var description: String
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://lfarah.github.io/blog/")!
    var name = "Lucas Farah's Blog"
    var description = "Helping myself become a better developer"
    var language: Language { .english }
    var imagePath: Path? { nil }    
    var socialMediaLinks: [SocialMediaLink] { [.location, .email, .linkedIn, .github, .twitter] }
}


// This will generate your website using the built-in Foundation theme:

try Blog().publish(
    withTheme: .blog,
    additionalSteps: [
        .deploy(using: .gitHub("lfarah/lfarah.github.io", useSSH: false))
    ],
    plugins: [.splash(withClassPrefix: "")]
)
