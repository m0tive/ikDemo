// The IK Chain.
// Derived from CNode, the chain cannot have any children but is intended to be
// attached to a CBone.
class CIkChain extends CNode {

    // Array of bones in the IK chain
    private CBone[] m_chain;
    // A reference to the goal node
    private CGraphNode m_goal;
    // The goals relative position
    private Vec3D m_goalPos;

    // Constructors {{{

    // Constructor with start and end bones.
    // param: _begin - First CBone in the chain.
    // param: _end - Last CBone in the chain.
    CIkChain (CBone _begin, CBone _end) { this(_begin,_end,0); }
    // Constructor with start and end bones, plus id number.
    // param: _begin - First CBone in the chain.
    // param: _end - Last CBone in the chain.
    // param: _id - id number
    CIkChain (CBone _begin, CBone _end, int _id) {
        super(_id);

        m_size = 50;
        // Build the IK chain.
        buildChain(_begin,_end);
        // Add this node to the first bone in the chain.
        _begin.addChild(this);
    }

    //}}}

    //--------------------------------------------------------------------------

    // Display Functions {{{

    // Draw the node to a graphics buffer.
    // Adds a call to update().
    // param: gout - the output PGraphics display buffer
    void display (PGraphics gout) {
        this.update();
        super.display(gout);
    }

    // Draw the nodes shape.
    // param: gout - the output PGraphics display buffer
    protected void geom (PGraphics gout) {
        pushStyle();
        gout.noFill();
        gout.stroke(0xffff00ff);
        float halfsize = m_size*0.5;
        gout.line(-halfsize,0,0,halfsize,0,0);
        gout.line(0,-halfsize,0,0,halfsize,0);
        gout.line(0,0,-halfsize,0,0,halfsize);

        if (m_goal != null && m_goalPos != null ) {
            gout.line(0,0,0,m_goalPos.x,m_goalPos.y,m_goalPos.z);
        }

        popStyle();
    }

    // Remove the functionality of the id shape.
    // This is just intended to stop CIkChain from having an id shape.
    protected void idGeom (PGraphics gout) {}

    //}}}

    //--------------------------------------------------------------------------

    // IK functions {{{

    // Get the last bone in the chain.
    // return: CBone - the last bone.
    CBone getTip () {
        return m_chain[m_chain.length - 1];
    }

    // Set the goal Node.
    // param: _goal - the goal CNode.
    // param: _snap - boolean, whether to move the goal to the last bones.
    void setGoal (CGraphNode _goal, boolean _snap) {
        if (_goal.getParent() == null)
            root.addChild(_goal);

        m_goal = _goal;

        // if snapping, move the goal node to the position of the end bone
        if (_snap) {
            Vec3D move = m_goal.getVectorTo(m_chain[m_chain.length-1]);
            m_goal.position.addSelf(move);
        }
    }

    // Update the IK chain.
    void update () { //{{{
        if (m_goal != null) {
            m_goalPos = getVectorTo(m_goal);

            Vec3D goalVec, tipVec, rotAxis, upVec = new Vec3D(0,1,0);
            Quaternion currQuat = new Quaternion();
            float angle;
            int close = 0;

            float distance = 1;
            int k = 0;
            while(close != m_chain.length-1 && distance > 0.1 && k < 100) {
                for (int i = m_chain.length - 2; i != -1; --i) {
                    goalVec = m_chain[i].getVectorTo(m_goal);
                    tipVec = m_chain[i].getVectorTo(getTip());
                    angle = goalVec.angleBetween(tipVec,true);

                    if (angle > 0.00001) {
                        // get the rotation axis...
                        rotAxis = goalVec.cross(tipVec).normalize();

                        Quaternion goalQuat =
                            Quaternion.createFromAxisAngle(rotAxis,-angle);

                        // SLERP it...
                        Quaternion slerpQuat = 
                            currQuat.interpolateTo(goalQuat,0.5);

                        m_chain[i].rotation = m_chain[i].rotation.multiply(slerpQuat);
                    } else {
                        ++close;
                    }

                }
                tipVec = m_goal.getVectorTo(getTip());
                distance = tipVec.magnitude();
                ++k;
            }
        }
    }//}}}

    // Build the array of bones.
    // This is done backwards, stepping through the CNodes' parents from the
    // the end to the beginning.
    // param: _begin - First CBone in the chain.
    // param: _end - Last CBone in the chain.
    // return: boolean - False is if no link is found, or if the nodes 
    //      are not CBones
    protected boolean buildChain (CBone _begin, CBone _end) { // {{{
        if (_begin == null || _end == null)
            return false;
        CGraphNode curr = _end;
        int i;
        for (i = 0; curr != _begin; ++i) {
            if (curr == null || !(curr instanceof CBone))
                return false;

            curr = curr.getParent();
        }

        // build array...
        m_chain = new CBone [i+1];

        curr = _end;
        // loop backwards, adding bones.
        // This goes one beyond the first loop, adding _begin
        for (int j = i; j != -1; --j) {
            m_chain[j] = (CBone) curr;
            println(j);
            curr = curr.getParent();
        }

        return true;
    } //}}}

    //}}}
}
