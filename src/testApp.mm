#include "testApp.h"
#include "MyGuiView.h"

MyGuiView * myGuiViewController;


//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
		
	//NOTE WE WON'T RECEIVE TOUCH EVENTS INSIDE OUR APP WHEN THERE IS A VIEW ON TOP OF THE OF VIEW

    
	//Our Gui setup
	myGuiViewController	= [[MyGuiView alloc] initWithNibName:@"MyGuiView" bundle:nil];
	[ofxiPhoneGetUIWindow() addSubview:myGuiViewController.view];

	ofBackground(0,0,0);
    
    //Initializing stuff for Image Picker
    cameraPixels      = NULL;
    imagePicker       = new ofxiPhoneImagePicker();
    imagePicker->setMaxDimension(480);   //To avoid enormous images
    
    //photo.loadImage("images/pic.JPG");
}

//--------------------------------------------------------------
void testApp::update(){
    
    if(imagePicker->imageUpdated){
		
		// the pixels seem to be flipped, so let's unflip them: 
		if (cameraPixels == NULL){
			// first time, let's get memory based on how big the image is: 
			cameraPixels = new unsigned char [imagePicker->width * imagePicker->height*4];

		}
		// now, lets flip the image vertically:
		for (int i = 0; i < imagePicker->height; i++){
			memcpy(cameraPixels+(imagePicker->height-i-1)*imagePicker->width*4, imagePicker->pixels+i*imagePicker->width*4, imagePicker->width*4);
		}
		
		// turn RGBA image into a an RGB ofImage... this way I'll be able to manipulate it.
        unsigned char * newPixels = new unsigned char [imagePicker->width * imagePicker->height * 3];
        int newIndex = 0;
        for (int j=0; j < imagePicker->width * imagePicker->height * 4; j+=4) {
            newPixels[newIndex] = cameraPixels[j];
            newPixels[newIndex+1] = cameraPixels[j+1];
            newPixels[newIndex+2] = cameraPixels[j+2];
            newIndex +=3;
        }
        
		photo.setFromPixels(newPixels, imagePicker->width, imagePicker->height, OF_IMAGE_COLOR);
        imagePicker->imageUpdated=false;
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	photo.draw(0, 0);
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){

	//IF THE VIEW IS HIDDEN LETS BRING IT BACK!
	if( myGuiViewController.view.hidden ){
		myGuiViewController.view.hidden = NO;
	}	
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

void testApp::lostFocus(){
    
}

void testApp::gotFocus(){
    
}

void testApp::gotMemoryWarning(){
    
}

void testApp::deviceOrientationChanged(int newOrientation){
    
}

void testApp::loadPhoto(){
    printf("Opening photo library\n");
    imagePicker->openLibrary();
    
}

void testApp::takePhoto(){
    printf("Opening Camera\n");
    imagePicker->openCamera();
}

void testApp::savePhoto(){
    printf("Saving Photo not available now\n");
}

void testApp::invert(){
    printf("Inverting pixels\n");
    
    //-- iterate through the pixels and substract their value from 255, which gives me an inverted image
    unsigned char * pixels = photo.getPixels();
    for (int i=0; i<photo.width * photo.height * 3; i++) {
        pixels[i] = 255 - pixels[i];
    }
    photo.setFromPixels(pixels, photo.width, photo.height, OF_IMAGE_COLOR);
}