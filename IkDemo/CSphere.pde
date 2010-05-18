class CSphere extends CNode {

    CSphere (int _id) { super(_id); }
    CSphere (float _x, float _y, float _z) { super(_x,_y,_z); }
    CSphere (float _x, float _y, float _z, int _id) { super(_x,_y,_z,_id); }

    protected void geom (PGraphics gout) {
        gout.sphere(30);
    }
}
