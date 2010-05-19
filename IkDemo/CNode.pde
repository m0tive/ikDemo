import processing.core.PMatrix;

class CNode{
    Vec3D position;
    Quaternion rotation;

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
        position = new Vec3D (_x, _y, _z);
        rotation = new Quaternion();
        this.setId(_id);

        m_size = 30;
    }

    void pitch (float _a) {
        rotation = rotation.multiply(Quaternion.createFromEuler(0,0,_a));
    }

    void yaw (float _a) {
        rotation = rotation.multiply(Quaternion.createFromEuler(_a,0,0));
    }

    void roll (float _a) {
        rotation = rotation.multiply(Quaternion.createFromEuler(0,_a,0));
    }

    Matrix4x4 getMatrix() {
        Matrix4x4 mat = new Matrix4x4();
        mat.translateSelf(position);
        Matrix4x4 rot = rotation.toMatrix4x4();
        return mat.multiply(rot);
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
