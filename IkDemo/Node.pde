class Node{

    protected Node m_parent;
    protected ArrayList m_children = new ArrayList();

    protected int m_x, m_y, m_z;

    boolean highlight = false;

    protected int m_size = 20;

    Node (int x, int y, int z, Node parent) {
        m_x = x;
        m_y = y;
        m_z = z;
        m_parent = parent;
    }
    
    Node (int x, int y, int z) { this(x,y,z,null); }
    Node (Node parent) { this(0,0,0,parent); }
    Node () { this(0,0,0,null); }

    // Display {{{
    void display () {
        pushMatrix();
            translate(m_x,m_y);
            if ( highlight ) 
                fill ( 0xccffffff );
            else
                noFill();
            stroke( 0xffffffff );
            if ( m_parent == null )
                rect(-m_size*0.5,-m_size*0.5,m_size,m_size);
            else
                ellipse(0,0,m_size,m_size);

            for (int i = 0 ; i != m_children.size() ; ++i ) {
                Node child = (Node) m_children.get(i);
                child.display();
                stroke( 0x66ff0000 );
                line(child.getX(), child.getY(), 0, 0);
            }
        popMatrix();
    } //}}}

    int getX () {
        return m_x;
    }

    int getY () {
        return m_y;
    }

// {{{
//    int getWorldX () {
//        if ( m_parent != null )
//            return m_x + m_parent.getWorldX();
//        return m_x;
//    }
//    int getWorldY () {
//        if ( m_parent != null )
//            return m_y + m_parent.getWorldY();
//        return m_y;
//    }
// //}}}
    ArrayList getTips () {
        ArrayList tips = new ArrayList();
        if ( m_children.size() == 0 ) {
            tips.add(this);
        } else {
            for ( int i = 0 ; i < m_children.size() ; ++i ){
                Node child = (Node) m_children.get(i);
                tips.addAll(child.getTips());
            }
        }
        return tips;
    }
// {{{
//
//    Node add ( int x, int y ) {
//        println ("Node::add : " + x + " " + y );
//        Node nNode = new Node ( x - getWorldX(), y - getWorldY(), this);
//        m_children.add(nNode);
//        return nNode;
//    } //}}}
}
