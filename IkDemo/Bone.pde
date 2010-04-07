class Bone extends Node {
  
  void drawNode () {
    //draw stuff
    
    
    // draw links to child bones
    int nChildren = this.getChildCount();
    for( int i=0; i != nChildren; ++i ) {
      PShape child = this.getChild(i);
      if( this.getClass() == child.getClass() )
        println( "link to child" );
    }
  }
}
