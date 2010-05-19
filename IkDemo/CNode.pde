import processing.core.PMatrix;

class CNode{

    protected float m_x, m_y, m_z;
    float m_pitch, m_roll, m_yaw;

    private Matrix4x4 m_mat;
    protected int m_id;
    protected float m_size;

    private CGraphNode m_parent;

    CNode() {
        this(0,0,0,0);
    }

    CNode(int _id) {
        this(0,0,0,_id);
    }

    CNode(float _x, float _y, float _z) {
        this(_x,_y,_z,0);
    }

    CNode(float _x, float _y, float _z, int _id) {
        m_x = _x;
        m_y = _y;
        m_z = _z;
        this.setId(_id);

        m_mat = new Matrix4x4();

        m_size = 30;
    }

    void setX (float _x) {
        m_x = _x;
    }

    void setY (float _y) {
        m_y = _y;
    }

    void setZ (float _z) {
        m_z = _z;
    }

    Matrix4x4 getMatrix() {
        m_mat.identity();
        m_mat.translateSelf(m_x,m_y,m_z);
        m_mat.rotateX(m_pitch);
        m_mat.rotateY(m_yaw);
        m_mat.rotateZ(m_roll);

        return new Matrix4x4 (m_mat);
    }

    Matrix4x4 getWorldMatrix() {
        if(m_parent == null)
            return getMatrix();

        Matrix4x4 out = new Matrix4x4(getMatrix());
        Matrix4x4 pma = m_parent.getWorldMatrix();
        return pma.multiply(out);
    }

    void applyMatrix(PGraphics gout) {
        PMatrix3D mat = new PMatrix3D();
        mat.set(getMatrix().toFloatArray(null));

        gout.applyMatrix(mat);
    }

    float[] getPosition () {
        float[] out = {m_x,m_y,m_z};
        return out;
    }

    int getId () {
        return m_id;
    }

    private void setId (int _id) {
        m_id = _id;
    }

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

    CGraphNode getParent () {
        return m_parent;
    }

    Vec3D getVectorTo(CNode _n) {
        Vec3D out = new Vec3D();

        Matrix4x4 gMat = _n.getWorldMatrix();
        Matrix4x4 mMat = this.getWorldMatrix();
        mMat.invert();
        out = gMat.applyTo(out);
        return mMat.applyTo(out);
    }

    void display (PGraphics gout) {
        gout.pushMatrix();
        this.applyMatrix(gout);

        this.geom(gout);

        gout.popMatrix();
    }

    void idDisplay (PGraphics gout) {
        gout.pushStyle();
        gout.fill(0xFF000000 + m_id);

        gout.pushMatrix();
        this.applyMatrix(gout);

        this.idGeom(gout);

        gout.popMatrix();
        gout.popStyle();
    }

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

    protected void idGeom (PGraphics gout) {
        gout.sphere(m_size);
    }

}
