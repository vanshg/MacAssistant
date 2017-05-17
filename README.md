# MacAssistant

A project to integrate the Google Assistant into macOS using the Google Assistant SDK

*"Google Assistant is now on over 100 million devices" - Sundar Pichai*

MacAssistant brings that number to 200 million

![](images/1.png)
![](images/2.png)
![](images/3.png)

## Download
Downloads are listed under the `Releases` tab.
Click [here](https://github.com/vanshg/MacAssistant/releases/download/0.2/MacAssistant.zip) to directly download the latest version.

This project is currently in Beta

## Example Queries
*"What time is it"*

*"Who is the president"*, 
*"How old is he"*, 
*"Does he have any children"*

as well as anything else you can normally ask Google Assistant

## Builid Instructions
MacAssistant is built using Swift 3.1 and Xcode 8

Dependencies are managed using Carthage. After you clone the project, run `carthage update --platform macOS`. (If you don't have Carthage, refer [here](https://github.com/Carthage/Carthage) for installation instructions)

You will also need to obtain OAuth credentials from Google. Go to [Google Developer Console](console.developers.google.com) and create a new project. Then, enable the `Google Assistant` API. Finally generate new OAuth credentials (select device type `Other`). Download the json file by clicking the button on the right. Finally, rename the file to `google_oauth.json` and place it in your project.

## Contributing
Please feel free to contribute to this project. I welcome all contributions and pull requests. There is a list of pending things that need to be worked on in the `TODO.md` file.

## License
MIT License

Copyright (c) 2017 Vansh Gandhi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
