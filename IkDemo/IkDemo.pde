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

Node root = new Node();

void setup() {
  size(720, 576, OPENGL);
  
  root.addChild( new IkChain () );
  shape(root);
}

void draw() {
  background(190);
}
