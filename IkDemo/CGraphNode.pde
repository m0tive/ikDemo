// A graph node containing child CNodes
class CGraphNode extends CNode {

    // Dynamic array of node's CNode children.
    ArrayList m_children = new ArrayList();

    // Constructors to call parent constructors
    CGraphNode () { super(); }
    CGraphNode (int _id) { super(_id); }
    CGraphNode (float _x, float _y, float _z) { super(_x,_y,_z); }
    CGraphNode (float _x, float _y, float _z, int _id) { super(_x,_y,_z,_id); }

    //--------------------------------------------------------------------------

    // Childing Functions {{{

    // Add a child to the graph node.
    // This adds a CNode to the scene hierarchy as a child of this node.
    // param: _child - the CNode to add as a child.
    void addChild (CNode _child) {
        if (_child.getParent() == null) {
            m_children.add(_child);
            _child.setParent(this);
        }
    }

    // Check if a Node is a child of this node
    // param: _child - CNode to check.
    // return: boolean - True if the node is in m_children.
    boolean hasChild (CNode _child) {
        int size = m_children.size();
        for ( int i = 0 ; i < size ; ++i ){
            if ( _child == (CNode) m_children.get(i) )
                return true;
        }
        return false;
    }

    //}}}

    //--------------------------------------------------------------------------

    // Drawing Functions {{{

    // Draw the node to a graphics buffer.
    // Overrides the display function in CNode, added a call to 
    // displayChildren() after drawing its self.
    // param: gout - the output PGraphics display buffer
    void display (PGraphics gout) {
        gout.pushMatrix();
        this.applyMatrix(gout);

        this.geom(gout);
        displayChildren(gout);

        gout.popMatrix();
    }

    // Draw all the child nodes.
    // param: gout - the output PGraphics display buffer
    protected void displayChildren (PGraphics gout) {
        int size = m_children.size();
        for ( int i = 0 ; i < size ; ++i ){
             ((CNode) m_children.get(i)).display(gout);
        }
    }


    // Draw the node's id shape to a graphics buffer.
    // Overrides the idDisplay function in CNode, added a call to 
    // idDisplayChildren() after drawing its self.
    // param: gout - the output PGraphics display buffer.
    void idDisplay (PGraphics gout) {
        gout.pushStyle();
        gout.fill(0xFF000000 + m_id);

        gout.pushMatrix();
        this.applyMatrix(gout);

        this.idGeom(gout);
        idDisplayChildren(gout);

        gout.popMatrix();
        gout.popStyle();
    }

    // Draw all the child nodes' id shapes.
    // param: gout - the output PGraphics display buffer
    protected void idDisplayChildren (PGraphics gout) {
        int size = m_children.size();
        for ( int i = 0 ; i < size ; ++i ){
             ((CNode) m_children.get(i)).idDisplay(gout);
        }
    }

    //}}}
}
