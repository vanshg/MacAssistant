//
//  SwiftSiriWaveformView.swift
//  Pods
//
//  Created by Alankar Misra on 7/23/15.
//
//  Swift adaption of: https://github.com/stefanceriu/SCSiriWaveformView (interface incompatible)
import Cocoa

open class SpeechWaveformView : NSView {
    /*
     * The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
     * Default: 1.5
     */
    @IBInspectable open var frequency:CGFloat = 1.5
    
    /*
     * The amplitude that is used when the incoming amplitude is near zero.
     * Setting a value greater 0 provides a more vivid visualization.
     * Default: 0.01
     */
    @IBInspectable open var idleAmplitude:CGFloat = 0.01
    
    /*
     * The phase shift that will be applied with each level setting
     * Change this to modify the animation speed or direction
     * Default: -0.15
     */
    @IBInspectable open var phaseShift:CGFloat = -0.15
    
    /*
     * The lines are joined stepwise, the more dense you draw, the more CPU power is used.
     * Default: 1
     */
    @IBInspectable open var density:CGFloat = 1.0
    
    /*
     * Line width used for the prominent wave
     * Default: 1.5
     */
    @IBInspectable open var primaryLineWidth:CGFloat = 1.5
    
    /*
     * Line width used for all secondary waves
     * Default: 0.5
     */
    @IBInspectable open var secondaryLineWidth:CGFloat = 0.5
    
    
    /*
     * The total number of waves
     * Default: 6
     */
    @IBInspectable open var numberOfWaves:Int = 6
    
    /*
     * Color to use when drawing the waves
     * Default: white
     */
    @IBInspectable open var waveColor:NSColor = NSColor.white
    
    
    /*
     * The current amplitude.
     */
    @IBInspectable open var amplitude:CGFloat = 1.0 {
        didSet {
            amplitude = max(amplitude, self.idleAmplitude)
            self.setNeedsDisplay(frame)
        }
    }
    
    fileprivate var phase:CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        // Convenience function to draw the wave
        func drawWave(_ index:Int, maxAmplitude:CGFloat, normedAmplitude:CGFloat) {
            let path = NSBezierPath()
            let mid = self.bounds.width/2.0
            
            path.lineWidth = index == 0 ? self.primaryLineWidth : self.secondaryLineWidth
            
            for x in Swift.stride(from:0, to:self.bounds.width + self.density, by:self.density) {
                // Parabolic scaling
                let scaling = -pow(1 / mid * (x - mid), 2) + 1
                let y = scaling * maxAmplitude * normedAmplitude * sin(CGFloat(2 * Double.pi) * self.frequency * (x / self.bounds.width)  + self.phase) + self.bounds.height/2.0
                if x == 0 {
                    path.move(to: CGPoint(x:x, y:y))
                } else {
                    path.line(to: CGPoint(x:x, y:y))
                }
            }
            //            for var x:CGFloat = 0; x < (self.bounds.width + self.density); x += self.density {
            //
            //            }
            path.stroke()
        }
        
        let context = NSGraphicsContext()
        context.shouldAntialias = true
//        self.backgroundColor?.set()
//        context.fill(rect)
        
        let halfHeight = self.bounds.height / 2.0
        let maxAmplitude = halfHeight - self.primaryLineWidth
        
        for i in 0 ..< self.numberOfWaves {
            let progress = 1.0 - CGFloat(i) / CGFloat(self.numberOfWaves)
            let normedAmplitude = (1.5 * progress - 0.8) * self.amplitude
            let multiplier = min(1.0, (progress/3.0*2.0) + (1.0/3.0))
            self.waveColor.withAlphaComponent(multiplier * self.waveColor.cgColor.alpha).set()
            drawWave(i, maxAmplitude: maxAmplitude, normedAmplitude: normedAmplitude)
        }
        self.phase += self.phaseShift
    }
    
    
}
