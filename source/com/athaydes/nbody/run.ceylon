NBodySystem bodiesSystem = NBodySystem();

shared dynamic Element {
    shared formal String? id;
}

shared dynamic Canvas satisfies Element {
    shared formal Float width;

    shared formal Float height;

    shared formal Context getContext<Context>(String contextId)
            given Context satisfies RenderingContext;
}

shared dynamic RenderingContext
        of WebGLRenderingContext | CanvasRenderingContext2D {}

shared dynamic WebGLRenderingContext satisfies RenderingContext {
    shared formal variable Integer drawingBufferWidth;
    shared formal variable Integer drawingBufferHeight;
}

shared dynamic CanvasRenderingContext2D satisfies RenderingContext {

    "Color or style to use inside shapes. Default #000 (black).

     [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillStyle)"
    shared formal variable String fillStyle;

    "Starts a new path by emptying the list of sub-paths. Call
     this method when you want to create a new path

     [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/beginPath)"
    shared formal void beginPath();

    "Adds an arc to the path which is centered at (x, y) position
     with radius r starting at startAngle and ending at endAngle
     going in the given direction by anticlockwise (defaulting
     to clockwise).

     [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/arc)"
    shared formal void arc(
            Float x1, Float y1,
            Float x2, Float y2,
            Float radius);

    "Fills the subpaths with the current fill style.

     [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fill)"
    shared formal void fill();

    "Sets all pixels in the rectangle defined by starting point
     (x, y) and size (width, height) to transparent black, erasing
     any previously drawn content.

     [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/clearRect)"
    shared formal void clearRect(
            Float x, Float y,
            Float w, Float h);
}

shared dynamic Document {
    shared formal
    Element? getElementById<Element>(String id)
            given Element satisfies package.Element;
}

"The [[DOMHighResTimeStamp]] type is a double representing a number
 of milliseconds, accurate to the thousandth of millisecond, that
 is with a precision of 1 µs."
shared alias DOMHighResTimeStamp => Float;

"The `window` object represents a window containing a DOM document;
 the document property points to the DOM document loaded in that
 window. A window for a given document can be obtained using the
 `document.defaultView` property."
shared dynamic Window {
    "The [[requestAnimationFrame]] method tells the browser
     that you wish to perform an animation and requests that the
     browser call a specified function to update an animation before
     the next repaint. The method takes as an argument a callback to
     be invoked before the repaint.

     **Note**: Your callback routine must itself call `requestAnimationFrame`
     if you want to animate another frame at the next repaint.

     You should call this method whenever you're ready to update your
     animation onscreen. This will request that your animation function
     be called before the browser performs the next repaint. The number
     of callbacks is usually 60 times per second, but will generally match
     the display refresh rate in most web browsers as per W3C recommendation.
     The callback rate may be reduced to a lower rate when running in
     background tabs.

     The callback method is passed a single argument, a [[DOMHighResTimeStamp]],
     which indicates the current time when callbacks queued by
     `requestAnimationFrame` begin to fire. Multiple callbacks in a single frame,
     therefore, each receive the same timestamp even though time has passed
     during the computation of every previous callback's workload. This
     timestamp is a decimal number, in milliseconds, but with a minimal
     precision of 1ms (1000 µs)."
    shared formal
    void requestAnimationFrame(
            Anything(DOMHighResTimeStamp) callback);
}

"Each web page loaded in the browser has its own document object. The
 Document interface serves as an entry point into the web page's content
 (the DOM tree, including elements such as <body> and <table>) and provides
 functionality which is global to the document (such as obtaining the page's
 URL and creating new elements in the document).

 Note: The Document interface also inherits from the Node and EventTarget
 interfaces."
Document doc { dynamic { return document; } }

"The `window` object represents a window containing a DOM document;
 the document property points to the DOM document loaded in that
 window. A window for a given document can be obtained using the
 `document.defaultView` property."
Window window { dynamic { return document.defaultView; } }

shared void run() {
    assert(exists canvas = doc.getElementById<Canvas>("screen"));
    value context = canvas.getContext<CanvasRenderingContext2D>("2d");
    value offsetX = canvas.width / 2;
    value offsetY = canvas.height / 2;

    value bodyDrawer = BodyDrawer(context, offsetX, offsetY);
    void tick(DOMHighResTimeStamp ts) {
        context.clearRect(0.0, 0.0, canvas.width, canvas.height);
        for (body in bodiesSystem.bodies) {
            bodyDrawer.draw(body);
        }
        updateBodies();
        window.requestAnimationFrame(tick);
    }
    window.requestAnimationFrame(tick);
}

shared void updateBodies() => bodiesSystem.advance(0.05);
