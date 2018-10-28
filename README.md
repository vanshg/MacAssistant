# MacAssistant

[![Github All Releases](https://img.shields.io/github/downloads/vanshg/MacAssistant/total.svg)](https://github.com/vanshg/MacAssistant/releases) [![Travis](https://img.shields.io/badge/Swift-3.1-blue.svg)](https://github.com/vanshg/MacAssistant) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/vanshg/MacAssistant/master/LICENSE) [![Twitter](https://img.shields.io/twitter/url/https/github.com/vanshg/MacAssistant.svg?style=social)](https://twitter.com/intent/tweet?text=Wow:&url=%5Bobject%20Object%5D)

***NOTE: I've currently hit the API limit. In the meantime, you can use your own OAuth credentials by following the instructions [here](https://github.com/vanshg/MacAssistant#Use-your-own-OAuth-Credentials).***

***NOTE: If you're using a new MacBook and the app crashes, try going to Audio MIDI Setup, and changing your format to 44.1K if it isn't already***

A project that integrates the Google Assistant into macOS, using the Google Assistant SDK.

*Google Assistant “is now on over 500 million devices”  - Scott Huffman @ Google I/O 2018*

MacAssistant can bring that number to 600 million

![](images/1.png)
![](images/2.png)
![](images/3.png)

## Download
Downloads are listed under the `Releases` tab.
Click [here](https://github.com/vanshg/MacAssistant/releases/download/0.2/MacAssistant.zip) to directly download the latest version.

MacAssistant is currently in Beta.

## Example Queries
*"What's the weather today?"*

*"My agenda for tomorrow."*

*"When was Benedict Cumberbatch born?*"

*"Does the president of the United States have any children?"*

## Build Instructions
MacAssistant is built using Swift 4 and Xcode 9.1

Clone the project using `git clone --recursive https://github.com/vanshg/MacAssistant.git` (This project relies on some submodules to work)

Once cloned, `cd` into the `grpc-swift` directory, and run `make`.

You should then be able to open the `MacAssistant.xcworkspace` file (not `xcproject`!)

You will also need OAuth credentials from the [Google Developer Console](https://console.developers.google.com). In order to get them, you'll need to create a new project and enable the Google Assistant API for that project. Then, generate an OAuth credential, and select the application type of `Other UI`. State that you will be using `User Data`, and then download the json file. Finally, rename the file to `google_oauth.json` and place it in your project (*/MacAssistant/Config/google_oauth.json*).

## Use your own OAuth Credentials
Follow the final step of the Build Instructions to get your `google_oauth.json`. Then download [MacAssistant](https://github.com/vanshg/MacAssistant/releases/download/0.2/MacAssistant.zip), unzip the file, and right click the app to `Show Package Contents`. Next, go to `Contents`, `Resources`, and replace the `google_oauth.json` file with your own.

## Contributing
Please feel free to contribute to this project. I welcome all contributions and pull requests. There is a list of pending things that need to be worked on in the [TODO](TODO.md) file.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
