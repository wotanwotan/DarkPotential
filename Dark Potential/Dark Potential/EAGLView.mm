/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

// Subclassed from AR_EAGLView
#import "EAGLView.h"
#import "Texture.h"

#import <QCAR/Renderer.h>

#import "QCARutils.h"

#ifndef USE_OPENGL1
#import "ShaderUtils.h"
#endif

#import "AppDelegate.h"

namespace {
    // Teapot texture filenames
    const char* textureFilenames[] = {
        "Xlanthos.png",
        "Reclaimer_squad_member.png",
        "PMCSniper.png"
    };

    // Model scale factor
    const float kObjectScale = 10.0f;
    
    static const float planeVertices[] = { -6.0, -9, 1.0, 6.0, -9, 1.0, 6.0, 9, 1.0, -6.0, 9, 1.0 };
    
    static const float planeTexcoords[] = { 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0 };
    
    static const float planeNormals[] = { 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0 };
    
    static const unsigned short planeIndices[] = { 0, 1, 2, 0, 2, 3 };
}


@implementation EAGLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
	if (self)
    {
        // create list of textures we want loading - ARViewController will do this for us
        int nTextures = sizeof(textureFilenames) / sizeof(textureFilenames[0]);
        for (int i = 0; i < nTextures; ++i)
            [textureList addObject: [NSString stringWithUTF8String:textureFilenames[i]]];
    }
    return self;
}

/*- (void) setup3dObjects
{
    // build the array of objects we want drawn and their texture
    // in this example we have 3 targets and require 3 models
    // but using the same underlying 3D model of a teapot, differentiated
    // by using a different texture for each
    
    for (int i=0; i < [textures count]; i++)
    {
        Object3D *obj3D = [[Object3D alloc] init];

        obj3D.numVertices = NUM_TEAPOT_OBJECT_VERTEX;
        obj3D.vertices = teapotVertices;
        obj3D.normals = teapotNormals;
        obj3D.texCoords = teapotTexCoords;
        
        obj3D.numIndices = NUM_TEAPOT_OBJECT_INDEX;
        obj3D.indices = teapotIndices;
        
        obj3D.texture = [textures objectAtIndex:i];

        [objects3D addObject:obj3D];
    }
}*/


// called after QCAR is initialised but before the camera starts
- (void) postInitQCAR
{
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
    
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets                
    // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
}

