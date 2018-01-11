# MacAssistant

[![Github All Releases](https://img.shields.io/github/downloads/vanshg/MacAssistant/total.svg)](https://github.com/vanshg/MacAssistant/releases) [![Travis](https://img.shields.io/badge/Swift-3.1-blue.svg)](https://github.com/vanshg/MacAssistant) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/vanshg/MacAssistant/master/LICENSE) [![Twitter](https://img.shields.io/twitter/url/https/github.com/vanshg/MacAssistant.svg?style=social)](https://twitter.com/intent/tweet?text=Wow:&url=%5Bobject%20Object%5D)

***NOTE: I've currently hit the API limit. In the meantime, you can provide your own OAuth credentials and build the project manually.***

A project that integrates the Google Assistant into macOS, using the Google Assistant SDK.

*"Google Assistant is now on over 100 million devices" - Sundar Pichai @ Google I/O*

MacAssistant can bring that number to 200 million

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

![](images/build_SS01.png)

Once cloned, `cd` into the `grpc-swift` directory, and run `make`.

![](images/build_SS02.png)

You should then be able to open the `MacAssistant.xcworkspace` file (not `xcproject`!)

You will also need OAuth credentials from the [Google Developer Console](https://console.developers.google.com). In order to get them, you'll need to create a new project and enable the Assistant API for that project. Then, generate an OAuth credential, and select application type of `Other`. Download the json file by clicking the button on the right. Finally, rename the file to `google_oauth.json` and place it in your project (*/MacAssistant/google_oauth.json*).

## Contributing
Please feel free to contribute to this project. I welcome all contributions and pull requests. There is a list of pending things that need to be worked on in the [TODO](TODO.md) file.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
