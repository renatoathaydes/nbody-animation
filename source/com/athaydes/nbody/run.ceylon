NBodySystem bodiesSystem = NBodySystem();

shared dynamic Element {}

shared dynamic Canvas satisfies Element {
    shared formal Float width;
    shared formal Float height;
    shared formal Context getContext(String contextId);
}

shared dynamic Context {
    shared formal variable String fillStyle;

    shared formal void beginPath();

    shared formal void arc(
            Float x1, Float y1,
            Float x2, Float y2,
            Float radius);

    shared formal void fill();

    shared formal void clearRect(
            Float x, Float y,
            Float w, Float h);
}

shared dynamic Document {
    shared formal
    Element? getElementById<Element>(String id)
            given Element satisfies package.Element;
}

shared dynamic Window {
    shared formal
    void requestAnimationFrame(
            Anything() callback);
}

Document doc { dynamic { return document; } }

Window win { dynamic { return window; } }

shared void run() {
    assert(exists canvas = doc.getElementById<Canvas>("screen"));
    value context = canvas.getContext("2d");
    value offsetX = canvas.width / 2;
    value offsetY = canvas.height / 2;

    value bodyDrawer = BodyDrawer(context, offsetX, offsetY);
    void tick() {
        context.clearRect(0.0, 0.0, canvas.width, canvas.height);
        for (body in bodiesSystem.bodies) {
            bodyDrawer.draw(body);
        }
        updateBodies();
        win.requestAnimationFrame(tick);
    }
    tick();
}

shared void updateBodies() => bodiesSystem.advance(0.05);
