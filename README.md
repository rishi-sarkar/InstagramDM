# InstaDM

InstaDM is an iOS application built with Swift that leverages `WKWebView` to provide a streamlined Instagram experience. The app opens Safari instances of Instagram, injects custom JavaScript to interact with the page's DOM, and restricts scrolling on the main feed, stories, and reels—ensuring users can focus on viewing shared media without distraction.

## Features

- **Instagram Integration:** Seamlessly loads Instagram within a `WKWebView`.
- **JavaScript Injection:** Dynamically injects custom JavaScript to:
  - Monitor the page URL.
  - Restrict scrolling on the main feed, stories, and reels.
- **User-Centric Design:** Tailored for users who want a distraction-free media viewing experience.
- **Modular Codebase:** Easy to customize and extend with additional features.

## Getting Started

### Prerequisites

- **Xcode 13 or later:** Ensure you have the latest version of Xcode installed.
- **iOS 14 or later:** The app targets devices running iOS 14+.
- **Instagram Account:** Required for testing and viewing content.

### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/InstaDM.git
   cd InstaDM

   ```

2. **Open with Xcode to run the project**

3. **'Test' the code with your device to load it into your phone**
