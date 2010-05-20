import processing.core.PMatrix;

// Base 3D scene node class.
class CNode{
    // Local transformation as a 3D Vector.
    Vec3D position;
    // Local rotation as a quaternion.
    Quaternion rotation;

    // Node id, used in idDisplay
    protected int m_id;
    // Node `size'. Used in classes as a general size for keeping display
    // and idDisplay roughly the same shape.
    protected float m_size;

    // Parent graph node.
    private CGraphNode m_parent;

    // Constructors {{{

    // Default constructor
    CNode() {
        this(0,0,0,0);
    }

    // Constructor to set id
    // param: _id - id number
    CNode(int _id) {
        this(0,0,0,_id);
    }

    // Constructor for setting initial translation.
    // param: _x - x-axis rotation.
    // param: _y - y-axis rotation.
    // param: _z - z-axis rotation.
    CNode(float _x, float _y, float _z) {
        this(_x,_y,_z,0);
    }

    // Constructor for setting translation and id.
    // param: _id - id number
    // param: _x - x-axis rotation.
    // param: _y - y-axis rotation.
    // param: _z - z-axis rotation.
    CNode(float _x, float _y, float _z, int _id) {
        position = new Vec3D (_x, _y, _z);
        rotation = new Quaternion();
        this.setId(_id);

        m_size = 30;
    }

    //}}}

    //--------------------------------------------------------------------------

    // Transform Functions {{{

    // Add pitch rotation
    // param: _a - angle to rotate by in radians
    void pitch (float _a) {
        rotation = rotation.multiply(Quaternion.createFromEuler(0,0,_a));
    }

    // Add yaw rotation
    // param: _a - angle to rotate by in radians
    void yaw (float _a) {
        rotation = rotation.multiply(Quaternion.createFromEuler(_a,0,0));
    }

    // Add roll rotation
    // param: _a - angle to rotate by in radians
    void roll (float _a) {
        rotation = rotation.multiply(Quaternion.createFromEuler(0,_a,0));
    }

    // Calculate the local transformation matrix
    // return: Matrix4x4 - the transformation matrix
    Matrix4x4 getMatrix() {
        Matrix4x4 mat = new Matrix4x4();
        mat.translateSelf(position);
        Matrix4x4 rot = rotation.toMatrix4x4();
        return mat.multiply(rot);
    }

    // Calculate the world matrix.
    // This calculates the accumulative transformation matrix for all of
    // the node's parents.
    // return: Matrix4x4 - the world transformation matrix
    Matrix4x4 getWorldMatrix() {
        if(m_parent == null)
            return getMatrix();

        Matrix4x4 out = new Matrix4x4(getMatrix());
        Matrix4x4 pma = m_parent.getWorldMatrix();
        return pma.multiply(out);
    }

    // Apply the node's transformation matrix to a output buffer.
    // param: gout - PGraphics buffer to apply the transformation to.
    void applyMatrix(PGraphics gout) {
        PMatrix3D mat = new PMatrix3D();
        mat.set(getMatrix().toFloatArray(null));

        gout.applyMatrix(mat);
    }

    //}}}

    //--------------------------------------------------------------------------

    // Data getters and setters {{{

    // Get the node's id
    // return: int - node id
    int getId () {
        return m_id;
    }

    // Set the id
    private void setId (int _id) {
        m_id = _id;
    }

    // Set the nodes parent.
    // This is a safety function to check that appropriate parents are being
    // set for this node. If the parent does not already have this node in its
    // list of children, then it will not be added as a parent.
    // param: _parent - CGraphNode to try and add as a parent.
    void setParent (CGraphNode _parent) {
        if (_parent == null) {
            if (m_parent != null && !m_parent.hasChild(this) ) {
                m_parent = null;
            }
        } else if (_parent.hasChild(this)) {
            if (m_parent == null || !m_parent.hasChild(this) ) {
                m_parent = _parent;
            }
        }
    }

    // Get this node's parent graph node.
    // return: CGraphNode - the graph node that this node is within or null.
    CGraphNode getParent () {
        return m_parent;
    }

    // Get a vector in this node's local space to another node.
    // param: _n - the CNode to get the vector to.
    // return Vec3D - the vector to _n.
    Vec3D getVectorTo(CNode _n) {
        Vec3D out = new Vec3D();

        Matrix4x4 gMat = _n.getWorldMatrix();
        Matrix4x4 mMat = this.getWorldMatrix();
        mMat.invert();
        out = gMat.applyTo(out);
        return mMat.applyTo(out);
    }

    //}}}

    //--------------------------------------------------------------------------

    // Display Functions {{{

    // Draw the node to a graphics buffer.
    // Beforing calling geom() to draw the node's shape, the transformation 
    // matrix is applied using applyMatrix().
    // param: gout - the output PGraphics display buffer
    void display (PGraphics gout) {
        gout.pushMatrix();
        this.applyMatrix(gout);

        this.geom(gout);

        gout.popMatrix();
    }

    // Draw the id shape.
    // Similar to display() but the id is first converted to a hexadecimal 
    // number and used as the fill colour. Also, idGeom() is called instead of
    // geom()
    // param: gout - the output PGraphics display buffer
    void idDisplay (PGraphics gout) {
        gout.pushStyle();
        gout.fill(0xFF000000 + m_id);

        gout.pushMatrix();
        this.applyMatrix(gout);

        this.idGeom(gout);

        gout.popMatrix();
        gout.popStyle();
    }

    // Draw the nodes shape.
    // Called by display. The default CNode geom() draws three axis aligned
    // lines in light blue of length m_size.
    // param: gout - the output PGraphics display buffer
    protected void geom (PGraphics gout) {
        pushStyle();
        gout.noFill();
        gout.stroke(0xff00ffff);
        float halfsize = m_size*0.5;
        gout.line(-halfsize,0,0,halfsize,0,0);
        gout.line(0,-halfsize,0,0,halfsize,0);
        gout.line(0,0,-halfsize,0,0,halfsize);
        popStyle();
    }

    // Draw the nodes id display goem.
    // Called by idDisplay(). The default id shape is a sphere of radius m_size.
    // param: gout - the output PGraphics display buffer
    protected void idGeom (PGraphics gout) {
        gout.sphere(m_size);
    }

    //}}}

}
