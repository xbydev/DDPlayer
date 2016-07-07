//
//  DDPlayerGLRenderView.m
//  DDPlayer
//
//  Created by xiangbiying on 15/11/23.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import "DDPlayerGLRenderView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>

@interface DDPlayerGLRenderView (){
    CAEAGLLayer* _eaglLayer;
    
    //implements the opengl
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    GLuint _defaultFramebuffer;
}

@property(nonatomic, retain) EAGLContext *context;

@end


@implementation DDPlayerGLRenderView

- (int)connectGLContext
{
    if(![EAGLContext setCurrentContext: self.context])
    {
        NSLog(@"error");
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
    
    return 0;
}

- (int)postDrawFrame
{
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    int ret = [ self.context presentRenderbuffer:GL_RENDERBUFFER] == YES ? 0 : -1;
    
    return ret;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        //we don't want a transparent surface
        eaglLayer.opaque = TRUE;
        
        //here we configure the properties of our canvas, most important is the color depth RGBA8 !
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
        
        //create an OpenGL ES 2 context
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        //if this failed or we cannot set the context for some reason, quit
        if (!self.context || ![EAGLContext setCurrentContext:self.context]) {
            NSLog(@"Could not create context!");
            return nil;
        }
        
        [self createGLContext];
    }
    return self;
}

- (void)createGLContext
{
    // Create default framebuffer object and bind it
    glGenFramebuffers(1, &_defaultFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
    
    // Create color render buffer
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    //get the storage from iOS so it can be displayed in the view
    [ self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    //get the frame's width and height
    GLint framebufferWidth = 0;
    GLint framebufferHeight = 0;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
    
    //    //attach this color buffer to our framebuffer
    //    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
    //create a depth renderbuffer
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    //create the storage for the buffer, optimized for depth values, same size as the colorRenderbuffer
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
    //attach the depth buffer to our framebuffer
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
    
    //check that our configuration of the framebuffer is valid
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    //
    //    glViewport(0, 0, framebufferWidth, framebufferHeight);
}

- (void)dealloc
{
    glDeleteBuffers(1, &_depthRenderBuffer);
    
    glDeleteBuffers(1, &_colorRenderBuffer);
    
    glDeleteBuffers(1, &_defaultFramebuffer);
    
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
}


@end
