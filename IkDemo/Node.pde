class Node extends PShape{
  
  final void draw (PGraphics g) {
    super.draw(g);
    
    //translate node
    this.drawNode();
    //remove translation
  }
  
  void drawNode () {
  }
}
