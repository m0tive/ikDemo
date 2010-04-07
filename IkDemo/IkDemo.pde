/**
 * IkDemo - CGI Techniques
 * by Peter Dodds (peterdodds.co.uk)
 * NCCA MSc Computer Animation and Visual Effects 2009-10
 *
 * [Instructions]
 *
 * [Description]
 */

import processing.opengl.*;
 
Bone bones[];
final int nBones = 4;

void setup() {
  size(1024, 768, OPENGL);
  background(0, 0, 0);
  
  bones = new Bone[nBones];
}

void draw() {
  background(0);
  
  for (int i=0; i != nBones; i++) {
  }
}
