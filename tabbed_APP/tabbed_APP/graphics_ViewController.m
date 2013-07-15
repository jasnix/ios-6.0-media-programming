/*
 * The MIT License
 *
 *  Created by Jasin Alili on 20.05.13.
 *  Copyright (c) 2013 Jasin Alili. All rights reserved.
 *  Email: jasin@aon.at
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "graphics_ViewController.h"

GLfloat triangle_VertexData[9] =
{
    -0.5f, 0.0f, 0.0f,      // (x1, y1, z1)
    0.5f, 0.0f, 0.0f,       // (x2, y2, z2)
    0.0f, 0.5f, 0.0f        // (x3, y3, z3)
};

@implementation graphics_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // manages the state, required by OpenGL ES -> makes it easy to share graphics hardware
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    [self setupGL];
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.constantColor =  GLKVector4Make(1.0, 1.0, 0.0, 0.3);    // Vertex Color
    //   self.effect.light0.enabled = GL_TRUE;
    //   self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(triangle_VertexData), triangle_VertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, (void*)0);
}

// GLKViewController delegate method
- (void)update
{
    // check the perspektive view - create projectionmatrix
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), aspect, 1.0f, 10.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // do rotation over the x-axis
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -3.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, rotation, 1.0f, 0.0f, 0.0f);
    self.effect.transform.modelviewMatrix = baseModelViewMatrix;
    rotation += self.timeSinceLastUpdate * 0.9f;    
}

// GLKView delegate method
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Background Color
    glClearColor( 0.1f, 0.2f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 3);            
}


// free vertexbuffer and context
 - (void)quitGL
 {
     [EAGLContext setCurrentContext:self.context];
     glDeleteBuffers(1, &vertexBuffer);
     self.effect = nil;
 }

// free memory if warning appears
 - (void)didReceiveMemoryWarning
 {
     [super didReceiveMemoryWarning];
 
     if ([self isViewLoaded] && ([[self view] window] == nil))
     {
         self.view = nil;
 
         [self quitGL];
 
         if ([EAGLContext currentContext] == self.context)
             [EAGLContext setCurrentContext:nil];
         
         self.context = nil;
     }
 }

// done by autorelease
/*
- (void)dealloc
{
    [self quitGL];
    
    if ([EAGLContext currentContext] == self.context)    
        [EAGLContext setCurrentContext:nil];
    
}
*/

@end
