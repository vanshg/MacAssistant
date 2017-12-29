//
// Theme.swift
//
// Copyright (c) 2015-2016 Damien (http://delba.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

public class Themes {}

public class Theme: Themes {
    /// The theme colors.
    internal var colors: [Level: String]
    
    /// The theme textual representation.
    internal var description: String {
        return colors.keys.sorted().map {
            $0.description.withColor(colors[$0]!)
        }.joined(separator: " ")
    }
    
    /**
     Creates and returns a theme with the specified colors.
     
     - parameter trace:   The color for the trace level.
     - parameter debug:   The color for the debug level.
     - parameter info:    The color for the info level.
     - parameter warning: The color for the warning level.
     - parameter error:   The color for the error level.
     
     - returns: A theme with the specified colors.
     */
    public init(trace: String, debug: String, info: String, warning: String, error: String) {
        self.colors = [
            .trace:   Theme.formatHex(trace),
            .debug:   Theme.formatHex(debug),
            .info:    Theme.formatHex(info),
            .warning: Theme.formatHex(warning),
            .error:   Theme.formatHex(error)
        ]
    }
    
    /**
     Returns a string representation of the hex color.
     
     - parameter hex: The hex color.
     
     - returns: A string representation of the hex color.
     */
    private static func formatHex(_ hex: String) -> String {
        let scanner = Scanner(string: hex)
        var hex: UInt32 = 0
        
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hex)
        
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0xFF00) >> 8
        let b = (hex & 0xFF)
        
        return [r, g, b].map({ String($0) }).joined(separator: ",")
    }
}