// modify renderFrameQCAR here if you want a different 3D rendering model
////////////////////////////////////////////////////////////////////////////////
// Draw the current frame using OpenGL
//
// This method is called by QCAR when it wishes to render the current frame to
// the screen.
//
// *** QCAR will call this method on a single background thread ***
- (void)renderFrameQCAR
{
    [self setFramebuffer];
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
    //NSLog(@"active trackables: %d", state.getNumActiveTrackables());
    
    if (QCAR::GL_11 & qUtils.QCARFlags) {
        glEnable(GL_TEXTURE_2D);
        glDisable(GL_LIGHTING);
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    for (int i = 0; i < state.getNumActiveTrackables(); ++i) {
        // Get the trackable
        const QCAR::Trackable* trackable = state.getActiveTrackable(i);
        QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackable->getPose());
        
        // for now:
        // stones -> xlanthos
        // chips -> reclaimer
        
//        AppDelegate* appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        // OPTION 1: Choose the texture based on the target name
        /*int targetIndex = 0; // "stones"/"XLanthos"
        if (!strcmp(trackable->getName(), "ReclaimerSSTop"))
        {
            NSLog(@"Tracking the reclaimer...");
            targetIndex = 1;
        }
        else
            NSLog(@"Tracking Xlanthos...");
//        else if (!strcmp(trackable->getName(), "tarmac"))
//            targetIndex = 2;
        
        if (targetIndex == 0 && self.currentCharacter != DP_XLANTHOS)
        {
            NSLog(@"Skip Xlanthos...");
            continue;
        }
        else if (targetIndex == 1 && self.currentCharacter != DP_RECLAIMER)
        {
            NSLog(@"Skip Reclaimer...");
            continue;
        }

        NSInteger objectIndex = targetIndex;
        Object3D *obj3D = [objects3D objectAtIndex:targetIndex];
        */
        
        // OPTION 2: same trackable for all characters
//        int targetIndex = 0;
        NSInteger objectIndex = (self.currentCharacter == DP_XLANTHOS) ? 0 : ((self.currentCharacter == DP_RECLAIMER) ? 1 : 2);
        
//        Object3D *obj3D = [objects3D objectAtIndex:objectIndex];
         
        

        
        // Render using the appropriate version of OpenGL
        /*if (QCAR::GL_11 & qUtils.QCARFlags)
        {
            // Load the projection matrix
            glMatrixMode(GL_PROJECTION);
            glLoadMatrixf(qUtils.projectionMatrix.data);
            
            // Load the model-view matrix
            glMatrixMode(GL_MODELVIEW);
            glLoadMatrixf(modelViewMatrix.data);
            glTranslatef(0.0f, 0.0f, -kObjectScale);
            glScalef(kObjectScale, kObjectScale, kObjectScale);
            
            // Draw object
            glBindTexture(GL_TEXTURE_2D, [obj3D.texture textureID]);
            glTexCoordPointer(2, GL_FLOAT, 0, (const GLvoid*)obj3D.texCoords);
            glVertexPointer(3, GL_FLOAT, 0, (const GLvoid*)obj3D.vertices);
            glNormalPointer(GL_FLOAT, 0, (const GLvoid*)obj3D.normals);
            glDrawElements(GL_TRIANGLES, obj3D.numIndices, GL_UNSIGNED_SHORT, (const GLvoid*)obj3D.indices);
        }
#ifndef USE_OPENGL1
        else*/
        {
            // OpenGL 2
            /*QCAR::Matrix44F modelViewProjection;
            
            ShaderUtils::translatePoseMatrix(0.0f, 0.0f, kObjectScale, &modelViewMatrix.data[0]);
            ShaderUtils::scalePoseMatrix(kObjectScale, kObjectScale, kObjectScale, &modelViewMatrix.data[0]);
            ShaderUtils::multiplyMatrix(&qUtils.projectionMatrix.data[0], &modelViewMatrix.data[0], &modelViewProjection.data[0]);
            
            glUseProgram(shaderProgramID);
            
            glVertexAttribPointer(vertexHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)obj3D.vertices);
            glVertexAttribPointer(normalHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)obj3D.normals);
            glVertexAttribPointer(textureCoordHandle, 2, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)obj3D.texCoords);
            
            glEnableVertexAttribArray(vertexHandle);
            glEnableVertexAttribArray(normalHandle);
            glEnableVertexAttribArray(textureCoordHandle);
            
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, [obj3D.texture textureID]);
            glUniformMatrix4fv(mvpMatrixHandle, 1, GL_FALSE, (const GLfloat*)&modelViewProjection.data[0]);
            glDrawElements(GL_TRIANGLES, obj3D.numIndices, GL_UNSIGNED_SHORT, (const GLvoid*)obj3D.indices);
            
            ShaderUtils::checkGlError("EAGLView renderFrameQCAR");*/
            
            QCAR::Vec2F targetSize = ((QCAR::ImageTarget *) trackable)->getSize();
            
            QCAR::Matrix44F modelViewProjection;
            
            ShaderUtils::translatePoseMatrix(0.0f, 0.0f, kObjectScale, &modelViewMatrix.data[0]);

            ShaderUtils::scalePoseMatrix(targetSize.data[0], targetSize.data[1], 1.0f, &modelViewMatrix.data[0]);
            ShaderUtils::multiplyMatrix(&qUtils.projectionMatrix.data[0], &modelViewMatrix.data[0] , &modelViewProjection.data[0]);
            
            glUseProgram(shaderProgramID);
            glVertexAttribPointer(vertexHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*) &planeVertices[0]);
            glVertexAttribPointer(normalHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*) &planeNormals[0]);
            
            glVertexAttribPointer(textureCoordHandle, 2, GL_FLOAT, GL_FALSE, 0, (const GLvoid*) &planeTexcoords[0]);
            
            glEnableVertexAttribArray(vertexHandle);
            
            glEnableVertexAttribArray(normalHandle);
            
            glEnableVertexAttribArray(textureCoordHandle);
            
            glActiveTexture(GL_TEXTURE0);
            
            Texture* tex = [textures objectAtIndex:objectIndex];
            glBindTexture(GL_TEXTURE_2D, [tex textureID]);
            
            glUniformMatrix4fv(mvpMatrixHandle, 1, GL_FALSE, (GLfloat*)&modelViewProjection.data[0]);
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (const GLvoid*) &planeIndices[0]);
        }
//#endif
    }
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glDisable(GL_BLEND);
    
    if (QCAR::GL_11 & qUtils.QCARFlags) {
        glDisable(GL_TEXTURE_2D);
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    }
#ifndef USE_OPENGL1
    else {
        glDisableVertexAttribArray(vertexHandle);
        glDisableVertexAttribArray(normalHandle);
        glDisableVertexAttribArray(textureCoordHandle);
    }
#endif
    
    QCAR::Renderer::getInstance().end();
    
    [self presentFramebuffer];
}


@end
