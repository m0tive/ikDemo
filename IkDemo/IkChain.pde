class IkChain extends Node {
  Bone bones[];
  
  void drawNode () {
    println( "drawing " + this.getClass() );
  }
}
