# MacAssistant

[![Github All Releases](https://img.shields.io/github/downloads/vanshg/MacAssistant/total.svg)](https://github.com/vanshg/MacAssistant/releases) 
[![Swift](https://img.shields.io/badge/Swift-4.2-blue.svg)](https://github.com/vanshg/MacAssistant)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/vanshg/MacAssistant/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url/https/github.com/vanshg/MacAssistant.svg?style=social)](https://twitter.com/intent/tweet?text=Wow:&url=%5Bobject%20Object%5D)
[![Build Status](https://dev.azure.com/MacAssistant/MacAssistant%20CI/_apis/build/status/vanshg.MacAssistant)](https://dev.azure.com/MacAssistant/MacAssistant%20CI/_build/latest?definitionId=2)

***NOTE: There is a very limited number of API requests Google is willing to grant me. Please use your own OAuth credentials by following the instructions [below](https://github.com/vanshg/MacAssistant#Get-OAuth-Credentials).***

***NOTE: If you're using a new (2018) MacBook and the app crashes, try opening the Audio MIDI Setup app (found in `/Applications/Utilities`), and ensure your format is set to 44.1K***

A project that integrates the Google Assistant into macOS, using the Google Assistant SDK.

*"Google Assistant is now on over 500 million devices”  - Scott Huffman @ Google I/O 2018*

MacAssistant can bring that number up to 600 million

![](images/1.png)
![](images/2.png)
![](images/3.png)

## Download
Downloads are listed under the `Releases` tab.
Click [here](https://github.com/vanshg/MacAssistant/releases/download/0.2/MacAssistant.zip) to directly download the latest version.

MacAssistant is currently in Beta.

## Example Queries
- *What's the weather today?*
- *My agenda for tomorrow*
- *When was Benedict Cumberbatch born?*
- *Does the President of the United States have any children?*

## Build Instructions
MacAssistant is built using Swift 4.2 and Xcode 10

### Get OAuth Credentials
You will need OAuth credentials from the [Google Developer Console](https://console.developers.google.com). 
- Create a new project in the Google Developer Console
- Enable the Google Assistant API for that project
- Generate an OAuth credential
    - Select the application type of `Other UI`
    - State that you will be using `User Data`
    - Download the JSON file
    - Rename the file to `google_oauth.json`
    - Place it in your project at `./MacAssistant/Config/google_oauth.json`

### Building MacAssistant
- Clone the project using `git clone https://github.com/vanshg/MacAssistant.git`
- Open the `MacAssistant.xcworkspace` file (not `xcproject`) in Xcode
- Make sure you've obtained the OAuth Credentials as defined above
- Hit the Play button on the top left

### Updating the Assistant SDK Version 
- If you would like to contribute *and* the Assistant SDK version needs to be updated, clone the repository with the `--recursive` option
- Update `VERSION` found at the top of the `gen_swift_proto.sh` as necessary
- Run `./gen_swfit_proto.sh`
    - This will build the `grpc-swift` module, and then generate the appropriate Swift files from the `.proto` definitions found in the `googleapis` submodule

## Contributing
Please feel free to contribute to this project. I welcome all contributions and pull requests. There is a list of pending things that need to be worked on in the [TODO](TODO.md) file. Please follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
